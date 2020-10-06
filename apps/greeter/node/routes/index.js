var express = require('express');
var os = require("os");
const app = require('../app');
const log = require('../logger.js');
var router = express.Router();
var hostName = os.hostname();
var count = 0;
var formatter = new Intl.DateTimeFormat('en-us', {
  year: 'numeric',
  month: 'numeric',
  day: 'numeric',
  hour: 'numeric',
  minute: 'numeric',
  second: 'numeric',
  hour12: false
});
/* GET home page. */
router.get('/', function(req, res, next) {
  count++;
  greeting = `Hi greeter => '${hostName}' : ${count} : ${formatter.format(Date.now())}\n`;
  log.info(`User Message Received: ${greeting}`);
  res.send(greeting);
  // Render response from index.pug template
  // res.render('index', { title: 'Express', hostName: hostName, viewCount: count });
});

/* POST home page. */
router.post('/', function(req, res, next) {
  count++;
  greeting = `{"host":"Event greeter => '${hostName}' : ${count}", "time":"${formatter.format(Date.now())}"}`;
  log.info(`Event Message Received: ${greeting}`);
  res.send(greeting);
});

module.exports = router;
