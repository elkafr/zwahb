import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:zwahb/custom_widgets/buttons/custom_button.dart';
import 'package:zwahb/custom_widgets/custom_text_form_field/custom_text_form_field.dart';
import 'package:zwahb/custom_widgets/custom_text_form_field/validation_mixin.dart';
import 'package:zwahb/custom_widgets/dialogs/confirmation_dialog.dart';
import 'package:zwahb/custom_widgets/dialogs/location_dialog.dart';
import 'package:zwahb/custom_widgets/drop_down_list_selector/drop_down_list_selector.dart';
import 'package:zwahb/custom_widgets/safe_area/page_container.dart';
import 'package:zwahb/locale/app_localizations.dart';
import 'package:zwahb/models/category.dart';
import 'package:zwahb/models/city.dart';
import 'package:zwahb/models/country.dart';
import 'package:zwahb/networking/api_provider.dart';
import 'package:zwahb/providers/auth_provider.dart';
import 'package:zwahb/providers/home_provider.dart';
import 'package:zwahb/providers/navigation_provider.dart';
import 'package:zwahb/utils/app_colors.dart';
import 'package:zwahb/utils/commons.dart';
import 'package:zwahb/utils/urls.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:zwahb/models/marka.dart';
import 'package:zwahb/models/model.dart';
import 'package:path/path.dart' as Path;
import 'dart:math' as math;

import 'package:zwahb/providers/location_state.dart';


class AddAdScreen extends StatefulWidget {
  @override
  _AddAdScreenState createState() => _AddAdScreenState();
}

class _AddAdScreenState extends State<AddAdScreen> with ValidationMixin {
  double _height = 0, _width = 0;
  final _formKey = GlobalKey<FormState>();
  Future<List<Country>> _countryList;
  Future<List<City>> _cityList;
  Future<List<CategoryModel>> _categoryList;
  Future<List<CategoryModel>> _subList;
  Country _selectedCountry;
  City _selectedCity;
  CategoryModel _selectedCategory;
  CategoryModel _selectedSub;
  bool _initialRun = true;
  HomeProvider _homeProvider;

  LocationState _locationState;
  LocationData _locData;

  List<String> _genders ;
  File _imageFile;
  File _imageFile1;
  File _imageFile2;
  File _imageFile3;
  String _xx=null;

  bool checkedValue=false;

  Future<List<Marka>> _markaList;
  Marka _selectedMarka;

  Future<List<Model>> _modelList;
  Model _selectedModel;


  dynamic _pickImageError;
  final _picker = ImagePicker();
  AuthProvider _authProvider;
  ApiProvider _apiProvider =ApiProvider();
  bool _isLoading = false;
  String _adsTitle = '';

  String _adsColor = '';
  String _adsNumber = '';
  String _adsWasm = '';
  String _ads3fal = '';
  String _adsFkdan = '';

  String _adsPrice = '';
  String _adsPhone = '';
  String _adsWhatsapp = '';
  String _adsDescription = '';


  NavigationProvider _navigationProvider;





  List<String> _adsGps;
  String _selectedAdsGps;






   Future<void> _getCurrentUserLocation() async {
     _locData = await Location().getLocation();
    if(_locData != null){
      print('lat' + _locData.latitude.toString());
      print('longitude' + _locData.longitude.toString());
      Commons.showToast(context, message:
        AppLocalizations.of(context).translate('detect_location'));
        setState(() {

        });
    }
  }


  void _onImageButtonPressed(ImageSource source, {BuildContext context}) async {
    try {
      final pickedFile = await _picker.getImage(source: source);
      _imageFile = File(pickedFile.path);
      setState(() {});
    } catch (e) {
      _pickImageError = e;
    }
  }


  void _onImageButtonPressed1(ImageSource source, {BuildContext context}) async {
    try {
      final pickedFile = await _picker.getImage(source: source);
      _imageFile1 = File(pickedFile.path);
      setState(() {});
    } catch (e) {
      _pickImageError = e;
    }
  }


