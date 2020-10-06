var createError = require('http-errors');
var express = require('express');
var path = require('path');
var cookieParser = require('cookie-parser');
var morgan = require('morgan');
var indexRouter = require('./routes/index');
var usersRouter = require('./routes/users');

// Health Check Setup
const health = require('@cloudnative/health-connect');
let healthCheck = new health.HealthChecker();
const livePromise = () => new Promise((resolve, _reject) => {
  // TODO: Change to a task that determines if the app is functioning correctly
  const appFunctioning = true;
  if (appFunctioning) {
    resolve();
  } else {
    reject(new Error("App is not functioning correctly"));
  }
});

// add a liveness check
let liveCheck = new health.LivenessCheck("LivenessCheck", livePromise);
// register the liveness check
healthCheck.registerLivenessCheck(liveCheck);

// add a readiness check (verify access to dependencies. e.g. google.com)
let readyCheck = new health.PingCheck("google.com");
// register the readiness check
healthCheck.registerReadinessCheck(readyCheck);

var app = express();

// view engine setup
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'pug');

app.use(morgan('dev'));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));

app.use('/', indexRouter);
app.use('/users', usersRouter);


// register a liveness endpoint
app.use('/live', health.LivenessEndpoint(healthCheck));
// register a health endpoint
app.use('/health', health.HealthEndpoint(healthCheck));
// register the readiness endpoint
app.use('/ready', health.ReadinessEndpoint(healthCheck));

// catch 404 and forward to error handler
app.use(function(req, res, next) {
  next(createError(404));
});

// error handler
app.use(function(err, req, res, next) {
  // set locals, only providing error in development
  res.locals.message = err.message;
  res.locals.error = req.app.get('env') === 'development' ? err : {};

  // render the error page
  res.status(err.status || 500);
  res.render('error');
});

module.exports = app;

