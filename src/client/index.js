var app = Elm.Main.init({
  node: document.getElementById('elm')
});

var socket = io();

let debugMode = true;

app.ports.sendMessage.subscribe( msg => {
  const json = JSON.stringify(msg);
  socket.emit('chat message', json);

  console.log("sendMessage: " + msg);
});

socket.on('chat message', msg => {
  app.ports.receiveMessage.send(msg);
  window.scrollTo(0, document.body.scrollHeight);

  console.log("receiveMessage: " + msg);
});

app.ports.sendLogin.subscribe( name => {
  const json = JSON.stringify(name);
  socket.emit('new login', json);

  console.log("sendLogin: " + name);
});

socket.on('new login', name => {
  app.ports.receiveLogin.send(name);
  window.scrollTo(0, document.body.scrollHeight);

  console.log("receiveLogin: " + name);
});