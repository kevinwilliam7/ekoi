import 'package:flutter/material.dart';
import 'package:smart_aquarium/components/utils/loading_popup.dart';
import 'package:smart_aquarium/components/widgets/background_appbar.dart';
import 'package:smart_aquarium/components/widgets/background_route.dart';
import 'package:smart_aquarium/components/widgets/button_submit.dart';
import 'package:smart_aquarium/components/widgets/clipper_parabola.dart';
import 'package:smart_aquarium/components/widgets/textfield_password.dart';
import 'package:smart_aquarium/components/widgets/textfield_suffix.dart';
import 'package:smart_aquarium/constants/text_constant.dart';
import 'package:smart_aquarium/pages/forgot_password.dart';
import 'package:smart_aquarium/services/firebase_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formLoginKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscureText = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void validator(context) {
    if (_formLoginKey.currentState != null &&
        _formLoginKey.currentState!.validate()) {
      FirebaseService.emailSignIn(
          _emailController.text, _passwordController.text, context);
    } else {
      print("not validated");
    }
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        flexibleSpace: AppbarBackgroundWidget(),
        title: Center(child: Text('E-KOI', style: loginText)),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              ClipPath(
                clipper: ClipParabolaWidget(),
                child: RouteBackgroundWidget(
                  image: 'assets/images/login.png',
                  height: size.height * 0.3,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                child: Column(
                  children: [
                    Container(
                      height: size.height * 0.2,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        borderRadius: new BorderRadius.only(
                          topLeft: const Radius.circular(15.0),
                          topRight: const Radius.circular(15.0),
                          bottomLeft: const Radius.circular(15.0),
                          bottomRight: const Radius.circular(15.0),
                        ),
                        gradient: LinearGradient(
                          colors: [
                            Color.fromARGB(255, 255, 255, 255),
                            Color.fromARGB(255, 255, 255, 255),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 10,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                          right: 35,
                          left: 35,
                          top: 35,
                          bottom: 35,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Halo Pengguna,',
                              style: bigText,
                            ),
                            Text(
                              'Selamat Datang...',
                              style: bigText,
                            ),
                            Form(
                              key: _formLoginKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(height: size.height * 0.035),
                                  TextFieldWidget(
                                    enabled: true,
                                    keyboardType: TextInputType.emailAddress,
                                    controller: _emailController,
                                    labelText: 'Email',
                                    hintText: 'Masukan Alamat Email',
                                    icon: Icons.mail_outline,
                                    validator: (String? email) {
                                      if (email == null ||
                                          email.trim().length == 0) {
                                        return "Email tidak boleh kosong";
                                      } else if (!RegExp(
                                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                          .hasMatch(email)) {
                                        return "Email tidak valid";
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(height: size.height * 0.035),
                                  PasswordFieldWidget(
                                    controller: _passwordController,
                                    obscureText: _obscureText,
                                    suffixPress: _toggle,
                                    labelText: 'Kata Sandi',
                                    hintText: 'Masukan Kata Sandi',
                                    validator: (String? password) {
                                      if (password == null ||
                                          password.trim().length == 0) {
                                        return "Password tidak boleh kosong";
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(height: size.height * 0.01),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Material(
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ForgotPasswordScreen(),
                                              ),
                                            );
                                          },
                                          child: Text(
                                            'Lupa Kata Sandi?',
                                            style: forgotPasswordText,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: size.height * 0.03),
                                  Container(
                                    width: 2000,
                                    child: SubmitButton(
                                      press: () {
                                        LoadingPopup.loadingPopUp(
                                          context,
                                          'Masuk...',
                                        );
                                        new Future.delayed(
                                            new Duration(seconds: 3), () {
                                          validator(context);
                                          Navigator.pop(context); //pop dialog
                                        });
                                      },
                                      text: 'Masuk',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: size.height * 0.03),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
