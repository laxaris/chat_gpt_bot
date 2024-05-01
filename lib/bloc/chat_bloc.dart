import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chat_alpha/local_storage.dart';
import 'package:chat_gpt_flutter/chat_gpt_flutter.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatGpt chatGpt;
  StreamSubscription<StreamCompletionResponse>?
      chatSubscription; // Store the subscription

  ChatBloc({required this.chatGpt}) : super(ChatInitial()) {
    on<HistoryAddEvent>((event, emit) {
      if (event.messages.isNotEmpty) {
        chatSubscription
            ?.cancel(); // Cancel the subscription when stopping the chat
        LocalStorage.saveChat(state.messages);
        emit(ChatInitial());
      }
    });
    on<HistoryRemoveEvent>((event, emit) {
      chatSubscription
          ?.cancel(); // Cancel the subscription when stopping the chat
      LocalStorage.removeChatAtIndex(event.index);
      emit(ChatInitial());
    });
    on<ChatStopMessage>((event, emit) {
      chatSubscription
          ?.cancel(); // Cancel the subscription when stopping the chat
      emit(ChatLoaded(messages: state.messages));
    });

    on<ChatSendMessage>((event, emit) async {
      emit(ChatLoading(
          messages: state.messages + [event.message],
          request: ChatCompletionRequest(
            maxTokens: 1000,
            messages: state.messages + [event.message],
            stream: true,
            model: ChatGptModel.gpt4.modelName,
          )));

      String gptResponse = "";
      List<Message> messages = state.messages + [event.message];
      final index = state.messages.length;

      try {
        Completer completer = Completer();
        Stream<StreamCompletionResponse>? responseStream =
            await chatGpt.createChatCompletionStream(state.request!);
        chatSubscription =
            responseStream?.listen((StreamCompletionResponse response) {
          final choices = response.choices;
          if (choices != null && choices.isNotEmpty) {
            final choice = choices.first;
            final text = choice.delta?.content ?? "";

            gptResponse += text;
            messages[index] =
                Message(role: Role.assistant.name, content: gptResponse);
            emit(ChatGenerating(messages: messages));
          } else {
            print("Received empty response");
          }
        }, onError: (error) {
          print("An error occurred: $error");
          emit(ChatError("An error occurred while processing your message.",
              state.messages));
        }, onDone: () {
          completer.complete();
        });
        await completer.future;
        emit(ChatLoaded(messages: messages));
      } catch (error) {
        print("An error occurred while setting up the stream: $error");
        emit(ChatError("Failed to establish stream.", state.messages));
      }
    });

    // Note: No need for Completer or catchError if using subscriptions directly
  }

  @override
  Future<void> close() {
    chatSubscription?.cancel(); // Ensure to cancel subscription on bloc close
    return super.close();
  }
}
