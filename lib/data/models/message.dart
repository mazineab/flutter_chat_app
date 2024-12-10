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
      isRead: json['isRead'],
      createAt: json['createAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'messageContent': messageContent,
      'senderId': senderId,
      'read': isRead,
      'createAt': createAt,
    };
  }
}
