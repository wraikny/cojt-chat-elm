
const express = require('express');
const app = express();
const http = require('http').Server(app);
const io = require('socket.io')(http);
let path = require('path');
var AsyncLock = require('async-lock');

let createUser = (userID, name) => {
  return { userID: userID, name: name};
};

let logsList = [];

const userTableLock = new AsyncLock();
let nextUsserId = 0;
let usertable = [];

async function receiveAttepmtLogin(name) {
  let isSuccessLogin = true;
  if (isSuccessLogin) {
    await userTableLock.acquire(key, () => {
      let userID = nextUsserId;
      nextUsserId++;

      io.to(socket.id).emit('success login', userID);

      let userJson = createUser(userID, name)
      usertable.push(userJson);
      console.log("Login: " + JSON.stringify(userJson));

      logsList.push(userJson);

      socket.broadcast.emit('new login', JSON.stringify(userJson));
    });
    // TODO: ログを送る
    io.to(socket.id).emit('server log', JSON.stringify(logs));
  } else {
    io.to(socket.id).emit('failed login', "something message");
  }
}

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
      receiveAttepmtLogin(name);
  });
});

let port = process.env.PORT || 3000;
http.listen(port, () => {
  console.log('listening on http://localhost:' + port);
});