  void _onImageButtonPressed2(ImageSource source, {BuildContext context}) async {
    try {
      final pickedFile = await _picker.getImage(source: source);
      _imageFile2 = File(pickedFile.path);
      setState(() {});
    } catch (e) {
      _pickImageError = e;
    }
  }


  void _onImageButtonPressed3(ImageSource source, {BuildContext context}) async {
    try {
      final pickedFile = await _picker.getImage(source: source);
      _imageFile3 = File(pickedFile.path);
      setState(() {});
    } catch (e) {
      _pickImageError = e;
    }
  }



  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialRun) {



      _adsGps = ["نعم", "لا"];




      _homeProvider = Provider.of<HomeProvider>(context);
      _locationState = Provider.of<LocationState>(context);
      _categoryList = _homeProvider.getCategoryList(categoryModel:  CategoryModel(isSelected:false ,catId: '0',catName:
      AppLocalizations.of(context).translate('total'),catImage: 'assets/images/all.png'),enableSub: false);

      _subList = _homeProvider.getCategoryList(categoryModel:  CategoryModel(isSelected:false ,catId: '0',catName:
      AppLocalizations.of(context).translate('all'),catImage: 'assets/images/all.png'),enableSub: true,catId:'6');

      _countryList = _homeProvider.getCountryList();
      _cityList = _homeProvider.getCityList(enableCountry: true,countryId:'500');
      _markaList = _homeProvider.getMarkaList();
      _modelList = _homeProvider.getModelList();


      _initialRun = false;
    }
  }



  void _settingModalBottomSheet(context){
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc){
          return Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                    leading: new Icon(Icons.subject),
                    title: new Text('Gallery'),
                    onTap: (){
                      _onImageButtonPressed(ImageSource.gallery,
                          context: context);
                      Navigator.pop(context);
                    }
                ),
                new ListTile(
                    leading: new Icon(Icons.camera),
                    title: new Text('Camera'),
                    onTap: (){
                      _onImageButtonPressed(ImageSource.camera,
                          context: context);
                      Navigator.pop(context);
                    }
                ),
              ],
            ),
          );
        }
    );
  }


  void _settingModalBottomSheet1(context){
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc){
          return Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                    leading: new Icon(Icons.subject),
                    title: new Text('Gallery'),
                    onTap: (){
                      _onImageButtonPressed1(ImageSource.gallery,
                          context: context);
                      Navigator.pop(context);
                    }
                ),
                new ListTile(
                    leading: new Icon(Icons.camera),
                    title: new Text('Camera'),
                    onTap: (){
                      _onImageButtonPressed1(ImageSource.camera,
                          context: context);
                      Navigator.pop(context);
                    }
                ),
              ],
            ),
          );
        }
    );
  }


  void _settingModalBottomSheet2(context){
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc){
          return Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                    leading: new Icon(Icons.subject),
                    title: new Text('Gallery'),
                    onTap: (){
                      _onImageButtonPressed2(ImageSource.gallery,
                          context: context);
                      Navigator.pop(context);
                    }
                ),
                new ListTile(
                    leading: new Icon(Icons.camera),
                    title: new Text('Camera'),
                    onTap: (){
                      _onImageButtonPressed2(ImageSource.camera,
                          context: context);
                      Navigator.pop(context);
                    }
                ),
              ],
            ),
          );
        }
    );
  }


  void _settingModalBottomSheet3(context){
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc){
          return Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                    leading: new Icon(Icons.subject),
                    title: new Text('Gallery'),
                    onTap: (){
                      _onImageButtonPressed3(ImageSource.gallery,
                          context: context);
                      Navigator.pop(context);
                    }
                ),
                new ListTile(
                    leading: new Icon(Icons.camera),
                    title: new Text('Camera'),
                    onTap: (){
                      _onImageButtonPressed3(ImageSource.camera,
                          context: context);
                      Navigator.pop(context);
                    }
                ),
              ],
            ),
          );
        }
    );
  }

  Widget _buildBodyItem() {


    print("sssssssssssssssssssssssssssss");
    print("sssssssssssssssssssssssssssss");
    print("sssssssssssssssssssssssssssss");
    print("sssssssssssssssssssssssssssss");
    print(_homeProvider.latValue);
    print("sssssssssssssssssssssssssssss");
    print("sssssssssssssssssssssssssssss");
    print("sssssssssssssssssssssssssssss");
    print("sssssssssssssssssssssssssssss");


    var adsGps = _adsGps.map((item) {
      return new DropdownMenuItem<String>(
        child: new Text(item),
        value: item,
      );
    }).toList();




    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 80,
            ),



            Container(
              padding: EdgeInsets.fromLTRB(25,5,25,10),
              child: Text(_homeProvider.currentLang=='ar'?"صور الاعلان":"Ad photos"),
            ),

            Row(
              children: <Widget>[
                Padding(padding:EdgeInsets.fromLTRB(25,5,5,10)),

                Stack(
                  children: <Widget>[
                    GestureDetector(
                        onTap: (){
                          _settingModalBottomSheet(context);
                        },
                        child: Container(
                          height: _height * 0.1,
                          width: _width*.20,

                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(15.0)),
                            border: Border.all(
                              color: hintColor.withOpacity(0.4),
                            ),
                            color: Colors.grey[100],
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.4),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                          child: _imageFile != null
                              ?ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child:  Image.file(
                                _imageFile,
                                // fit: BoxFit.fill,
                              ))
                              : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Image.asset('assets/images/newadd.png'),

                            ],
                          ),
                        )),

                        Positioned(child: GestureDetector(
                          child: Icon(Icons.delete_forever),
                          onTap: (){
                           setState(() {
                             _imageFile=null;
                           });
                          },
                        ))
                  ],
                ),

                Padding(padding: EdgeInsets.all(5)),

               Stack(
                 children: <Widget>[
                   GestureDetector(
                       onTap: (){
                         _settingModalBottomSheet1(context);
                       },
                       child: Container(
                         height: _height * 0.1,
                         width: _width*.20,

                         decoration: BoxDecoration(
                           borderRadius: BorderRadius.all(Radius.circular(15.0)),
                           border: Border.all(
                             color: hintColor.withOpacity(0.4),
                           ),
                           color: Colors.grey[100],
                           boxShadow: [
                             BoxShadow(
                               color: Colors.grey.withOpacity(0.4),
                               blurRadius: 6,
                             ),
                           ],
                         ),
                         child: _imageFile1 != null
                             ?ClipRRect(
                             borderRadius: BorderRadius.circular(8.0),
                             child:  Image.file(
                               _imageFile1,
                               // fit: BoxFit.fill,
                             ))
                             : Column(
                           mainAxisAlignment: MainAxisAlignment.center,
                           children: <Widget>[
                             Image.asset('assets/images/newadd.png'),

                           ],
                         ),
                       )),

                      Positioned(
                        top: 0,
                          child: GestureDetector(
                        child: Icon(Icons.delete_forever),
                        onTap: (){
                          setState(() {

                            _imageFile1=null;

                          });
                        },
                      ))
                 ],
               ),

                Padding(padding: EdgeInsets.all(5)),

               Stack(
                 children: <Widget>[
                   GestureDetector(
                       onTap: (){
                         _settingModalBottomSheet2(context);
                       },
                       child: Container(
                         height: _height * 0.1,
                         width: _width*.20,

                         decoration: BoxDecoration(
                           borderRadius: BorderRadius.all(Radius.circular(15.0)),
                           border: Border.all(
                             color: hintColor.withOpacity(0.4),
                           ),
                           color: Colors.grey[100],
                           boxShadow: [
                             BoxShadow(
                               color: Colors.grey.withOpacity(0.4),
                               blurRadius: 6,
                             ),
                           ],
                         ),
                         child: _imageFile2 != null
                             ?ClipRRect(
                             borderRadius: BorderRadius.circular(8.0),
                             child:  Image.file(
                               _imageFile2,
                               // fit: BoxFit.fill,
                             ))
                             : Column(
                           mainAxisAlignment: MainAxisAlignment.center,
                           children: <Widget>[
                             Image.asset('assets/images/newadd.png'),

                           ],
                         ),
                       )),

                   Positioned(child: GestureDetector(
                     child: Icon(Icons.delete_forever),
                     onTap: (){
                        setState(() {
                          _imageFile2=null;
                        });
                     },
                   ))
                 ],
               ),

                Padding(padding: EdgeInsets.all(5)),

                Stack(
                  children: <Widget>[
                    GestureDetector(
                        onTap: (){
                          _settingModalBottomSheet3(context);
                        },
                        child: Container(
                          height: _height * 0.1,
                          width: _width*.20,

                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(15.0)),
                            border: Border.all(
                              color: hintColor.withOpacity(0.4),
                            ),
                            color: Colors.grey[100],
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.4),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                          child: _imageFile3 != null
                              ?ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child:  Image.file(
                                _imageFile3,
                                // fit: BoxFit.fill,
                              ))
                              : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Image.asset('assets/images/newadd.png'),


                            ],
                          ),
                        )),
                    Positioned(child: GestureDetector(
                      child: Icon(Icons.delete_forever),
                      onTap: (){
                       setState(() {
                         _imageFile3=null;
                       });
                      },
                    ))
                  ],
                ),

              ],

            ),


            Container(
              margin: EdgeInsets.symmetric(vertical: _height * 0.02),

              child: CustomTextFormField(
                hintTxt: AppLocalizations.of(context).translate('ad_title'),

                onChangedFunc: (text) {
                  _adsTitle = text;
                },
                validationFunc: validateAdTitle,
              ),
            ),
            FutureBuilder<List<CategoryModel>>(
              future: _categoryList,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.hasData) {
                    var categoryList = snapshot.data.map((item) {

                      return new DropdownMenuItem<CategoryModel>(

                        child: new Text(item.catName),
                        value: item,
                      );
                    }).toList();
                    categoryList.removeAt(0);
                    return DropDownListSelector(
                      dropDownList: categoryList,
                      marg: .07,
                      hint: _homeProvider.currentLang=='ar'?'القسم ':' category',
                      onChangeFunc: (newValue) {
                         FocusScope.of(context).requestFocus( FocusNode());
                        setState(() {


                          _selectedCategory = newValue;
                          _selectedSub=null;
                          _homeProvider.setSelectedCat(newValue);
                          _subList = _homeProvider.getCategoryList(categoryModel:  CategoryModel(isSelected:false ,catId: '0',catName:
                          AppLocalizations.of(context).translate('all'),catImage: 'assets/images/all.png'),enableSub: true,catId:_homeProvider.selectedCat.catId);


                          _xx=_homeProvider.selectedCat.catId;
                        });
                      },
                      value: _selectedCategory,
                    );
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }

                return Center(child: CircularProgressIndicator());
              },
            ),



            Container(
              margin: EdgeInsets.only(top: _height * 0.01,bottom: _height * 0.01),
            ),

            Container(
              margin: EdgeInsets.only(right: _height * 0.03,left: _height * 0.03),
              child: Row(
                children: <Widget>[

                  Container(
                    width: _width*.44,
                    child: FutureBuilder<List<Country>>(
                      future: _countryList,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.hasData) {
                            var countryList = snapshot.data.map((item) {
                              return new DropdownMenuItem<Country>(
                                child: new Text(item.countryName),
                                value: item,
                              );
                            }).toList();
                            return DropDownListSelector(
                              dropDownList: countryList,
                              marg: .01,
                              hint:  AppLocalizations.of(context).translate('choose_country'),
                              onChangeFunc: (newValue) {
                                FocusScope.of(context).requestFocus( FocusNode());
                                setState(() {
                                  _selectedCountry = newValue;
                                  _selectedCity=null;
                                  _homeProvider.setSelectedCountry(newValue);
                                  _cityList = _homeProvider.getCityList(enableCountry: true,countryId:_homeProvider.selectedCountry.countryId);
                                });
                              },

                              value: _selectedCountry,
                            );
                          } else if (snapshot.hasError) {
                            return Text("${snapshot.error}");
                          }
                        } else if (snapshot.hasError) {
                          return Text("${snapshot.error}");
                        }

                        return Center(child: CircularProgressIndicator());
                      },
                    ),
                  ),


                  Container(
                    width: _width*.44,
                    child:  FutureBuilder<List<City>>(
                      future: _cityList,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.hasData) {
                            var cityList = snapshot.data.map((item) {
                              return new DropdownMenuItem<City>(
                                child: new Text(item.cityName),
                                value: item,
                              );
                            }).toList();
                            return DropDownListSelector(
                              dropDownList: cityList,
                              marg: .01,
                              hint:  AppLocalizations.of(context).translate('choose_city'),
                              onChangeFunc: (newValue) {
                                FocusScope.of(context).requestFocus( FocusNode());
                                setState(() {
                                  _selectedCity = newValue;
                                });
                              },
                              value: _selectedCity,
                            );
                          } else if (snapshot.hasError) {
                            return Text("${snapshot.error}");
                          }
                        } else    if (snapshot.hasError) {
                          DioError error = snapshot.error;
                          String message = error.message;
                          if (error.type == DioErrorType.CONNECT_TIMEOUT)
                            message = 'Connection Timeout';
                          else if (error.type ==
                              DioErrorType.RECEIVE_TIMEOUT)
                            message = 'Receive Timeout';
                          else if (error.type == DioErrorType.RESPONSE)
                            message =
                            '404 server not found ${error.response.statusCode}';
                          print(message);
                          return Container(
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }

                        return Center(child: CircularProgressIndicator());
                      },
                    ),
                  ),

                ],
              ),
            ),






            Container(
              margin: EdgeInsets.only(top: _height * 0.02,bottom: _height * 0.01),
            ),
            Container(

              child: CustomTextFormField(
                hintTxt: _homeProvider.currentLang=="ar"?"رقم الجوال":"Phone",
                onChangedFunc: (text) {
                  _adsPhone = text;
                },
                validationFunc: validateUserPhone,
              ),
            ),



            Container(
              margin: EdgeInsets.only(bottom: _height * 0.02),
            ),
            Container(

              child: CustomTextFormField(
                hintTxt:  _homeProvider.currentLang=="ar"?"للتواصل واتساب ( مثال : 966501234567 )":"whatsapp ( Ex: 966501234567 )",
                onChangedFunc: (text) {
                  _adsWhatsapp = text;
                },
                validationFunc: validateUserWhats,
              ),
            ),













            Container(
              margin: EdgeInsets.only(bottom: _height * 0.01),
            ),

            Container(
              margin: EdgeInsets.symmetric(vertical: _height * 0.01),
              child: CustomTextFormField(
                maxLines: 3,
                hintTxt:  AppLocalizations.of(context).translate('ad_description'),
                validationFunc: validateAdDescription,
                onChangedFunc: (text) {
                  _adsDescription = text;
                },
              ),
            ),


            Container(
              margin: EdgeInsets.only(bottom: _height * 0.01),
            ),

            Container(
              margin: EdgeInsets.symmetric(horizontal: _height * 0.02),
              child: Row(
                children: <Widget>[
              Container(
              width: _width*.46,

                child: CustomTextFormField(
                  hintTxt: "اللون",

                  onChangedFunc: (text) {
                    _adsColor = text;
                  },
                  validationFunc: validateAdTitle,
                ),
              ),


                  Container(
                    width: _width*.46,

                    child: CustomTextFormField(
                      hintTxt: "العدد",

                      onChangedFunc: (text) {
                        _adsNumber = text;
                      },
                      validationFunc: validateAdTitle,
                    ),
                  ),


                ],
              ),
            ),

            Container(
              margin: EdgeInsets.only(bottom: _height * 0.02),
            ),


            Container(
              margin: EdgeInsets.symmetric(horizontal: _height * 0.02),
              child: Row(
                children: <Widget>[
                  Container(
                    width: _width*.46,

                    child: CustomTextFormField(
                      hintTxt: "الوسم / الشاهد",

                      onChangedFunc: (text) {
                        _adsWasm = text;
                      },
                      validationFunc: validateAdTitle,
                    ),
                  ),



                  Container(
                    width: _width*.46,

                    child: CustomTextFormField(
                      hintTxt: "غفال",

                      onChangedFunc: (text) {
                        _ads3fal = text;
                      },
                      validationFunc: validateAdTitle,
                    ),
                  ),


                ],
              ),
            ),


            Container(
              margin: EdgeInsets.only(bottom: _height * 0.02),
            ),

            Container(
              margin: EdgeInsets.symmetric(horizontal: _height * 0.03),
              child: Row(
                children: <Widget>[
                  Container(
                    width: _width*.42,
                    child: DropDownListSelector(
                      marg: .01,
                      dropDownList: adsGps,
                      hint:  _homeProvider.currentLang=="ar"?"يوجد شريحة":"There is a slidem",
                      onChangeFunc: (newValue) {
                        FocusScope.of(context).requestFocus( FocusNode());
                        setState(() {
                          _selectedAdsGps = newValue;
                        });
                      },
                      value: _selectedAdsGps,
                    ),
                  ),


                   Padding(padding: EdgeInsets.all(3)),

                  Container(
                    width: _width*.45,

                    child: CustomTextFormField(
                      hintTxt: "تاريخ الفقدان",

                      onChangedFunc: (text) {
                        _adsFkdan = text;
                      },
                      validationFunc: validateAdTitle,
                    ),
                  ),


                ],
              ),
            ),




            Container(
              alignment: Alignment.centerRight,

              child: CheckboxListTile(

                checkColor: Colors.white,
                activeColor: mainAppColor,
                title: Text(_homeProvider.currentLang=="ar"?"هل تريد اضافه اللوكيشن ؟":"Do you want to add the Location?",style: TextStyle(fontSize: 15),),
                value: checkedValue,
                onChanged: (newValue) {
                  setState(() {
                    checkedValue = newValue;
                    _homeProvider.setCheckedValue(newValue.toString());
                    print(_homeProvider.checkedValue);
                  });
                },

              ),
            ),




            _homeProvider.checkedValue=="true"?   GestureDetector(
              onTap: (){

                showDialog(
                    barrierDismissible: true,
                    context: context,
                    builder: (_) {
                      return LocationDialog(

                      );
                    });
              },
              child: Container(
                alignment: Alignment.center,

                width: _width * 0.60,
                margin: EdgeInsets.only(right: _width * 0.20),
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: mainAppColor,
                    borderRadius: BorderRadius.all(
                      Radius.circular(20.00),
                    ),
                    border: Border.all(color: mainAppColor)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 5,right: 5),
                      child: Icon(Icons.location_on,color: Colors.white,),
                    ),
                    Text(
                      _homeProvider.currentLang=="ar"?"اختار اللوكيشن":"select location",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 14),
                    )
                  ],
                ),
              ),
            ):Text(' ',style: TextStyle(height: 0),),


            CustomButton(
              btnLbl: AppLocalizations.of(context).translate('publish_ad'),
              onPressedFunction: () async {
                if (_formKey.currentState.validate() &
                    checkAddAdValidation(context,
                    imgFile: _imageFile,
                        adMainCategory: _selectedCategory,
                        adCity: _selectedCity)) {

                               FocusScope.of(context).requestFocus( FocusNode());
                             setState(() => _isLoading = true);
                               String fileName = (_imageFile!=null)?Path.basename(_imageFile.path):"";
                               String fileName1 = (_imageFile1!=null)?Path.basename(_imageFile1.path):"";
                               String fileName2 = (_imageFile2!=null)?Path.basename(_imageFile2.path):"";
                               String fileName3 = (_imageFile3!=null)?Path.basename(_imageFile3.path):"";
                  FormData formData = new FormData.fromMap({
                    "user_id": _authProvider.currentUser.userId,
                    "ads_title": _adsTitle,

                    "ads_color": _adsColor,
                    "ads_number": _adsNumber,
                    "ads_wasm": _adsWasm,
                    "ads_3fal": _ads3fal,
                    "ads_fkdan": _adsFkdan,

                    "ads_details": _adsDescription,
                    "ads_cat": _selectedCategory.catId,

                    "ads_country": _selectedCountry!=null?_selectedCountry.countryId:"0",
                    "ads_city": _selectedCity.cityId,
                    "ads_price": _adsPrice,
                    "ads_phone": _adsPhone,
                    "ads_whatsapp": _adsWhatsapp,
                    "ads_gps": _selectedAdsGps=="نعم"?"1":"0",

                    "ads_location":(_locationState.locationLatitude.toString()!=null?_locationState.locationLatitude.toString():_homeProvider.latValue)+","+(_locationState.locationlongitude.toString()!=null?_locationState.locationlongitude.toString():_homeProvider.longValue),
                    "imgURL[0]": (_imageFile!=null)?await MultipartFile.fromFile(_imageFile.path, filename: fileName):"",
                    "imgURL[1]": (_imageFile1!=null)?await MultipartFile.fromFile(_imageFile1.path, filename: fileName1):"",
                    "imgURL[2]": (_imageFile2!=null)?await MultipartFile.fromFile(_imageFile2.path, filename: fileName2):"",
                    "imgURL[3]": (_imageFile3!=null)?await MultipartFile.fromFile(_imageFile3.path, filename: fileName3):""
                  });
                  final results = await _apiProvider
                      .postWithDio(Urls.ADD_AD_URL + "?api_lang=${_authProvider.currentLang}", body: formData);
                  setState(() => _isLoading = false);


                  if (results['response'] == "1") {

                    showDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (_) {
                          return ConfirmationDialog(
                            title: AppLocalizations.of(context).translate('ad_has_published_successfully'),
                            message:
                                AppLocalizations.of(context).translate('ad_published_and_manage_my_ads'),
                          );
                        });
                    Future.delayed(const Duration(seconds: 2), () {
                      Navigator.pop(context);
                       Navigator.pop(context);
                      Navigator.pushReplacementNamed(context, '/my_ads_screen');
                      _navigationProvider.upadateNavigationIndex(4);
                    });
                  } else {
                    Commons.showError(context, results["message"]);
                  }



                }
              },
            ),
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
    _authProvider = Provider.of<AuthProvider>(context);
    _navigationProvider = Provider.of<NavigationProvider>(context);

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
                  Text(AppLocalizations.of(context).translate('add_ad'),
                      style: TextStyle(color: mainAppColor,fontSize: 17,fontWeight: FontWeight.bold)),
                  Spacer(
                    flex: 3,
                  ),
                ],
              )),
          _isLoading
              ? Center(
                  child: SpinKitFadingCircle(color: mainAppColor),
                )
              : Container()
        ],
      )),
    );
  }
}
