import 'package:melonandmelon/main.dart';
import 'package:melonandmelon/utilities/packages.dart';
import 'package:socket_io_client/socket_io_client.dart';

abstract class SocketTemplate {
  Future<void> connect();
  Future<void> disconnect();
  Future<void> sendMessage(String message);
  Stream<String> get messageStream;
}

// Socket socket = io('https://84.247.174.84/ecoville/');
Socket socket = io(
    'http://84.247.174.84:4005',
    OptionBuilder().setTransports(['websocket']).setExtraHeaders({
      'user': APP_USER,
    }).build());

class SocketRepository extends SocketTemplate {
  @override
  Future<void> connect() async {
    try {
      socket.connect();

      socket.onConnect((data) {
        logger.d("User connected successfully");
      });

      socket.onConnectError((data) {
        logger.e('Connection error: $data');
      });
      socket.onConnectTimeout((data) {
        logger.e('Connection timeout: $data');
      });
      socket.onDisconnect((data) {
        logger.e('Disconnected: $data');
      });
      socket.onError((data) {
        logger.e('Error: $data');
      });
      return;
    } catch (e) {
      logger.e(e.toString());
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> disconnect() {
    // TODO: implement disconnect
    throw UnimplementedError();
  }

  @override
  // TODO: implement messageStream
  Stream<String> get messageStream => throw UnimplementedError();

  @override
  Future<void> sendMessage(String message) {
    // TODO: implement sendMessage
    throw UnimplementedError();
  }
}
