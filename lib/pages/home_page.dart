import 'package:chat_alpha/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:chat_gpt_flutter/chat_gpt_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/chat_bloc.dart';

List<List<Message>> chatHistory = LocalStorage.loadChatHistory();

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData = MediaQuery.of(context);
    double w = queryData.size.width / 432;
    double h = queryData.size.height / 932;
    //LocalStorage.clearHistory();
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: const Color.fromRGBO(247, 222, 165, 1),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 50 * h),
                  Image.asset(
                    'lib/assets/logo.png',
                    width: 75 * w,
                    height: 75 * w,
                  ),
                  SizedBox(height: 30 * h),
                  Text(
                    'Explore knowledge with \nAI chat',
                    style: TextStyle(
                        fontSize: 32 * w, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 30 * h),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/chat', arguments: {});
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 0),
                      backgroundColor: Colors.yellow[700],
                      foregroundColor: Colors.black,
                      padding: EdgeInsets.symmetric(
                          horizontal: 5 * w, vertical: 5 * w),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40 * w),
                      ),
                    ),
                    child: Container(
                        child: Row(
                      children: [
                        SizedBox(width: 20 * w),
                        Text('New Chat',
                            style: TextStyle(
                                fontSize: 16 * w, fontWeight: FontWeight.bold)),
                        const Spacer(),
                        Icon(size: 50 * w, Icons.arrow_circle_right_rounded),
                      ],
                    )),
                  ),
                  SizedBox(height: 30 * w),
                  Row(
                    children: [
                      Text(
                        'Chat History',
                        style: TextStyle(
                            fontSize: 24 * w, fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      Text("See all",
                          style: TextStyle(
                              fontSize: 16 * w,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey)),
                      SizedBox(width: 10 * w),
                    ],
                  ),
                  SizedBox(height: 10 * h),
                  SizedBox(
                    height: 100 * h,
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 8 * w,
                          mainAxisSpacing: 8 * w,
                          childAspectRatio: 0.32),
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: state.chatHistory.length,
                      itemBuilder: (context, index) {
                        return ChatHistoryCard(
                            messages: state.chatHistory[index], index: index);
                      },
                    ),
                  ),
                  SizedBox(height: 30 * h),
                  Row(
                    children: [
                      Text(
                        'Popular Prompt',
                        style: TextStyle(
                            fontSize: 24 * w, fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      Text("See all",
                          style: TextStyle(
                              fontSize: 16 * w,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey)),
                      SizedBox(width: 10 * w),
                    ],
                  ),
                  SizedBox(height: 10 * h),
                  SizedBox(
                    height: 275 * h,
                    child:
                        ListView(scrollDirection: Axis.horizontal, children: [
                      const PromptCard(
                          title: 'Explain about Sushi Roll receipt',
                          author: 'Kanny.low'),
                      SizedBox(width: 20 * w),
                      const PromptCard(
                          title: 'Give the best resolution 2024',
                          author: 'Jon jenny'),
                    ]),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class ChatHistoryCard extends StatelessWidget {
  List<Message> messages;
  int index;
  ChatHistoryCard({super.key, required this.messages, required this.index});

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData = MediaQuery.of(context);
    double w = queryData.size.width / 432;
    double h = queryData.size.height / 932;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black, // Button color
        foregroundColor: Colors.white,
        padding: EdgeInsets.all(8 * w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30 * w),
        ),
        // Text color
      ),
      onPressed: () async {
        BlocProvider.of<ChatBloc>(context)
            .add(HistoryRemoveEvent(index: index));
        Navigator.pushNamed(context, '/chat', arguments: {
          'messages': messages,
        });
      },
      child: Text(
        messages[0].content.length > 15
            ? "${messages[0].content.substring(0, 14)}..."
            : messages[0].content,
      ),
    );
  }
}

class PromptCard extends StatelessWidget {
  final String title;
  final String author;

  const PromptCard({super.key, required this.title, required this.author});

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData = MediaQuery.of(context);
    double w = queryData.size.width / 432;
    double h = queryData.size.height / 932;
    return Container(
      width: 200 * w,
      padding: EdgeInsets.all(8 * w),
      margin: EdgeInsets.symmetric(vertical: 4 * h),
      decoration: BoxDecoration(
        color: Colors.pink[100],
        borderRadius: BorderRadius.circular(30 * w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 20 * h),
          Text(title,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24 * w,
                  color: Colors.black)),
          SizedBox(height: 20 * h),
          Text(author),
          SizedBox(height: 20 * h),
          Center(
            child: TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all(Colors.black),
                backgroundColor: MaterialStateProperty.all(Colors.white),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/chat', arguments: {
                  'promptText': title,
                });
              },
              child: const Text(
                'Use this prompt',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
