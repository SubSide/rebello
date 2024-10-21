# Rebello

An open-source push-to-talk walkie-talkie app focussed on privacy and security, encrypted with the Signal group
protocol.

## Goal

This project exists because current applications on the market does not provide group encryption
while this is a basic feature that should be available to everyone.

## Features

These are the features that are currently implemented and the ones that are planned to be implemented.

- [X]  Push-to-talk
- [X]  Group encryption through Signal protocol
- [X]  Joining groups through QR code
- [ ]  Persistence over restarts
- [ ]  Other ways of joining group, like through a text block shared over other (secure) channels
- [ ]  Some moderation tools
- [ ]  Using push-to-talk while the app is in the background
- [ ]  Showing the app while the phone is locked
- [ ]  Using push-to-talk through the button on the earphones
- [ ]  Add option to export logs for debugging

## Research needed to be done

- Find out if we can dumb down the server even more
  - Is there a way to not have the server know which devices are connected?
  - Is there a way to not have the server know which groups exist?
  - Is there a way to not have the server know which devices are in which groups?
  - Is there a way to not have the server know to where messages are going?
- Perhaps move from a group-based subscription to a list of devices a message needs to be sent to to further reduce the server's knowledge?
  - Although this would make you still send a list of devices you want to talk to, so does it really reduce the server's knowledge?

## Hard requirements for this project

- The `app` shall always be open-source and free to use
- The `app` shall always be able to be self-hosted
- The `app` shall never ask for any personal information
  - This means that there will never be any login or registration
  - The only information that is `optionally` asked for is a username, for the convenience to know who is talking
- The `app` shall never make any network requests except for the core functionality of this app
  - This means that the app shall not have any analytics, ads, crash reporting, or any other tracking
    - If we want to know why the app crashes, we need to add a way to export the logs
- The `server` will only be used to relay the messages,
  - the server will never have any access to these messages
  - The server will never have any encryption keys except for the obvious ones like for a TLS connection
  - This means that going to the core of the server it has the following responsibilities:
    - In charge of sending the messages to the correct devices
    - In charge of sending the messages to the correct groups
  - This means that (at this point) the server will only have the following information:
    - The devices that are connected
    - An identifier for every device so they can be reached
      - This identifier will be a UUID that will be newly generated every time the app connects to a server
    - An unique identifier of the groups that exist and which devices are connected to it
  - We will keep no logs whatsoever
