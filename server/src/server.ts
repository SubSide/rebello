import { WebSocket, WebSocketServer } from 'ws';
import { User } from './model/User';
import { Monolith } from './Monolith';
import { Message } from './model/Message';

const wss = new WebSocketServer({ port: 8080 });
const monolith = new Monolith();

wss.on('connection', (ws) => {
  let user: User|null = null;


  ws.on('close', () => {
    if (user) {
      monolith.removeUser(user);
    }
  });

  ws.on('message', (rawMessage) => {
    const message: Message = JSON.parse(rawMessage.toString());
    console.debug(`Received message, type: ${message.target}, info: ${message.info}`);

    if (message.target === 'server' && message.info === 'introduce') {
      if (monolith.users.find(user => user?.userUuid === message.data)) {
        console.error('User already exists');
        return;
      }

      // Make sure message data is an uuid
      if (typeof message.data !== 'string' || message.data.length !== 36) {
        console.error('Invalid user uuid');
        return
      }

      console.debug('User introduced as =>', message.data);
      user = new User(ws, message.data);
      monolith.addUser(user);
      return;
    }

    if (!user) {
      console.error('User not introduced');
      return;
    }

    try {
      monolith.handleMessage(user, message);
    } catch (error) {
      console.error('Error handling message =>', error);
    }
  });
});