import 'dart:async';
import 'dart:math';
import 'dart:convert' show json;
import 'package:carousel_slider/carousel_slider.dart';
import "package:http/http.dart" as http;
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meet_me/src/pages/google_sign_in.dart';
import './index.dart';
import 'package:shared_preferences/shared_preferences.dart';

GoogleSignIn _googleSignIn = GoogleSignInBaseConfig.GoogleSignInVar;

class SignIn extends StatefulWidget {
  @override
  State createState() => SignInState();
}

class SignInState extends State<SignIn> {
  static final List<String> imgSlider = [
    'slider0.png',
    'slider1.png',
    'slider2.png',
  ];

  final CarouselSlider autoPlayImage = CarouselSlider(
    items: imgSlider.map((fileImage) {
      return Container(
        margin: EdgeInsets.all(5.0),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          child: Image.asset(
            'assets/images/${fileImage}',
            width: 10000,
            fit: BoxFit.cover,
          ),
        ),
      );
    }).toList(),
    height: 150,
    autoPlay: true,
    enlargeCenterPage: true,
    aspectRatio: 2.0,
  );

  GoogleSignInAccount _currentUser;
  final random = new Random();
  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      setState(() {
        _currentUser = account;
      });

      saveData(_currentUser.id,_currentUser.email, _currentUser.displayName, _currentUser.photoUrl);
    });
    _googleSignIn.signInSilently();
  }
  Future<void> saveData(id_g,em_g,dn_g,pu_g) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("id_google", id_g);
    prefs.setString("email_google", em_g);
    prefs.setString("displayname_google", dn_g);
    prefs.setString("photourl_google", pu_g);
  }

  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }

  Future<void> _handleSignOut() => _googleSignIn.disconnect();

  Widget _buildBody() {
    if (_currentUser != null) {
      return Column(
        children: <Widget>[
          Container(
              constraints: BoxConstraints(minWidth: double.infinity, minHeight: 190),
              decoration: new BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/congratulations.png"),
                  fit: BoxFit.cover,
                ),
              ),
              child: null
          ),
          Padding(
              padding: EdgeInsets.only(top:20,bottom: 10,left: 10,right: 10),
              child: Center(
                child: Text(
                  "Selamat Datang",
                  style: TextStyle(fontSize: 25, color: Color.fromRGBO(23, 134, 190, 1)),
                  textAlign: TextAlign.center,
                ),
              )
          ),
          Center(
            child: new ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.only(bottom:10.0),
                children: [
                  Center(
                    child: ListTile(
                      leading: GoogleUserCircleAvatar(
                        identity: _currentUser,
                      ),
                      title: Text(_currentUser.displayName ?? ''),
                      subtitle: Text(_currentUser.email ?? ''),
                    ),
                  ),
                ]
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top:5,bottom: 30,left: 30,right: 30),
            child: Text(
              "Untuk melanjutkan ke tampilan utama silahkan klik lanjutkan untuk batal klik kembali",
              style: TextStyle(fontSize: 16, color: Color.fromRGBO(23, 134, 190, 1)),
            ),
          ),
          Row(
            children: [
              Padding(
                  padding: EdgeInsets.only(top:5,bottom: 30,left: 30,right: 30),
                  child: RaisedButton.icon(
                      color: Colors.lightBlue,
                      onPressed: ()=>{
                        Navigator.push(context,MaterialPageRoute(builder: (context) => IndexPage()))
                      }, icon: Icon(
                    Icons.add_to_home_screen,
                    color: Colors.white,
                    size: 30.0,
                  ), label: Text("Lanjutkan", style: TextStyle(fontSize: 16, color: Colors.white)))
              ),
              Padding(
                  padding: EdgeInsets.only(top:5,bottom: 30),
                  child: RaisedButton.icon(
                      color: Colors.red,
                      onPressed: _handleSignOut, icon: Icon(
                    Icons.add_to_home_screen,
                    color: Colors.white,
                    size: 30.0,
                  ), label: Text("Batalkan", style: TextStyle(fontSize: 16, color: Colors.white)))
              ),
            ],
          )
        ],
      );
    } else {
      return Column(
        children: <Widget>[
          Container(
            constraints: BoxConstraints(minWidth: double.infinity, minHeight: 190),
            decoration: new BoxDecoration(
              color: Colors.blue,
              image: DecorationImage(
                image: AssetImage("assets/images/background${random.nextInt(2)}.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: new Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                new Container(
                                    width: 100,// Not sure what to put here!
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.all(10.0),
                                          child: new Image.asset(
                                            'assets/images/MeetMe.png',
                                            fit: BoxFit.fill, // I thought this would fill up my Container but it doesn't
                                          ),
                                        )
                                      ],
                                    )
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top:5),
                                  child: Text(
                                    "Meet Me - Video Conference App",
                                    style: TextStyle(fontSize: 16, color: Color.fromRGBO(255, 255, 255, 1)),
                                  ),
                                ),
                                Padding(
                                    padding: EdgeInsets.only(top:5,bottom:5),
                                    child: Container(
                                        width: 250,
                                        child: Center(
                                          child: Text(
                                            "Sudah punya google akun ?\nKlik tombol dibawah untuk masuk akun .",
                                            style: TextStyle(fontSize: 12, color: Color.fromRGBO(255, 255, 255, 1)),
                                            textAlign: TextAlign.center,
                                          ),
                                        )
                                    )
                                )
                              ],
                            )
                        ),
                      ),
                    ],
                  ),
                ]
            ),
          ),


          Expanded(
              flex: 1,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Container(
                        child: Column(
                          children: [
                            autoPlayImage,
                            Padding(
                              padding: EdgeInsets.only(top: 15.0, bottom: 10.0),
                              child: Text(
                                "Masuk Akun",
                                style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold, color: Color.fromRGBO(23, 134, 190, 1)),
                              ),
                            ),
                            Padding(
                                padding: EdgeInsets.only(top: 15.0, bottom: 10.0),
                                child: Container(
                                  width:200,
                                  child: GestureDetector(
                                    onTap: _handleSignIn,
                                    child: Image.asset('assets/images/login_google_long.png'),
                                  ),
                                )
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
          ),

        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Masuk Akun ke Meet Me'),
        ),
        body: SafeArea(
          child: _buildBody(),
        ));
  }
}