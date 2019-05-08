
const express = require('express');
const app = express();
const http = require('http').Server(app);
const io = require('socket.io')(http);
let path = require('path');
var AsyncLock = require('async-lock');

let createUser = (userID, name) => {
  return { userID: userID, name: name};
};

const logsListLock = new AsyncLock();
let logsList = [];

async function receiveMessage(msg) {
  console.log("Message: " + msg);
  io.emit('chat message', msg);
  let handleLogsList = () => {
    logsList.push(msg);
  }
  logsListLock.acquire(key, handleLogsList);
};

const userTableLock = new AsyncLock();
let nextUsserId = 0;
let usertable = [];

async function receiveAttepmtLogin(name) {
  let isSuccessLogin = true;
  if (isSuccessLogin) {
    let userID;
    let handleUserTable = () => {
      userID = nextUsserId;
      nextUsserId++;
      usertable.push(userJson);
    };

    await userTableLock.acquire(key, handleUserTable);
    
    io.to(socket.id).emit('success login', userID);
  
    let userJson = createUser(userID, name)
    socket.broadcast.emit('new login', JSON.stringify(userJson));
    console.log("Login: " + JSON.stringify(userJson));
    
    let handleLogsList = () => {
      logsList.push(userJson);
  
      // TODO: ログを送る
      io.to(socket.id).emit('server log', JSON.stringify(logs));
    };

    await logsListLock.acquire(key, handleLogsList);

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
    receiveMessage(msg);
  });

  socket.on('attempt login', name => {
      receiveAttepmtLogin(name);
  });
});

let port = process.env.PORT || 3000;
http.listen(port, () => {
  console.log('listening on http://localhost:' + port);
});