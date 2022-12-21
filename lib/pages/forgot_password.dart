import 'package:flutter/material.dart';
import 'package:smart_aquarium/components/widgets/background_appbar.dart';
import 'package:smart_aquarium/components/widgets/background_route.dart';
import 'package:smart_aquarium/components/widgets/button_submit.dart';
import 'package:smart_aquarium/components/widgets/clipper_parabola.dart';
import 'package:smart_aquarium/components/widgets/textfield_suffix.dart';
import 'package:smart_aquarium/constants/text_constant.dart';
import 'package:smart_aquarium/services/firebase_service.dart';

class ForgotPasswordScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  ForgotPasswordScreen({Key? key}) : super(key: key);

  void validator(context) {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      FirebaseService.resetPassword(_emailController.text.trim(), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: AppbarBackgroundWidget(),
        title: Text(
          'Lupa Password',
        ),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              ClipPath(
                clipper: ClipParabolaWidget(),
                child: RouteBackgroundWidget(
                  image: 'assets/images/forgot_password.png',
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
                          children: <Widget>[
                            Text(
                              'Masukan alamat email yang terkait dengan akun Anda.',
                              style: bigText,
                            ),
                            Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  SizedBox(height: size.height * 0.03),
                                  TextFieldWidget(
                                    enabled: true,
                                    keyboardType: TextInputType.emailAddress,
                                    controller: _emailController,
                                    labelText: 'Masukan Alamat Email',
                                    hintText: 'Email',
                                    icon: Icons.mail,
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
                                  SizedBox(height: size.height * 0.05),
                                  Container(
                                    width: 2000,
                                    child: SubmitButton(
                                      press: () {
                                        validator(context);
                                      },
                                      text: 'Reset Password',
                                    ),
                                  ),
                                ],
                              ),
                            ),
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
