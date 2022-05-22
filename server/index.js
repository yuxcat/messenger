const httpServer = require("http").createServer();
const Redis = require("ioredis");
const redisClient = new Redis();
const io = require("socket.io")(httpServer, {
  cors: {
    origin: '*',
  },
  adapter: require("socket.io-redis")({
    pubClient: redisClient,
    subClient: redisClient.duplicate(),
  }),
});

const { setupWorker } = require("@socket.io/sticky");
const crypto = require("crypto");
const randomId = () => crypto.randomBytes(8).toString("hex");

const { RedisSessionStore } = require("./sessionStore");
const sessionStore = new RedisSessionStore(redisClient);

const { RedisMessageStore } = require("./messageStore");
const messageStore = new RedisMessageStore(redisClient);

io.use(async (socket, next) => {
  const sessionID = socket.handshake.auth.sessionID;
  if (sessionID) {
    const session = await sessionStore.findSession(sessionID);
    if (session) {
      console.log("found a session");
      console.log(session.username);
      socket.sessionID = sessionID;
      socket.userID = session.userID;
      socket.username = session.username;
      socket.type = session.type;
      console.log(socket.type);
      return next();
    }
    console.log("nice", sessionID);
  }
  const username = socket.handshake.auth.username;
  const userID = socket.handshake.auth.uid;
  const type = socket.handshake.auth.role;
  console.log("typess");
  console.log(type);
  if (!username) {
    console.log("invalid ....");
    return next(new Error("invalid username"));
    
  }
  socket.sessionID = randomId();
  socket.userID = userID;
  socket.username = username;
  socket.type = type;
  next();
});

io.on("connection", async function (socket) {
  console.log('client connected ... ', socket.id)
  // persist session
  sessionStore.saveSession(socket.sessionID, {
    userID: socket.userID,
    username: socket.username,
    connected: true,
    type: socket.type,
  });

  // emit session details
  socket.emit("session", {
    sessionID: socket.sessionID,
    userID: socket.userID,
  });

  // join the "userID" room
  socket.join(socket.userID);

  // fetch existing users
  const users = [];
  const [messages, sessions] = await Promise.all([
    messageStore.findMessagesForUser(socket.userID),
    sessionStore.findAllSessions(),
  ]);
  const messagesPerUser = new Map();
  messages.forEach((message) => {
    const { from, to } = message;
    const otherUser = socket.userID === from ? to : from;
    if (messagesPerUser.has(otherUser)) {
      messagesPerUser.get(otherUser).push(message);
    } else {
      messagesPerUser.set(otherUser, [message]);
    }
  });

  sessions.forEach((session) => {
    users.push({
      userID: session.userID,
      username: session.username,
      connected: session.connected,
      messages: messagesPerUser.get(session.userID) || [],
      type: session.type,
    });
  });
  io.emit("users", users);

  // notify existing users
  socket.broadcast.emit("user_connected", {
    userID: socket.userID,
    username: socket.username,
    connected: true,
    messages: [],
    type:socket.type,
  });

  // forward the private message to the right recipient (and to other tabs of the sender)
  socket.on("message", function name ({ content, to }) {
    const message = {
      content,
      from: socket.userID,
      to,
      
    };
    socket.to(to).to(socket.userID).emit("dispatch", message);
    socket.emit("self", message);
    console.log(socket.userID);
    messageStore.saveMessage(message);
  });

  // notify users upon disconnection
  socket.on("disconnect", async () => {
    const matchingSockets = await io.in(socket.userID).allSockets();
    const isDisconnected = matchingSockets.size === 0;
    if (isDisconnected) {
      // notify other users
      socket.broadcast.emit("user disconnected", socket.userID);
      // update the connection status of the session
      sessionStore.saveSession(socket.sessionID, {
        userID: socket.userID,
        username: socket.username,
        connected: false,
        type: socket.type,
      });
    }
  });
});

setupWorker(io);