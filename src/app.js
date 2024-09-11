
const express = require('express');
const os = require('os');

const app = express();

const port = process.env.PORT;

app.listen(port)

app.use((req, res, next) => {
  console.log(`Request received: ${req.method} ${req.url}`);
  next();
});

app.get('/hello', (req, res) => {
  res.status(200).json({msg: "Hello, this is your API"});
});

app.get('/host', (req, res) => {
    const networkInterfaces = os.networkInterfaces();
    const ipAddress = networkInterfaces.eth0 ? networkInterfaces.eth0[0].address : 'Unknown IP';
  
    res.status(200).json({
        message: 'Request handled by this container',
        ipAddress: ipAddress
    });
});

console.log(`Listening on http://localhost:${port}`)