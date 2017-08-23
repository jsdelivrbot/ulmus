const express = require('express');
const http = require('http');
const websocket = require('websocket');

const ws = websocket.Server({ port: 8085 });
const host = 'http://auction-api-us.worldofwarcraft.com';

ws.on('connection', connection);

function connection(ws) {
    ws.on('message', incoming.bind(this, ws));
}

function incoming(ws, message) {
    if(message.match(/auction/i)) {
        fetchAuctions(message, (chunk) => {
            ws.send(chunk);
        }, () => {

        });
    }
}

function fetchAuctions(path, onData, onEnd) {
    return http.get(host + path)
        .on('data', onData)
        .on('end', onEnd);
}
