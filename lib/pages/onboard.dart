// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:smart_aquarium/pages/login.dart';

class OnboardScreen extends StatefulWidget {
  const OnboardScreen({Key? key}) : super(key: key);

  @override
  State<OnboardScreen> createState() => _OnboardScreenState();
}

class _OnboardScreenState extends State<OnboardScreen> {
  final int _numPages = 2;
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < _numPages; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(microseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 8),
      height: 8,
      width: isActive ? 24.0 : 16.0,
      decoration: BoxDecoration(
        color: isActive ? Colors.grey : Color(0xFF123456),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/images/koi_logo.png',
              scale: 7,
            ),
            SizedBox(
              width: 7,
            ),
            Text(
              'E-KOI',
              style: TextStyle(
                color: Color(0xFF123456),
              ),
            ),
          ],
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [
          _currentPage == _numPages - 1
              ? Text('')
              : TextButton(
                  //FlatButton
                  onPressed: () {
                    // Navigator.pushAndRemoveUntil(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => LoginScreen()),
                    //   (Route<dynamic> route) => false,
                    // );
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(),
                      ),
                    );
                  },
                  child: Text(
                    'Skip',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF5B16D0),
                    ),
                  ),
                )
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white,
              Colors.white,
            ],
          ),
        ),
        child: PageView(
          physics: ClampingScrollPhysics(),
          controller: _pageController,
          onPageChanged: (int page) {
            setState(() {
              _currentPage = page;
            });
          },
          children: [
            Container(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(50),
                      child: Image.asset(
                        'assets/images/onboarding1.png',
                      ),
                    ),
                    Container(
                      child: Text(
                        'Pengenalan Sistem',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: Color(0xFF123456),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(25),
                      child: Text(
                        "E-KOI merupakan sistem pemantauan dan kendali budidaya ikan koi berbasis internet of things guna mengetahui keadaan tempat budidaya secara realtime.",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          color: Color(0xFF123456),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: _buildPageIndicator(),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(50),
                      child: Image.asset(
                        'assets/images/onboarding2.png',
                      ),
                    ),
                    Container(
                      child: Text(
                        'Fitur Sistem',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: Color(0xFF123456),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(25),
                      child: Text(
                        "Sistem ini menyediakan data realtime sensor, data grafik dan pengaturan konfigurasi terhadap kontrol pada budidaya ikan koi berbasis internet of things",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          color: Color(0xFF123456),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: _buildPageIndicator(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomSheet: _currentPage == _numPages - 1
          ? Container(
              height: 100.0,
              width: double.infinity,
              color: Colors.white,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(),
                    ),
                  );
                },
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 30.0),
                    child: Text(
                      'Masuk',
                      style: TextStyle(
                        color: Color(0xFF5B16D0),
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            )
          : Container(
              height: 100.0,
              width: double.infinity,
              color: Colors.white,
              child: GestureDetector(
                onTap: () {
                  _pageController.nextPage(
                    duration: Duration(milliseconds: 500),
                    curve: Curves.ease,
                  );
                },
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 30.0),
                    child: Text(
                      'Lanjut',
                      style: TextStyle(
                        color: Color(0xFF5B16D0),
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
