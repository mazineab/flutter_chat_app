class Message {
  String? uid;
  String? messageContent;
  String? senderId;
  bool? isRead;
  DateTime? createAt;

  Message({
    this.uid,
    this.messageContent,
    this.senderId,
    this.isRead,
    this.createAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      uid: json['uid'],
      messageContent: json['messageContent'],
      senderId: json['senderId'],
      isRead: json['read'],
      createAt: DateTime.parse(json['createAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'messageContent': messageContent,
      'senderId': senderId,
      'read': isRead,
      'createAt': createAt?.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'Message{uid: $uid, messageContent: $messageContent, senderId: $senderId, isRead: $isRead, createAt: $createAt}';
  }
}
