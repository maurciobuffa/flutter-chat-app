// To parse this JSON data, do
//
//     final messagesResponse = messagesResponseFromMap(jsonString);

import 'dart:convert';

class MessagesResponse {
  MessagesResponse({
    required this.ok,
    required this.messages,
    required this.myId,
    required this.messagesFrom,
  });

  bool ok;
  List<Message> messages;
  String myId;
  String messagesFrom;

  factory MessagesResponse.fromJson(String str) =>
      MessagesResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory MessagesResponse.fromMap(Map<String, dynamic> json) =>
      MessagesResponse(
        ok: json["ok"],
        messages:
            List<Message>.from(json["messages"].map((x) => Message.fromMap(x))),
        myId: json["myId"],
        messagesFrom: json["messagesFrom"],
      );

  Map<String, dynamic> toMap() => {
        "ok": ok,
        "messages": List<dynamic>.from(messages.map((x) => x.toMap())),
        "myId": myId,
        "messagesFrom": messagesFrom,
      };
}

class Message {
  Message({
    required this.from,
    required this.to,
    required this.message,
    required this.createdAt,
    required this.updatedAt,
    required this.uid,
  });

  String from;
  String to;
  String message;
  DateTime createdAt;
  DateTime updatedAt;
  String uid;

  factory Message.fromJson(String str) => Message.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Message.fromMap(Map<String, dynamic> json) => Message(
        from: json["from"],
        to: json["to"],
        message: json["message"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        uid: json["uid"],
      );

  Map<String, dynamic> toMap() => {
        "from": from,
        "to": to,
        "message": message,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "uid": uid,
      };
}
