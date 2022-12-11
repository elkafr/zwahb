import 'package:flutter/material.dart';
import 'package:zwahb/models/chat_msg_between_members.dart';

import 'package:zwahb/models/user.dart';
import 'package:zwahb/networking/api_provider.dart';
import 'package:zwahb/providers/auth_provider.dart';
import 'package:zwahb/utils/urls.dart';


class ChatProvider extends ChangeNotifier{
  User _currentUser;
  String _currentLang;

  void update(AuthProvider authProvider) {
    _currentUser = authProvider.currentUser;
    _currentLang = authProvider.currentLang;
  }

ApiProvider _apiProvider = ApiProvider();


  Future<List<ChatMsgBetweenMembers>> getChatMessageList(String senderId) async {
    final response = await _apiProvider.get(Urls.BETWEEN_MESSAGES_URL +
        '?user_id=${_currentUser.userId}&user_id1=$senderId&page=1&api_lang=$_currentLang');
    List<ChatMsgBetweenMembers> messageList = List<ChatMsgBetweenMembers>();
    if (response['response'] == '1') {
      Iterable iterable = response['messages'];
      messageList = iterable.map((model) => ChatMsgBetweenMembers.fromJson(model)).toList();
    }

    return messageList;
  }

  bool _isLoading = false;  
  void setIsLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  } 
   bool get isLoading => _isLoading;

}