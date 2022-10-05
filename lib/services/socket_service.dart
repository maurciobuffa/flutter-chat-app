import 'package:chat_app/global/environment.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus {
  Online,
  Offline,
  Connecting,
}

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.Connecting;
  late IO.Socket _socket;

  ServerStatus get serverStatus => _serverStatus;
  IO.Socket get socket => _socket;
  get emit => _socket.emit;

  set serverStatus(ServerStatus serverStatus) {
    _serverStatus = serverStatus;
    notifyListeners();
  }

  void connect() async {
    final token = await AuthService.getToken();

    _socket = IO.io(Environment.sockedURL, {
      "transports": ["websocket"],
      "autoConnect": true,
      "forceNew": true,
      "extraHeaders": {
        "x-token": token,
      },
    });
    _socket.onConnect((_) {
      serverStatus = ServerStatus.Online;
      print("connect");
    });
    _socket.onDisconnect((_) {
      serverStatus = ServerStatus.Offline;
    });
  }

  void disconnect() {
    _socket.disconnect();
  }
}
