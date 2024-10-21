import { Group } from "./model/Group";
import { Message } from "./model/Message";
import { User } from "./model/User";

export class Monolith {
    readonly users: User[] = [];
    private readonly groups: Group[] = [];

    private static readonly TICK_INTERVAL = 15_000;

    constructor() {
        setInterval(() => this.tick(), Monolith.TICK_INTERVAL);
    }

    addUser(user: User) {
        console.debug('New user connected!');
        this.users.push(user);
    }

    removeUser(user: User) {
        console.debug('User disconnected!');
        const index = this.users.indexOf(user);
        if (index !== -1) {
            this.users.splice(index, 1);
        }
        user.cleanup();
    }

    handleMessage(user: User, message: Message) {
        user.updateLastAlive();

        if (message.source !== user.userUuid) {
            user.cleanup();
            console.error('User not allowed to send messages on behalf of others');
            return;
        }

        if (message.target === 'server') {
            if (message.info === 'subscribe') {
                console.debug('User subscribed to new topic');
                let group = this.groups.find(group => group.groupId === message.data);
                if (!group) {
                    console.debug('Topic requested did not yet exist, creating...');
                    group = new Group(message.data);
                    this.groups.push(group);
                }

                group.addUser(user);
                user.addGroup(group);
            } else if (message.info === 'unsubscribe') {
                console.debug('User unsubscribed from topic');
                const group = this.groups.find(group => group.groupId === message.data);
                if (group) {
                    group.removeUser(user);
                    user.removeGroup(group);
                }
            }
        } else if(message.target === 'group') {
            user.handleMessage(message);
        } else if(message.target === 'user') {
            const targetUser = this.users.find(user => user.userUuid === message.info);
            if (targetUser) {
                targetUser.sendMessage(message);
            } else {
                console.error(`Could not find user with id ${message.info}`);
            }
        } else {
            console.error(`Unknown target ${message.target}`);
        }
    }

    tick() {
        console.log(`Ticking...`);
        this.users.forEach(user => {
            if (user.isDead()) {
                console.log(`A user is dead, cleaning up...`);
                user.cleanup();
                const index = this.users.indexOf(user);
                if (index !== -1) {
                    this.users.splice(index, 1);
                }
            }
        });

        this.groups.forEach(group => {

            if (group.users.length === 0 || group.users.every(user => user.isDead())) {
                console.log(`A group is empty, cleaning up...`);
                const index = this.groups.indexOf(group);
                if (index !== -1) {
                    this.groups.splice(index, 1);
                }
            }
        });

        console.log(`Ticking done!`);
        console.log(`Rooms active: ${this.groups.length}, Users active: ${this.users.length}`);
    }
}
