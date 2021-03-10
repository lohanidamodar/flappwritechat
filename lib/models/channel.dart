import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:flappwritechat/models/message.dart';

class Channel {
  final String id;
  final String title;
  final List<Message> messages;
  Channel({
    this.id,
    this.title,
    this.messages,
  });

  Channel copyWith({
    String id,
    String title,
    List<Message> messages,
  }) {
    return Channel(
      id: id ?? this.id,
      title: title ?? this.title,
      messages: messages ?? this.messages,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'messages': messages?.map((x) => x?.toMap())?.toList(),
    };
  }

  factory Channel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return Channel(
      id: map['\$id'],
      title: map['title'],
      messages:  List<Message>.from((map['messages'] ?? []).map((x) => Message.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory Channel.fromJson(String source) => Channel.fromMap(json.decode(source));

  @override
  String toString() => 'Channel(id: $id, title: $title, messages: $messages)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is Channel &&
      o.id == id &&
      o.title == title &&
      listEquals(o.messages, messages);
  }

  @override
  int get hashCode => id.hashCode ^ title.hashCode ^ messages.hashCode;
}
