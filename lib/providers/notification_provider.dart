
import 'package:zwahb/models/notification_message.dart';
import 'package:zwahb/models/user.dart';
import 'package:zwahb/networking/api_provider.dart';
import 'package:zwahb/providers/auth_provider.dart';
import 'package:zwahb/utils/urls.dart';
import 'package:flutter/material.dart';
  
  class NotificationProvider extends ChangeNotifier {
    ApiProvider _apiProvider = ApiProvider();
    User _currentUser;  
   String _currentLang;


  void update(AuthProvider authProvider) {
    _currentUser = authProvider.currentUser;
    _currentLang = authProvider.currentLang;
  }

  Future<List<NotificationMsg>> getMessageList() async {
    final response = await _apiProvider.get(Urls.NOTIFICATION_URL +
        '?user_id=${_currentUser.userId}&page=1&api_lang=$_currentLang');
    List<NotificationMsg> messageList = List<NotificationMsg>();
    if (response['response'] == '1') {
      Iterable iterable = response['messages'];
      messageList = iterable.map((model) => NotificationMsg.fromJson(model)).toList();
    }

    return messageList;
  }

  }