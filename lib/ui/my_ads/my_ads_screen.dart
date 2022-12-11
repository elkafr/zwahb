import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:zwahb/custom_widgets/no_data/no_data.dart';
import 'package:zwahb/custom_widgets/safe_area/page_container.dart';
import 'package:zwahb/locale/app_localizations.dart';
import 'package:zwahb/models/ad.dart';
import 'package:zwahb/providers/auth_provider.dart';
import 'package:zwahb/providers/my_ads_provider.dart';
import 'package:zwahb/providers/navigation_provider.dart';
import 'package:zwahb/providers/home_provider.dart';
import 'package:zwahb/ui/my_ads/widgets/my_ad_item.dart';
import 'package:zwahb/utils/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:zwahb/utils/error.dart';
import 'package:zwahb/ui/add_ad/widgets/add_ad_bottom_sheet.dart';

import 'package:zwahb/ui/ad_details/ad_details_screen.dart';


import 'dart:math' as math;
class MyAdsScreen extends StatefulWidget {
  @override
  _MyAdsScreenState createState() => _MyAdsScreenState();
}

class _MyAdsScreenState extends State<MyAdsScreen>  with TickerProviderStateMixin{
double _height = 0 , _width = 0;
NavigationProvider _navigationProvider;
HomeProvider _homeProvider;
AnimationController _animationController;

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
  return ListView(
    children: <Widget>[
         SizedBox(
            height: 80,
          ),
              Container(
          height: _height - 80,
          width: _width,
          child:  FutureBuilder<List<Ad>>(
                  future:  Provider.of<MyAdsProvider>(context,
                          listen: true)
                      .getMyAdsList() ,
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
                            errorMessage: AppLocalizations.of(context).translate('error'),
                            
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
                 height: 165,
                 width: _width,
                 child: InkWell(
                   onTap: (){
                     _homeProvider.setCurrentAds(snapshot
                         .data[index].adsId);
                     Navigator.push(
                         context,
                         MaterialPageRoute(
                             builder: (context) =>
                                 AdDetailsScreen(
                                   ad: snapshot
                                       .data[index],
                                 )));
                   },
                   child: MyAdItem(
                     ad: snapshot.data[index],
                     animation: animation,
                     animationController: _animationController,
                   )));
             }
          );
                          } else {
                            return NoData(message: AppLocalizations.of(context).translate('no_results'));
                          }
                        }
                    }
                    return Center(
                      child: SpinKitFadingCircle(color: mainAppColor),
                    );
                  })
        
        )
    ],
  );
}


@override
  Widget build(BuildContext context) {
    _height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    _width = MediaQuery.of(context).size.width;
    _navigationProvider = Provider.of<NavigationProvider>(context);
    _homeProvider = Provider.of<HomeProvider>(context);
    return PageContainer(
      child: Scaffold(
          body: Stack(
        children: <Widget>[
          _buildBodyItem(),
          Container(
              height: 60,
              decoration: BoxDecoration(
                color: accentColor,

              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    onPressed: () =>
                      Navigator.pop(context)
                    
                  ),
                 
                  Text( AppLocalizations.of(context).translate('my_ads'),
                      style: TextStyle(color: mainAppColor,fontSize: 17,fontWeight: FontWeight.bold)),
               IconButton(
                 icon:Image.asset('assets/images/newadd.png',color:mainAppColor ,),
                 onPressed: (){
                   print('sss');
                   showModalBottomSheet<dynamic>(
                       isScrollControlled: true,
                       shape: RoundedRectangleBorder(
                           borderRadius: BorderRadius.only(
                               topLeft: Radius.circular(20),
                               topRight: Radius.circular(20))),
                       context: context,
                       builder: (builder) {
                         return Container(
                             width: MediaQuery.of(context).size.width,
                             height: MediaQuery.of(context).size.height * 0.7,
                             child: AddAdBottomSheet());
                       });
                 },
               )
                ],
              )),
        ],
      )),
    );
  }
}