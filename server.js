const express = require('express');
const http = require('http');

const app = express();

const host = 'http://auction-api-us.worldofwarcraft.com';

app.use((req, res) => {
    const fullUrl = host + req.path;

    res.header("Access-Control-Allow-Origin", "*");
    res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");


    http.request(fullUrl, auctionRes => {
        // let data = '';
        auctionRes.on('data', chunk => {
            // data += chunk;
            res.write(chunk);
        });

        auctionRes.on('end', () => {
            // res.send(data);
        });
    }).end();
});

app.listen(8085);
