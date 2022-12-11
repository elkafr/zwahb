import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:zwahb/custom_widgets/no_data/no_data.dart';
import 'package:zwahb/custom_widgets/safe_area/page_container.dart';
import 'package:zwahb/locale/app_localizations.dart';
import 'package:zwahb/models/chat_message.dart';
import 'package:zwahb/providers/auth_provider.dart';
import 'package:zwahb/providers/received_msgs_provider.dart';
import 'package:zwahb/ui/my_chats/widgets/chat_item.dart';
import 'package:zwahb/utils/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:zwahb/utils/error.dart';
import 'package:zwahb/ui/home/home_screen.dart';
import 'dart:math' as math;


import 'package:zwahb/providers/navigation_provider.dart';

class MyChatsScreen extends StatefulWidget {
  @override
  _MyChatsScreenState createState() => _MyChatsScreenState();
}

class _MyChatsScreenState extends State<MyChatsScreen> with TickerProviderStateMixin{
 double _height = 0 , _width = 0;
 AnimationController _animationController;
 NavigationProvider _navigationProvider;

  @override
  void initState() {
    _animationController = AnimationController(
        duration: Duration(milliseconds: 2000), vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
 
 
Widget _buildBodyItem(){
  return SingleChildScrollView(
    child: Container(
      height: _height,
      width: _width,
      child: Column(
     
        children: <Widget>[
          SizedBox(
            height: 70,
          ),
          Expanded(
            child: FutureBuilder<List<ChatMessage>>(
                  future:  Provider.of<ReceivedMsgsProvider>(context,
                          listen: false)
                      .getReceivedMsgsList() ,
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                        return Center(
                          child: SpinKitFadingCircle(color: mainAppColor),
                        );
                      case ConnectionState.active:
                        return Text('');
                      case ConnectionState.waiting:
                        return Center(
                          child: SpinKitFadingCircle(color: mainAppColor),
                        );
                      case ConnectionState.done:
                        if (snapshot.hasError) {
                          return Error(
                           //   errorMessage: snapshot.error.toString(),
                            errorMessage: AppLocalizations.of(context).translate('error')
                          );
                        } else {
                          if (snapshot.data.length > 0) {
                     return     ListView.builder(
            itemCount: snapshot.data.length,
             itemBuilder: (BuildContext context, int index) {
               var count = snapshot.data.length;
                      var animation = Tween(begin: 0.0, end: 1.0).animate(
                        CurvedAnimation(
                          parent: _animationController,
                          curve: Interval((1 / count) * index, 1.0,
                              curve: Curves.fastOutSlowIn),
                        ),
                      );
                      _animationController.forward();
     
              return Container(
                width: _width,
                height: _height *0.17,
                child: ChatItem(
                  chatMessage: snapshot.data[index],
                  animation: animation,
                  animationController: _animationController,
                ),
              );
            }
   
          );
                          } else {
                            return NoData(message:  AppLocalizations.of(context).translate('no_results'));
                          }
                        }
                    }
                    return Center(
                      child: SpinKitFadingCircle(color: mainAppColor),
                    );
                  }),
          )
   
        

            
        ],
      ),
    ),
  );
}


@override
  Widget build(BuildContext context) {
    _height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    _width = MediaQuery.of(context).size.width;
    _navigationProvider = Provider.of<NavigationProvider>(context);
    return PageContainer(
      child: Scaffold(
          body: Stack(
        children: <Widget>[
          _buildBodyItem(),
          Container(
              height: 60,
              color: accentColor,
              child: Row(
                children: <Widget>[
                  IconButton(
                    icon: Consumer<AuthProvider>(
                      builder: (context,authProvider,child){
                        return authProvider.currentLang == 'ar' ? Image.asset(
                          'assets/images/back.png',
                          color: mainAppColor,
                        ): Transform.rotate(
                            angle: 180 * math.pi / 180,
                            child:  Image.asset(
                              'assets/images/back.png',
                              color: mainAppColor,
                            ));
                      },
                    ),
                    onPressed: () {
                      _navigationProvider.upadateNavigationIndex(0);
                      Navigator.pushNamed(context,  '/navigation');
                    },
                  ),
                  Spacer(
                    flex: 2,
                  ),
                  Text( AppLocalizations.of(context).translate('my_chats'),
                      style: TextStyle(color: mainAppColor,fontSize: 17,fontWeight: FontWeight.bold)),
                  Spacer(
                    flex: 3,
                  ),
                ],
              )),
        ],
      )),
    );
  }
}