var config = require('./config.json');

var fs = require('fs');
var minilog = require('minilog');
var namespace = 'REC: ' + new Date().toUTCString();
var logger = minilog(namespace);

minilog.pipe(fs.createWriteStream(config.logFile));

var MongoOplog = require('mongo-oplog')
const oplog = MongoOplog(config.mongoDbUri, { ns: 'imdb.entity' })
const http = require('http');

var collectionsToSync = [
        "openacdagentgroup",
        "openacdagent",
        "openacdsettings",
        "openacdreleasecode",
        "openacdqueue",
        "openacdqueuegroup",
        "openacdskill",
        "openacdclient",
        "openacdpermissionprofile",
        "freeswitchmediacommand",
        "openacdagentconfigcommand"
]

oplog.tail();

oplog.on('op', function(data) {
});

oplog.on('insert', function(doc) {
  var changedCollection = doc.o._id.replace(/\d+/g, '').toLowerCase();
  refreshCollection(changedCollection);
});

oplog.on('update', function(doc) {
  var changedCollection = doc.o2._id.replace(/\d+/g, '').toLowerCase();
  refreshCollection(changedCollection);
});

oplog.on('delete', function(doc) {
  var changedCollection = doc.o._id.replace(/\d+/g, '').toLowerCase();
  refreshCollection(changedCollection);
});

oplog.on('error', function(error) {
  logger.error(error);
});

oplog.on('end', function() {
  logger.info('Stream ended');
});

oplog.stop(function() {
  logger.info('server stopped');
});

function refreshCollection(changedCollection) {
  if (collectionsToSync.indexOf(changedCollection) > -1) {
    logger.info("updating " + changedCollection);
    http.get({
      hostname: 'localhost',
      port: 8937,
      path: '/api/reload/'+changedCollection,
    }, function(res) {
      logger.info("Reloading Reach collection " + changedCollection + " returned code: " + res.statusCode);
    });
  }
}
