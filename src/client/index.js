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



app.ports.sendMessage.subscribe( msg => {
  const json = JSON.stringify(msg);
  socket.emit('chat message', json);

  debugPrint("sendMessage: " + msg);
});

socket.on('chat message', msg => {
  app.ports.receiveMessage.send(msg);
  window.scrollTo(0, document.body.scrollHeight);

  debugPrint("receiveMessage: " + msg);
});


// name : string
app.ports.sendLogin.subscribe( name => {
  socket.emit('attempt login', name);

  debugPrint("attemptLogin: " + name);
});

socket.on('success login', id => {
  app.ports.receiveLoginSuccess.send(id);
  debugPrint("successLogin: " + id);
});

socket.on('failed login', msg => {
  app.ports.receiveLoginFailed.send(msg);
  debugPrint("successLogin: " + msg);
});

socket.on('new login', name => {
  app.ports.receiveLogin.send(name);
  window.scrollTo(0, document.body.scrollHeight);

  debugPrint("receiveLogin: " + name);
});


socket.on('server log', json => {
  app.ports.loginResult.send(json);
  window.scrollTo(0, document.body.scrollHeight);

  debugPrint("loginResult: " + najsonme);
});
