var app = Elm.Main.init({
  node: document.getElementById('elm')
});

var socket = io();

let debugMode = true;

let debugLog = msg => {
  if(debugMode) {
    console.log(msg);
  }
};

app.ports.sendMessage.subscribe( msg => {
  socket.emit('chat message', msg);
  debugLog("sendMessage: " + msg);
});

socket.on('chat message', msg => {
  app.ports.receiveMessage.send(msg);
  window.scrollTo(0, document.body.scrollHeight);
  debugLog("receiveMessage: " + msg);
});

app.ports.sendLogin.subscribe( name => {
  socket.emit('new login', name);
  debugLog("sendLogin: " + name);
});

socket.on('new login', name => {
  app.ports.receiveLogin.send(name);
  window.scrollTo(0, document.body.scrollHeight);
  debugLog("receiveLogin: " + name);
});