part of 'chat_bloc.dart';

abstract class ChatState {
  List<List<Message>> chatHistory;
  List<Message> messages;
  ChatCompletionRequest? request;
  ChatState({required this.messages, this.request, required this.chatHistory});
}

class ChatInitial extends ChatState {
  ChatInitial()
      : super(
            messages: [],
            request: null,
            chatHistory: LocalStorage.loadChatHistory());
}

class ChatLoading extends ChatState {
  ChatLoading(
      {required super.messages, required ChatCompletionRequest super.request})
      : super(
            chatHistory: LocalStorage.loadChatHistory());
}

class ChatGenerating extends ChatState {
  ChatGenerating({
    required super.messages,
  }) : super(
            request: null,
            chatHistory: LocalStorage.loadChatHistory());
}

class ChatLoaded extends ChatState {
  ChatLoaded({
    required super.messages,
  }) : super(
            request: null,
            chatHistory: LocalStorage.loadChatHistory());
}

class ChatError extends ChatState {
  final String error;
  @override
  final List<Message> messages;
  ChatError(this.error, this.messages)
      : super(
            messages: messages,
            request: null,
            chatHistory: LocalStorage.loadChatHistory());
}

class ChatClosed extends ChatState {
  @override
  List<List<Message>> chatHistory;
  ChatClosed({required this.chatHistory})
      : super(messages: [], request: null, chatHistory: chatHistory);
}
