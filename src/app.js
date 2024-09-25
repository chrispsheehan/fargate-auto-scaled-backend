const express = require('express');
const os = require('os');

const app = express();

const port = process.env.PORT;
const basePath = process.env.BASE_PATH || "";
const image = process.env.IMAGE || "NOT_FOUND";

app.listen(port)

app.use((req, res, next) => {
  console.log(`Request received: ${req.method} ${req.url}`);
  next();
});

app.get('/health_is_broken', (req, res) => {
  res.status(200).json({msg: "Hello, this is your API"});
});

app.get(`/${basePath}/host`, (req, res) => {
  const hostname = os.hostname();
  const currentTime = new Date().toISOString();

  res.status(200).json({
    message: `Request handled by backend at ${currentTime}`,
    imageUri: image,
    hostname: hostname
  });
});

console.log(`Listening on http://localhost:${port}`)