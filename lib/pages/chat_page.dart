import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:chat_gpt_flutter/chat_gpt_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/chat_bloc.dart';

class ChatPage extends StatelessWidget {
  String? promptedText;
  List<Message>? messages;
  ChatPage({super.key, this.promptedText, this.messages});
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData = MediaQuery.of(context);
    double w = queryData.size.width / 432;
    double h = queryData.size.height / 932;
    _textController.text = promptedText ?? "";

    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        if (state is ChatInitial) {
          state.messages = messages ?? [];
        }
        if (state is ChatGenerating || state is ChatLoading) {
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () async {
                  BlocProvider.of<ChatBloc>(context).add(HistoryAddEvent(
                    messages: state.messages,
                  ));
                  Navigator.pop(context);
                },
              ),
              toolbarHeight: 40 * h,
              backgroundColor: const Color.fromRGBO(247, 222, 165, 1),
              title: const Text(
                "ChatBot",
                style: TextStyle(color: Colors.black, fontSize: 20),
              ),
            ),
            backgroundColor: const Color.fromRGBO(30, 30, 30, 0),
            body: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.messages.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            state.messages[index].role == Role.user.name
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      const Text(
                                        "Me",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 12),
                                      ),
                                      SizedBox(
                                        width: 24 * w,
                                      ),
                                    ],
                                  )
                                : Row(
                                    children: [
                                      SizedBox(
                                        width: 24 * w,
                                      ),
                                      const Text(
                                        "Bot",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 12),
                                      ),
                                    ],
                                  ),
                            BubbleSpecialThree(
                                text: state.messages[index].content,
                                textStyle: TextStyle(
                                    color: state.messages[index].role ==
                                            Role.user.name
                                        ? const Color.fromARGB(255, 61, 61, 61)
                                        : Colors.white),
                                isSender: state.messages[index].role ==
                                    Role.user.name,
                                color:
                                    state.messages[index].role == Role.user.name
                                        ? Colors.white
                                        : const Color.fromARGB(255, 61, 61, 61)),
                          ],
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8 * w),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.white,
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.stop_circle_rounded),
                            onPressed: () {
                              BlocProvider.of<ChatBloc>(context)
                                  .add(ChatStopMessage());
                              _textController.clear();
                            },
                          ),
                          focusColor: Colors.lightGreen,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          hintText: 'Type here ...',
                        ),
                        controller: _textController,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () async {
                BlocProvider.of<ChatBloc>(context).add(HistoryAddEvent(
                  messages: state.messages,
                ));
                Navigator.pop(context);
              },
            ),
            toolbarHeight: 40 * h,
            backgroundColor: const Color.fromRGBO(255, 234, 186, 1),
            title: const Text(
              "ChatBot",
              style: TextStyle(color: Colors.black, fontSize: 20),
            ),
          ),
          backgroundColor: const Color.fromRGBO(30, 30, 30, 0),
          body: Padding(
            padding: EdgeInsets.all(25.0 * w),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: state.messages.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          state.messages[index].role == Role.user.name
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    const Text(
                                      "Me",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 12),
                                    ),
                                    SizedBox(
                                      width: 24 * w,
                                    ),
                                  ],
                                )
                              : Row(
                                  children: [
                                    SizedBox(
                                      width: 24 * w,
                                    ),
                                    const Text(
                                      "Bot",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 12),
                                    ),
                                  ],
                                ),
                          BubbleSpecialThree(
                              text: state.messages[index].content,
                              textStyle: TextStyle(
                                  color: state.messages[index].role ==
                                          Role.user.name
                                      ? const Color.fromARGB(255, 61, 61, 61)
                                      : Colors.white),
                              isSender:
                                  state.messages[index].role == Role.user.name,
                              color:
                                  state.messages[index].role == Role.user.name
                                      ? Colors.white
                                      : const Color.fromARGB(255, 61, 61, 61)),
                        ],
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.white,
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.send),
                          onPressed: () {
                            BlocProvider.of<ChatBloc>(context).add(
                                ChatSendMessage(
                                    message: Message(
                                        role: Role.user.name,
                                        content: _textController.text)));
                            _textController.clear();
                          },
                        ),
                        focusColor: Colors.lightGreen,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        hintText: 'Type here ...',
                      ),
                      controller: _textController,
                      onSubmitted: (value) {
                        BlocProvider.of<ChatBloc>(context).add(ChatSendMessage(
                            message:
                                Message(role: Role.user.name, content: value)));
                        _textController.clear();
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
