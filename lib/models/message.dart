import 'dart:convert';

class Message {
  final String content;
  final String id;
  final String senderId;
  final String senderName;
  Message({
    required this.content,
    required this.id,
    required this.senderId,
    required this.senderName,
  });

  Message copyWith({
    String? content,
    String? id,
    String? senderId,
    String? senderName,
  }) {
    return Message(
      content: content ?? this.content,
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'content': content,
      'id': id,
      'senderId': senderId,
      'senderName': senderName,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {  
    return Message(
      content: map['content'],
      id: map['id'] ?? '',
      senderId: map['senderId'],
      senderName: map['senderName'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Message.fromJson(String source) => Message.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Message(content: $content, id: $id, senderId: $senderId, senderName: $senderName)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is Message &&
      o.content == content &&
      o.id == id &&
      o.senderId == senderId &&
      o.senderName == senderName;
  }

  @override
  int get hashCode {
    return content.hashCode ^
      id.hashCode ^
      senderId.hashCode ^
      senderName.hashCode;
  }
}
