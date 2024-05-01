part of 'chat_bloc.dart';

abstract class ChatEvent {}

class ChatSendMessage extends ChatEvent {
  final Message message;
  ChatSendMessage({required this.message});
}

class ChatStopMessage extends ChatEvent {}

class HistoryAddEvent extends ChatEvent {
  final List<Message> messages;
  HistoryAddEvent({required this.messages});
}

class HistoryRemoveEvent extends ChatEvent {
  final int index;
  HistoryRemoveEvent({required this.index});
}

class HistoryClearEvent extends ChatEvent {}
