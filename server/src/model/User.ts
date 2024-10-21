import { WebSocket } from 'ws';
import { Group } from './Group';
import { Message } from './Message';

export class User {
    private static readonly TIME_TO_LIVE = 15 * 60 * 1000; // 15 minutes
    readonly userUuid: string;
    private readonly ws: WebSocket;
    private readonly groups: Group[] = [];
    private lastAlive: number = Date.now();

    constructor(ws: WebSocket, userUuid: string) {
        this.ws = ws;
        this.userUuid = userUuid;
    }

    handleMessage(message: Message): void {
        
        this.groups.find(group => group.groupId === message.info)?.broadcast(this, message);
    }

    sendMessage(message: Message): void {
        this.ws.send(JSON.stringify(message));
    }

    addGroup(group: Group): void {
        this.groups.push(group);
    }

    removeGroup(group: Group): void {
        const index = this.groups.indexOf(group);
        if (index !== -1) {
            this.groups.splice(index, 1);
        }
    }

    updateLastAlive(): void {
        this.lastAlive = Date.now();
    }

    isDead(): boolean {
        return Date.now() - this.lastAlive > User.TIME_TO_LIVE || this.ws.readyState === WebSocket.CLOSED;
    }

    cleanup(): void {
        this.groups.forEach(group => group.removeUser(this));
        this.ws.close();
    }
}
