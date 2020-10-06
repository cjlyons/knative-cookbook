var bunyan = require('bunyan');
var log = bunyan.createLogger({
    name: 'greeter',
    stream: process.stdout,
    level: 'info'
});
log.info("Logging with Bunyan");
module.exports = log;