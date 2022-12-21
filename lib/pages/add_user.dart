import 'package:flutter/material.dart';
import 'package:smart_aquarium/components/utils/loading_popup.dart';
import 'package:smart_aquarium/components/widgets/background_appbar.dart';
import 'package:smart_aquarium/components/widgets/background_body.dart';
import 'package:smart_aquarium/components/widgets/clipper_parabola.dart';
import 'package:smart_aquarium/components/widgets/textfield_password.dart';
import 'package:smart_aquarium/components/widgets/textfield_suffix.dart';
import 'package:smart_aquarium/constants/text_constant.dart';
import 'package:smart_aquarium/services/firebase_service.dart';

class AddUserScreen extends StatefulWidget {
  const AddUserScreen({Key? key}) : super(key: key);

  @override
  State<AddUserScreen> createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _obscureText = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void validator() {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      FirebaseService.addUser(_emailController.text, _passwordController.text,
          _phoneController.text, _nameController.text, context);
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
        elevation: 0,
        flexibleSpace: AppbarBackgroundWidget(),
        title: Text(
          'Tambah Pengguna',
          style: appBarHai,
        ),
      ),
      body: SingleChildScrollView(
        child: Stack(children: [
          ClipPath(
            clipper: ClipParabolaWidget(),
            child: BodyBackgroundWidget(
              height: size.height * 0.3,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 20),
            child: Column(
              children: [
                Container(
                    // height: MediaQuery.of(context).size.height * 0.15,

                    ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 25),
                  width: size.width * 0.9,
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
                  child: Container(
                    child: Column(
                      children: [
                        SizedBox(height: size.height * 0.01),
                        Form(
                          key: _formKey,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              right: 25,
                              left: 25,
                              top: 10,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                SizedBox(
                                  height: size.height * 0.03,
                                ),
                                TextFieldWidget(
                                  enabled: true,
                                  labelText: 'Nama',
                                  hintText: 'Masukan nama pengguna',
                                  icon: Icons.person,
                                  controller: _nameController,
                                  keyboardType: TextInputType.name,
                                  validator: (String? name) {
                                    if (name == null ||
                                        name.trim().length == 0) {
                                      return "Nama tidak boleh kosong";
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: size.height * 0.03),
                                TextFieldWidget(
                                  enabled: true,
                                  labelText: 'Email',
                                  hintText: 'Masukan email pengguna',
                                  icon: Icons.email,
                                  controller: _emailController,
                                  keyboardType: TextInputType.emailAddress,
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
                                SizedBox(height: size.height * 0.03),
                                PasswordFieldWidget(
                                  obscureText: _obscureText,
                                  suffixPress: _toggle,
                                  labelText: 'Password',
                                  hintText: 'Masukan password pengguna',
                                  controller: _passwordController,
                                  validator: (String? password) {
                                    if (password == null ||
                                        password.trim().length == 0) {
                                      return "Password baru tidak boleh kosong";
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: size.height * 0.03),
                                TextFieldWidget(
                                  enabled: true,
                                  labelText: 'No HP',
                                  hintText: 'Masukan np hp pengguna',
                                  icon: Icons.tag,
                                  controller: _phoneController,
                                  keyboardType: TextInputType.text,
                                  validator: (String? phone) {
                                    if (phone == null ||
                                        phone.trim().length == 0) {
                                      return "Password baru tidak boleh kosong";
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: size.height * 0.03),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.green,
                                  ),
                                  onPressed: () {
                                    LoadingPopup.loadingPopUp(
                                      context,
                                      'Tambah Pengguna...',
                                    );
                                    new Future.delayed(new Duration(seconds: 3),
                                        () {
                                      validator();
                                      Navigator.pop(context); //pop dialog
                                    });
                                  },
                                  child: Text('Save'),
                                ),
                                SizedBox(
                                  height: size.height * 0.03,
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ]),
      ),
    );
  }
}
