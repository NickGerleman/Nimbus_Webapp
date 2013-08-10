var fs = require('fs'),
    http = require('http'),
    faye = require('faye'),
	redis = require('faye-redis'),
	crypto = require('crypto'),
    url = require('url');
	
fs.writeFile('/tmp/faye.pid', process.pid);

var server = new faye.NodeAdapter({
  mount: '/api/socket',
  timeout: 45,
  engine: {
	  type: redis,
	  host: url.parse(process.env.REDIS_URL).hostname
	}
});

server.addExtension({
  incoming: function(message, callback) {
    if (message.channel === '/meta/subscribe' || !message.channel.match(/^\/meta\//)) {
	  var hmac = crypto.createHmac('sha1', process.env.SOCKET_KEY),
          token = message.ext && message.ext.auth_token,
          channel, expected;
      if(message.channel === '/meta/subscribe')
        channel = message.subscription.slice(1);
      else
        channel = message.channel.slice(1);
      expected = hmac.update(channel).digest('hex');
	  if(expected !== token && token !== process.env.SOCKET_MASTER)
	    message.error = '403::Invalid Token';
    }
    callback(message);
  }
});

server.addExtension({
  outgoing: function(message, callback) {
    if(message.ext)
      delete message.ext.auth_token;
    callback(message);
  }
});

faye.Logging.logLevel = 'warn';
server.listen(8081);
