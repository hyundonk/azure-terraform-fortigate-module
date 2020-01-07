// server.js : node.js web server that returns HTTP response after "wait_in_sec"
// This web server can be used to test "tcp reset" feature of Azure standard load balancer.
// how to use
// 1. Install system-sleep package in advance
//   "npm install system-sleep"
// 2. Run web server by calling 
//   "nodejs server.js [sleep-in-sec]"

const http = require('http');
const sleep = require('system-sleep');

const hostname = '127.0.0.1';
const port = 80;
const server = http.createServer()

// node.js http webserver has inactvity timeout value (default 120sec) after which webserver sends TCP ack to client. 
// ref) https://nodejs.org/api/http.html#http_server_timeout
server.timeout = 0;

var myArgs = process.argv.slice(2);
var wait_in_sec = myArgs[0];

console.log('send http response after', wait_in_sec, 'sec');

server.on('request', function(request, response){
  console.log("request received wait " + wait_in_sec + "sec");
  sleep(wait_in_sec * 1000);

  response.writeHead(200);
  console.log(request.method);
  console.log(request.headers);
  console.log(request.url);
  response.write('hello');
  response.end();

});

server.listen(port, () => {
  console.log('Server running at http://' + hostname + ":" + port);
});
