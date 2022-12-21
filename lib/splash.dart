import 'package:flutter/material.dart';
import 'package:smart_aquarium/constants/color_constant.dart';
import 'package:smart_aquarium/constants/text_constant.dart';
import 'package:smart_aquarium/pages/login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void iniState() {
    super.initState();
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const LoginScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                kWhiteColor,
                kWhiteColor,
              ],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Image.asset(
                  'assets/images/koi_logo.png',
                  height: size.height * 0.13,
                ),
              ),
              SizedBox(
                height: size.height * 0.03,
              ),
              const Text(
                'SMART AQUARIUM',
                style: textSplash,
              ),
              SizedBox(
                height: size.height * 0.04,
              ),
              const CircularProgressIndicator(color: kBlueColor2),
            ],
          ),
        ),
      ),
    );
  }
}
