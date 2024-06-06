import 'package:flutter_bloc/flutter_bloc.dart';
import 'chat_event.dart';
import 'chat_state.dart';
import 'websocket_service.dart';
import 'message.dart'; // Import your Message model

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final WebSocketService webSocketService;

  ChatBloc(this.webSocketService) : super(ChatInitial()) {
    on<SendMessageEvent>(_onSendMessageEvent);
    on<LoadMessagesEvent>(_onLoadMessagesEvent);
  }

  Future<void> _onSendMessageEvent(SendMessageEvent event, Emitter<ChatState> emit) async {
    try {
      webSocketService.sendMessage(event.sender, event.recipient, event.content);
      final currentState = state;
      if (currentState is ChatLoaded) {
        final updatedMessages = List<Message>.from(currentState.messages)
          ..add(Message(sender: event.sender, content: event.content));
        emit(ChatLoaded(updatedMessages));
      } else {
        add(LoadMessagesEvent());
      }
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  Future<void> _onLoadMessagesEvent(LoadMessagesEvent event, Emitter<ChatState> emit) async {
    emit(ChatLoading());
    try {
      final messages = await webSocketService.loadMessages();
      emit(ChatLoaded(messages));
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }
}
