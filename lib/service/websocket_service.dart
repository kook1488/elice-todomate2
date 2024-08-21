import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  late WebSocketChannel channel;
  Function(Map<String, dynamic>)? onMessageReceived;
  Function(String)? onError;
  bool isConnected = false;

  void connect(String url) {
    channel = WebSocketChannel.connect(Uri.parse(url));
    isConnected = true;

    channel.stream.listen((message) {
      try {
        final decodedMessage = json.decode(message.trim()); // trim() 추가
        print('Received decoded message: $decodedMessage');
      } catch (e) {
        print('Error decoding JSON: $e');
        print('Received raw message: $message');
      }
    });

  }

  void sendMessage(Map<String, dynamic> message) {
    if (isConnected) {
      channel.sink.add(json.encode(message));
    } else {
      if (onError != null) {
        onError!("Cannot send message, WebSocket is not connected.");
      }
    }
  }

  void close() {
    if (isConnected) {
      channel.sink.close();
      isConnected = false;
    }
  }
}
