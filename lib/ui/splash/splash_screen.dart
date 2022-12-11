import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:zwahb/providers/auth_provider.dart';
import 'package:zwahb/providers/home_provider.dart';
import 'package:zwahb/shared_preferences/shared_preferences_helper.dart';
import 'package:provider/provider.dart';




class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _height = 0, _width = 0;
  AuthProvider _authProvider;
  LocationData _locData;
  HomeProvider _homeProvider;
  
    Future initData() async {
    await Future.delayed(Duration(seconds: 2));
  }


   Future<void> _getLanguage() async {
    String currentLang = await SharedPreferencesHelper.getUserLang();
    _authProvider.setCurrentLanguage(currentLang);
  }


  Future<void> _getCurrentUserLocation() async {
    _locData = await Location().getLocation();
    if(_locData != null){
      print('lat' + _locData.latitude.toString());
      print('longitude' + _locData.longitude.toString());

      setState(() {
        _homeProvider.setLatValue(_locData.latitude.toString());
        _homeProvider.setLongValue(_locData.longitude.toString());

      });
    }
  }


  @override
  void initState() {
    super.initState();
    _getCurrentUserLocation();
      _getLanguage();
    initData().then((value) {
      Navigator.pushReplacementNamed(context,  '/navigation');
    });
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _authProvider = Provider.of<AuthProvider>(context);
    _homeProvider = Provider.of<HomeProvider>(context);
    return Scaffold(
      body: Image.asset(
        'assets/images/splash.png',
        fit: BoxFit.fill,
        height: _height,
        width: _width,
      ),
    );
  }
}
