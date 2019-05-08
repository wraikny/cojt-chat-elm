var app = Elm.Main.init({
  node: document.getElementById('elm')
});

var socket = io();

let debugMode = true;

let debugPrint = x => {
  if(debugMode) {
    console.log(x);
  }
};


/// msg : json
app.ports.sendMessage.subscribe( msg => {
  const json = JSON.stringify(msg);
  socket.emit('chat message', json);

  debugPrint("sendMessage: " + msg);
});

// json : stringified json
socket.on('chat message', json => {
  app.ports.receiveMessage.send(json);
  window.scrollTo(0, document.body.scrollHeight);

  debugPrint("receiveMessage: " + json);
});


// name : string
app.ports.sendLogin.subscribe( name => {
  socket.emit('attempt login', name);

  debugPrint("attemptLogin: " + name);
});

// id : int
socket.on('success login', id => {
  app.ports.receiveLoginSuccess.send(id);
  debugPrint("successLogin: " + id);
});

// msg : string
socket.on('failed login', msg => {
  app.ports.receiveLoginFailed.send(msg);
  debugPrint("successLogin: " + msg);
});

// json : stringified json
socket.on('new login', json => {
  app.ports.receiveLogin.send(json);
  window.scrollTo(0, document.body.scrollHeight);

  debugPrint("receiveLogin: " + json);
});

// json : stringified json
socket.on('server log', json => {
  app.ports.receiveServerLog.send(json);
  window.scrollTo(0, document.body.scrollHeight);

  debugPrint("loginResult: " + json);
});
