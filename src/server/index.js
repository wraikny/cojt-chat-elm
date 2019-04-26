
const express = require('express');
const app = express();
const http = require('http').Server(app);
const io = require('socket.io')(http);
var path = require('path');
var port = process.env.PORT || 3001;

app.use(
  express.static(
    path.resolve(__dirname + '/../client')
  )
);

app.get('/', (req, res) => {
  res.sendFile( path.resolve(__dirname + '/../client/index.html') );
});

io.on('connection', socket => {
  socket.on('chat message', msg => {
    console.log("Message: " + msg);
    io.emit('chat message', msg);
  });

  socket.on('new login', name => {
    console.log("Login: " + name);
    io.emit('new login', name);
  });
});

http.listen(port, () => {
  console.log('listening on http://localhost:' + port);
});