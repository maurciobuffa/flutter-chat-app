import 'package:chat_app/global/environment.dart';
import 'package:chat_app/models/messages_response.dart';
import 'package:chat_app/models/user.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChatService extends ChangeNotifier {
  late User _userTo;
  User get userTo => _userTo;
  set userTo(User user) {
    _userTo = user;
    notifyListeners();
  }

  Future<List<Message>> getChat(String userId) async {
    final response = await http
        .get(Uri.parse('${Environment.apiUrl}/messages/$userId'), headers: {
      'Content-Type': 'application/json',
      'x-token': await AuthService.getToken() ?? ""
    });

    final messagesResp = MessagesResponse.fromJson(response.body);

    return messagesResp.messages;
  }

  List<String> _messages = [];

  List<String> get messages => _messages;
  void addMessage(String message) {
    _messages.add(message);
    notifyListeners();
  }
}
