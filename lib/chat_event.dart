import 'package:equatable/equatable.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class SendMessageEvent extends ChatEvent {
  final String sender;
  final String recipient;
  final String content;

  const SendMessageEvent({
    required this.sender,
    required this.recipient,
    required this.content,
  });

  @override
  List<Object> get props => [sender, recipient, content];
}

class LoadMessagesEvent extends ChatEvent {}
