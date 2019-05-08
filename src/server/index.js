
const express = require('express');
const app = express();
const http = require('http').Server(app);
const io = require('socket.io')(http);
let path = require('path');

let createUser = (userID, name) => {
  return { userID: userID, name: name};
};

let logsList = [];

let nextUsserId = 0;
let usertable = [];


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

      let userID = nextUsserId;
      nextUsserId++;

      io.to(socket.id).emit('success login', userID);

      let userJson = createUser(userID, name)
      usertable.push( userJson );
      console.log("Login: " + JSON.stringify(userJson));

      logsList.push(userJson);

      socket.broadcast.emit('new login', JSON.stringify(userJson));

      // TODO: ログを送る
      // let log = "";
      // io.to(socket.id).emit('server log', log);
    } else {
      io.to(socket.id).emit('failed login', "something message");
    }
  });
});

let port = process.env.PORT || 3000;
http.listen(port, () => {
  console.log('listening on http://localhost:' + port);
});