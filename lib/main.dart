import 'package:chat_alpha/pages/chat_page.dart';
import 'package:chat_gpt_flutter/chat_gpt_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/chat_bloc.dart';
import 'local_storage.dart';
import 'pages/home_page.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorage.init();
  final chatGpt = ChatGpt(
    apiKey: "your-api-key",
  );
  runApp(BlocProvider(
    create: (context) => ChatBloc(chatGpt: chatGpt),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        routes: {
          '/': (context) => const HomePage(),
          '/chat': (context) {
            final args = ModalRoute.of(context)!.settings.arguments as Map;
            ChatPageArguments arg = ChatPageArguments(
                args['promptText'] ?? "", args['messages'] ?? []);

            return ChatPage(
                promptedText: arg.promptedText, messages: arg.messages);
          }
        });
  }
}

class ChatPageArguments {
  final String? promptedText;
  final List<Message>? messages;
  ChatPageArguments(this.promptedText, this.messages);
}
