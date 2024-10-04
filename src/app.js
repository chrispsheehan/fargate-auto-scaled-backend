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

app.get('/health', (req, res) => {
  res.status(200).json({msg: "Hello, this is your API"});
});

app.get(`/${basePath}/host`, (req, res) => {
  const hostname = os.hostname();
  const currentTime = new Date().toISOString();

  res.status(200).json({
    message: `Request handled by backend at ${currentTime}`,
    imageUri: image,
    hostname: hostname,
    update: 'badger'
  });
});

app.get(`/${basePath}/stress-cpu/:percent/:duration`, (req, res) => {
  const percent = parseInt(req.params.percent, 10);
  const duration = parseInt(req.params.duration, 10);
  const hostname = os.hostname();

  if (percent < 0 || percent > 100) {
    return res.status(400).json({ error: "Percent must be between 0 and 100" });
  }

  const workTime = (percent / 100) * 1000;
  const totalDuration = duration * 1000;
  const endTime = Date.now() + totalDuration;

  const simulateLoad = () => {
    if (Date.now() >= endTime) {
      clearInterval(interval);
      return;
    }

    const workEndTime = Date.now() + workTime;
    while (Date.now() < workEndTime) {
      Math.random();
    }
  };

  const interval = setInterval(simulateLoad, 1000);

  res.status(200).json({ 
    message: `Simulating ${percent}% CPU usage for ${duration} seconds`,
    host: hostname
  });
});

console.log(`Listening on http://localhost:${port}`)
