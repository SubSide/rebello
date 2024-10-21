export type Message = {
    source: string;
    target: string;
    info: string;
    data: string;
}

export const SERVER_TARGET: String = 'server';
export const GROUP_TARGET: String = 'group';
export const USER_TARGET: String = 'user';