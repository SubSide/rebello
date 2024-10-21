import { Message } from "./Message";
import { User } from "./User";

export class Group {
    readonly users: User[] = [];

    constructor(readonly groupId: string) {
    }

    addUser(user: User): void {
        this.users.push(user);
    }

    removeUser(user: User): void {
        const index = this.users.indexOf(user);
        if (index !== -1) {
            this.users.splice(index, 1);
        }
    }

    broadcast(fromUser: User, message: Message): void {
        if (!this.users.includes(fromUser)) {
            return;
        }
        
        this.users.forEach(user => {
            if (user !== fromUser) {
                user.sendMessage(message);
            }
        });
    }
}