const http = require("http");

const PORT = 3000;

const server = http.createServer((req, res) => {
  res.writeHead(200, { "Content-Type": "text/plain" });
  res.end("Tetroxide is alive ⚡\n");
});

server.listen(PORT, () => {
  console.log(`HTTP server running on port ${PORT}`);
});
