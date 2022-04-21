const app = require('express')();
const http = require('http').Server(app);
const io = require('socket.io')(http);
const port = process.env.PORT || 3000;

io.on('connection', function (client) {


  // middleware
  io.use((client, next) => {
    const username = client.handshake.auth.username;
    if (!username) {
      return next(new Error("invalid username"));
    }
    client.username = username;
    console.log(client.username);
    next();
  })

  // upon connection
  const users = [];
  for (let [id, socket] of io.of("/").sockets) {
    users.push({
      userID: id,
      username: socket.username,
    });
  }
  io.emit('users', users);
  console.log(users);

  // connections

    console.log('client connect...', client.id);
  
    client.on('typing', function name(data) {
      console.log(data);
      io.emit('typing', data)
    })
  
    client.on('message', function name(data) {
      console.log(data);
      io.emit('message', data)
    })

    client.on('send_message', function name (msg) {

      to = msg.to
      content = msg.content
      

      client.to(to).emit("message", content);
      console.log(to, content);
        
    })
  
    client.on('location', function name(data) {
      console.log(data);
      io.emit('location', data);
    })
  
    client.on('connect', function () {
    })
  
    client.on('disconnect', function () {
      console.log('client disconnect...', client.id)
      // handleDisconnect()
    })
  
    client.on('error', function (err) {
      console.log('received error from client:', client.id)
      console.log(err)
    })
  })

http.listen(port, function (err) {
    if (err) throw err
    console.log('Listening on port %d', port);
  });