enum MessageType { text, audio, image }

extension MessageTypeExtension on MessageType {
  String get toValue {
    switch (this) {
      case MessageType.text:
        return 'Text';
      case MessageType.image:
        return 'Image';
      case MessageType.audio:
        return "Audio";
    }
  }

  String get value {
    switch (this) {
      case MessageType.text:
        return 'text';
      case MessageType.image:
        return 'image';
      case MessageType.audio:
        return 'audio';
    }
  }
}

MessageType getType(String? type) {
  switch (type) {
    case 'Text':
      return MessageType.text;
    case 'Image':
      return MessageType.image;
    case 'Audio':
      return MessageType.audio;
    default:
      return MessageType.text;
  }
}
