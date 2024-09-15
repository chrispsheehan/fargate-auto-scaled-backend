
const express = require('express');
const os = require('os');

const app = express();

const port = process.env.PORT;

app.listen(port)

app.use((req, res, next) => {
  console.log(`Request received: ${req.method} ${req.url}`);
  next();
});

app.get('/health', (req, res) => {
  res.status(200).json({msg: "Hello, this is your API"});
});

app.get('/host', (req, res) => {
  const hostname = os.hostname();
  res.status(200).json({
    message: 'Request handled by this container',
    hostname: hostname
  });
});

console.log(`Listening on http://localhost:${port}`)

