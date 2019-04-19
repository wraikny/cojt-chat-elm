var app = Elm.Main.init({
  node: document.getElementById('elm')
});

var socket = io();

app.ports.sendMessage.subscribe( msg => {
  socket.emit('chat message', msg);
});

socket.on('chat message', msg => {
  app.ports.receiveMessage.send(msg);
  window.scrollTo(0, document.body.scrollHeight);
});