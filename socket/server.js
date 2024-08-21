const express = require('express');
const http = require('http');
const socketIo = require('socket.io');
const path = require('path');

// Express 앱 초기화
const app = express();
const server = http.createServer(app);
const io = socketIo(server);

// 정적 파일 제공
app.use(express.static(path.join(__dirname, 'public')));

// 기본 HTTP 라우트
app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'index.html'));
});

// Socket.IO 설정
io.on('connection', (socket) => {
  console.log('A user connected: ' + socket.id);

  console.log('Sending socket ID to client:', socket.id);

  // 룸에 가입
  socket.on('joinRoom', (room) => {
    socket.join(room);
    console.log(`User joined room: ${room}`);
  });

  // 메시지 받기
  socket.on('sendMessage', (message, room) => {
    console.log('Message received:', message);

    // 룸 내 모든 클라이언트에게 메시지 브로드캐스팅
    io.to(room).emit('receiveMessage', message);
  });

  // 사용자 연결 해제
  socket.on('disconnect', () => {
    console.log('User disconnected: ' + socket.id);
  });
});

// 서버 실행
const PORT = process.env.PORT || 3000;
server.listen(PORT, '0.0.0.0', () => {
  console.log(`Server running on port ${PORT}`);
});