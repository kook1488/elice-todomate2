const WebSocket = require('ws');

// WebSocket 서버를 포트 8080에서 생성
const wss = new WebSocket.Server({ port: 8080 });

// 연결된 클라이언트 수를 추적하는 변수
let connectedClients = 0;

wss.on('connection', function connection(ws) {
  // 클라이언트가 연결되면 클라이언트 수 증가
  connectedClients++;
  console.log('Client connected. Total clients:', connectedClients);

  // 클라이언트에게 현재 연결된 클라이언트 수를 전송
  ws.send(JSON.stringify({ message: 'Welcome! Total connected clients: ' + connectedClients }));

  // 클라이언트로부터 메시지를 수신할 때 호출되는 핸들러
  ws.on('message', (message) => {
    console.log('Received message:', message); // 수신한 메시지 로그 출력

    try {
      // 수신한 메시지를 JSON으로 파싱
      const data = JSON.parse(message);
      console.log('Parsed data:', data); // 파싱된 데이터 로그 출력

      // 모든 클라이언트에게 메시지 브로드캐스트
      wss.clients.forEach(function each(client) {
        if (client !== ws && client.readyState === WebSocket.OPEN) {
          // 데이터를 JSON 문자열로 변환하여 전송
          client.send(JSON.stringify(data));
        }
      });

      // 클라이언트에게 응답 메시지 전송
      ws.send(JSON.stringify({ id: "test-id", isCompleted: true }));
    } catch (error) {
      console.error('Error processing message:', error); // 오류 처리
    }
  });

  // 클라이언트가 연결을 종료했을 때 호출되는 핸들러
  ws.on('close', () => {
    connectedClients--; // 연결된 클라이언트 수 감소
    console.log('Client disconnected. Total clients:', connectedClients);
  });

  // WebSocket 오류 처리
  ws.on('error', (error) => {
    console.error('WebSocket error:', error);
  });
});

console.log('WebSocket server is running on ws://localhost:8080');
