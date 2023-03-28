// ignore_for_file: public_member_api_docs, sort_constructors_first
class Message {
  final String message;
  final bool isUser;
  final DateTime createdAt;
  
  Message({
    required this.message,
    required this.isUser,
    required this.createdAt,
  });
}
