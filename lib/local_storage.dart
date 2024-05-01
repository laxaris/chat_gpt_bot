import 'dart:convert';
import 'package:chat_gpt_flutter/chat_gpt_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static SharedPreferences? _preferences;

  static Future init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static Future saveChatHistory(List<List<Message>> chatHistory) async {
    List<String> historyJson = chatHistory
        .map((list) => jsonEncode(list.map((msg) => msg.toJson()).toList()))
        .toList();
    await _preferences?.setStringList('chat_history', historyJson);
  }

  static Future saveChat(List<Message> messages) async {
    List<List<Message>> chatHistory = loadChatHistory();
    chatHistory.add(messages);
    await saveChatHistory(chatHistory);
  }

  static List<List<Message>> loadChatHistory() {
    List<String>? historyJson = _preferences?.getStringList('chat_history');
    return historyJson
            ?.map((listAsString) => (jsonDecode(listAsString) as List)
                .map((item) => Message.fromJson(item))
                .toList())
            .toList() ??
        [];
  }

  static Future removeChatAtIndex(int index) async {
    List<List<Message>> chatHistory = loadChatHistory();
    if (index >= 0 && index < chatHistory.length) {
      chatHistory
          .removeAt(index); // Remove the chat session at the specified index
      await saveChatHistory(chatHistory); // Save the updated chat history
    }
  }

  static Future clearHistory() async {
    await _preferences?.remove('chat_history');
  }
}
