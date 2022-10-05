import 'dart:io';

import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/chat_service.dart';
import 'package:chat_app/services/socket_service.dart';
import 'package:chat_app/widgets/chat_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final _textController = TextEditingController();
  final _focusNode = FocusNode();

  late AuthService authService;
  late ChatService chatService;
  late SocketService socketService;

  final List<ChatMessage> _messages = [];

  bool _isWriting = false;

  @override
  void initState() {
    super.initState();
    authService = Provider.of<AuthService>(context, listen: false);
    chatService = Provider.of<ChatService>(context, listen: false);
    socketService = Provider.of<SocketService>(context, listen: false);
    chatService = Provider.of<ChatService>(context, listen: false);

    socketService.socket.on('private-message', _listenMessage);

    _loadHistory(chatService.userTo.uid);
  }

  void _loadHistory(String userId) async {
    final history = await chatService.getChat(userId);
    final historyMessages = history.map((m) => ChatMessage(
          text: m.message,
          uid: m.from,
          animationController: AnimationController(
              vsync: this, duration: const Duration(milliseconds: 0))
            ..forward(),
        ));
    setState(() {
      _messages.insertAll(0, historyMessages);
    });
  }

  @override
  Widget build(BuildContext context) {
    // final chatService = Provider.of<ChatService>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Column(children: [
          CircleAvatar(
            backgroundColor: Colors.blue[100],
            maxRadius: 14,
            child: Text(chatService.userTo.name.substring(0, 2),
                style: const TextStyle(fontSize: 12)),
          ),
          const SizedBox(height: 3),
          Text(chatService.userTo.name,
              style: const TextStyle(color: Colors.black87, fontSize: 12))
        ]),
        centerTitle: true,
        // elevation: 1,
      ),
      body: Container(
        child: Column(
          children: [
            Flexible(
                child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    reverse: true,
                    itemCount: _messages.length,
                    itemBuilder: (_, i) {
                      return _messages[i];
                    })),
            const Divider(
              height: 1,
            ),
            Container(
              color: Colors.white,
              child: _inputChat(),
            )
          ],
        ),
      ),
    );
  }

  _inputChat() {
    return SafeArea(
      child: Container(
        height: 50,
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: (_) {
                  _handleSubmit(_textController.text);
                },
                onChanged: (value) {
                  if (value.trim().isNotEmpty) {
                    setState(() {
                      _isWriting = true;
                    });
                  } else {
                    setState(() {
                      _isWriting = false;
                    });
                  }
                },
                decoration: InputDecoration.collapsed(hintText: 'Send message'),
                focusNode: _focusNode,
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              child: Platform.isIOS
                  ? CupertinoButton(
                      child: Text('Send'),
                      onPressed: _isWriting
                          ? () => _handleSubmit(_textController.text)
                          : null,
                    )
                  : Container(
                      margin: EdgeInsets.symmetric(horizontal: 4.0),
                      child: IconTheme(
                        data: IconThemeData(color: Colors.blue[400]),
                        child: IconButton(
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          icon: Icon(Icons.send),
                          onPressed: _isWriting
                              ? () => _handleSubmit(_textController.text)
                              : null,
                        ),
                      ),
                    ),
            )
          ],
        ),
      ),
    );
  }

  _handleSubmit(String text) {
    if (text.isEmpty) return;
    _textController.clear();
    _focusNode.requestFocus();

    final newMessage = ChatMessage(
        text: text,
        uid: authService.user.uid,
        animationController: AnimationController(
            vsync: this, duration: Duration(milliseconds: 200)));
    _messages.insert(0, newMessage);
    newMessage.animationController.forward();

    setState(() {
      _isWriting = false;
    });

    socketService.socket.emit('private-message', {
      'from': authService.user.uid,
      'to': chatService.userTo.uid,
      'message': text
    });
  }

  @override
  void dispose() {
    for (ChatMessage message in _messages) {
      message.animationController.dispose();
    }
    socketService.socket.off('private-message');
    super.dispose();
  }

  _listenMessage(data) {
    if (data['from'] == chatService.userTo.uid) {
      ChatMessage message = ChatMessage(
          text: data['message'],
          uid: data['from'],
          animationController: AnimationController(
              vsync: this, duration: Duration(milliseconds: 200)));
      setState(() {
        _messages.insert(0, message);
      });
      message.animationController.forward();
    }
  }
}
