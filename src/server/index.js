
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
    io.emit('chat message', "test");
});

io.on('connection', socket => {
  socket.on('chat message', msg => {
    io.emit('chat message', msg);
  });
});

http.listen(port, () => {
  console.log('listening on http://localhost:' + port);
});