import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:zwahb/custom_widgets/safe_area/page_container.dart';
import 'package:zwahb/locale/app_localizations.dart';
import 'package:zwahb/providers/auth_provider.dart';
import 'package:zwahb/utils/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:zwahb/providers/terms_provider.dart';
import 'package:zwahb/utils/error.dart';
import 'dart:math' as math;

import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as dom;

class TermsAndRulesScreen extends StatefulWidget {
  @override
  _TermsAndRulesScreenState createState() => _TermsAndRulesScreenState();
}

class _TermsAndRulesScreenState extends State<TermsAndRulesScreen> {
double _height = 0 , _width = 0;


Widget _buildBodyItem(){
  return ListView(
   
    children: <Widget>[
      SizedBox(
        height: 80,
      ),
        Container(
         alignment: Alignment.center,
         margin: EdgeInsets.only(bottom: _height *0.02),
         child:  Image.asset('assets/images/logo.png',height:_height *0.15 ,
         fit: BoxFit.cover,
        ),
       ),
        Container(
            margin: EdgeInsets.symmetric(horizontal: _width *0.04),
            child: Divider(),
         ),

      SizedBox(
        height: 20,
      ),

      FutureBuilder<String>(
          future: Provider.of<TermsProvider>(context,
              listen: false)
              .getTerms() ,
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
                    //  errorMessage: snapshot.error.toString(),
                    errorMessage:  AppLocalizations.of(context).translate('error'),
                  );
                } else {
                  return Container(
                      margin:
                      EdgeInsets.symmetric(horizontal: _width * 0.04),
                      child: Html(data: snapshot.data));
                }
            }
            return Center(
              child: SpinKitFadingCircle(color: mainAppColor),
            );
          })

        
    ],
  );
}

@override
  Widget build(BuildContext context) {
    _height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    _width = MediaQuery.of(context).size.width;
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
                      Navigator.pop(context);
                    },
                  ),
                  Spacer(
                    flex: 2,
                  ),
                  Text( AppLocalizations.of(context).translate('rules_and_terms'),
                      style: TextStyle(color: mainAppColor,fontSize: 17,fontWeight: FontWeight.bold)),
                  Spacer(
                    flex: 3,
                  ),
                ],
              ))
        ],
      )),
    );
  }
}