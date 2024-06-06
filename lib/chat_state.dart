import 'package:equatable/equatable.dart';
import 'message.dart'; // Import your Message model

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object> get props => [];
}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatLoaded extends ChatState {
  final List<Message> messages;

  const ChatLoaded(this.messages);

  @override
  List<Object> get props => [messages];
}

class ChatError extends ChatState {
  final String error;

  const ChatError(this.error);

  @override
  List<Object> get props => [error];
}
