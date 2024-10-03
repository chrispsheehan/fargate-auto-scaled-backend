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
  const duration = parseInt(req.params.duration, 10); // in seconds

  if (percent < 0 || percent > 100) {
    return res.status(400).json({ error: "Percent must be between 0 and 100" });
  }

  const startTime = Date.now();
  const endTime = startTime + duration * 1000;

  const cpuIntensiveTask = () => {
    // Simulate CPU-intensive task for the specified duration and percentage
    while (Date.now() < endTime) {
      // Work for `percent` of the time, then idle for the remaining `100 - percent` time
      const workEndTime = Date.now() + (percent / 100) * 1000;
      while (Date.now() < workEndTime) {
        // Simulating work by doing empty loops
        Math.random();
      }

      // Idle for the remaining time (simulate CPU usage lower than 100%)
      const idleEndTime = Date.now() + ((100 - percent) / 100) * 1000;
      while (Date.now() < idleEndTime) {
        // Idle - not using CPU
      }
    }
  };

  // Run the CPU-intensive task in a non-blocking way
  setTimeout(cpuIntensiveTask, 0);

  res.status(200).json({ message: `Simulating ${percent}% CPU usage for ${duration} seconds` });
});

console.log(`Listening on http://localhost:${port}`)
