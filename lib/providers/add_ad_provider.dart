import 'package:flutter/material.dart';
import 'package:zwahb/networking/api_provider.dart';
import 'package:zwahb/providers/auth_provider.dart';
import 'package:zwahb/utils/urls.dart';

  class AddAdProvider extends ChangeNotifier {

  String _currentLang;

  void update(AuthProvider authProvider) {
    _currentLang = authProvider.currentLang;
  }
    ApiProvider _apiProvider = ApiProvider();
  Future<List<String>> getAdPromises() async {
    final response =
        await _apiProvider.get(Urls.PROMISES_URL + "?api_lang=$_currentLang" );
    List<String> promisesList = List<String>();
    if (response['response'] == '1') {
    
      promisesList.add(response['messages']['1']);
       promisesList.add(response['messages']['2']);
        promisesList.add(response['messages']['3']);
         promisesList.add(response['messages']['4']);
    }
    return promisesList;
  }
  }