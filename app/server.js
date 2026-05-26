const express = require('express');
const os = require('os');
const path = require('path');

const app = express();
const PORT = process.env.PORT || 3000;
const INSTANCE_NAME = process.env.INSTANCE_NAME || 'demo-instance';

app.use(express.static(path.join(__dirname, 'public')));

function getServerIp() {
  const interfaces = os.networkInterfaces();

  for (const addresses of Object.values(interfaces)) {
    for (const address of addresses || []) {
      const isIPv4 = address.family === 'IPv4';
      const isUsable = !address.internal && address.address !== '127.0.0.1';

      if (isIPv4 && isUsable) {
        return address.address;
      }
    }
  }

  return '127.0.0.1';
}

function formatTimestamp(date = new Date()) {
  const pad = (value) => String(value).padStart(2, '0');

  return [
    `${date.getFullYear()}-${pad(date.getMonth() + 1)}-${pad(date.getDate())}`,
    `${pad(date.getHours())}:${pad(date.getMinutes())}:${pad(date.getSeconds())}`
  ].join(' ');
}

app.get('/api/info', (req, res) => {
  res.json({
    server_ip: getServerIp(),
    hostname: os.hostname(),
    timestamp: formatTimestamp(),
    instance_name: INSTANCE_NAME
  });
});

app.listen(PORT, () => {
  console.log(`Load balancer demo listening on port ${PORT}`);
});
