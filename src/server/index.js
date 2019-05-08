
const express = require('express');
const app = express();
const http = require('http').Server(app);
const io = require('socket.io')(http);
var path = require('path');
var port = process.env.PORT || 3001;

var logsList = [];

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
    logsList.push(msg);
    io.emit('chat message', msg);
  });

  socket.on('attempt login', name => {
    // TODO: ユーザーリストを確認
    let isSuccessLogin = true;
    if(isSuccessLogin) {
      let userid = 0;
      console.log("Login: " + name);
      logsList.push(name);
  
      socket.broadcast.emit('new login', name)
      
      io.to(socket.id).emit('success login', userid);
  
      // TODO: ログを送る
      let log = "";
      io.to(socket.id).emit('server log', log);
    } else {
      io.to(socket.id).emit('failed login', "something message");
    }
  });
});

http.listen(port, () => {
  console.log('listening on http://localhost:' + port);
});