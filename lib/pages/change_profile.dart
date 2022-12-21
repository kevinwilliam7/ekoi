import 'package:flutter/material.dart';
import 'package:smart_aquarium/components/utils/loading_popup.dart';
import 'package:smart_aquarium/components/widgets/background_appbar.dart';
import 'package:smart_aquarium/components/widgets/background_body.dart';
import 'package:smart_aquarium/components/widgets/clipper_parabola.dart';
import 'package:smart_aquarium/components/widgets/textfield_password.dart';
import 'package:smart_aquarium/components/widgets/textfield_suffix.dart';
import 'package:smart_aquarium/constants/text_constant.dart';
import 'package:smart_aquarium/services/firebase_service.dart';

class ChangeProfileScreen extends StatefulWidget {
  ChangeProfileScreen(
      {Key? key, required this.email, required this.name, this.phone})
      : super(key: key);

  final email;
  final name;
  final phone;

  @override
  State<ChangeProfileScreen> createState() => _ChangeProfileScreenState();
}

class _ChangeProfileScreenState extends State<ChangeProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final _oldPassController = TextEditingController();
  final _newPassController = TextEditingController();
  final _confirmPassController = TextEditingController();
  bool _obscureTextOld = true;
  bool _obscureTextNew = true;
  bool _obscureTextConfirm = true;

  @override
  void initState() {
    _nameController = new TextEditingController(text: widget.name);
    _phoneController = new TextEditingController(text: widget.phone);
    _emailController = new TextEditingController(text: widget.email);
    super.initState();
  }

  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _toggleOld() {
    setState(() {
      _obscureTextOld = !_obscureTextOld;
    });
  }

  void _toggleNew() {
    setState(() {
      _obscureTextNew = !_obscureTextNew;
    });
  }

  void _toggleConfirm() {
    setState(() {
      _obscureTextConfirm = !_obscureTextConfirm;
    });
  }

  void validatorForm2(context) {
    if (_formKey2.currentState != null && _formKey2.currentState!.validate()) {
      FirebaseService.changePassword(
          _oldPassController.text, _newPassController.text, context);
    }
  }

  void validatorForm1(context) {
    if (_formKey1.currentState != null && _formKey1.currentState!.validate()) {
      FirebaseService.changeDataProfile(
          _nameController.text, _phoneController.text, context);
    } else {
      print("gak valid");
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
          'Ubah Informasi Pengguna',
          style: appBarHai,
        ),
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(height: size.height * 0.01),
                          Padding(
                            padding: const EdgeInsets.only(
                              right: 25,
                              left: 25,
                              top: 10,
                            ),
                            child: Text(
                              'Profile',
                              style: tabLabel,
                            ),
                          ),
                          SizedBox(height: size.height * 0.01),
                          Form(
                            key: _formKey1,
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
                                  TextFieldWidget(
                                    labelText: 'Nama',
                                    hintText: 'Nama',
                                    icon: Icons.person_outlined,
                                    controller: _nameController,
                                    keyboardType: TextInputType.name,
                                    enabled: true,
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
                                    labelText: 'Email',
                                    hintText: 'Email',
                                    icon: Icons.email_outlined,
                                    controller: _emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    enabled: false,
                                  ),
                                  SizedBox(height: size.height * 0.03),
                                  TextFieldWidget(
                                    labelText: 'Nomor HP',
                                    hintText: 'Nomor HP',
                                    icon: Icons.phone_iphone_outlined,
                                    controller: _phoneController,
                                    keyboardType: TextInputType.phone,
                                    enabled: true,
                                    validator: (String? phone) {
                                      if (phone == null ||
                                          phone.trim().length == 0) {
                                        return "Nomor handphone tidak boleh kosong";
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(height: size.height * 0.01),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          primary: Colors.green,
                                        ),
                                        onPressed: () {
                                          LoadingPopup.loadingPopUp(
                                            context,
                                            'Ubah Informasi...',
                                          );
                                          new Future.delayed(
                                              new Duration(seconds: 3), () {
                                            validatorForm1(context);
                                            Navigator.pop(context); //pop dialog
                                          });
                                        },
                                        child: Text(
                                          'Save',
                                          style: textButton,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),

                          //tab change password
                          Padding(
                            padding: const EdgeInsets.only(
                              right: 25,
                              left: 25,
                              top: 10,
                            ),
                            child: Text(
                              'Change Password',
                              style: tabLabel,
                            ),
                          ),
                          SizedBox(height: size.height * 0.01),
                          Form(
                            key: _formKey2,
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
                                  PasswordFieldWidget(
                                    obscureText: _obscureTextOld,
                                    suffixPress: _toggleOld,
                                    labelText: 'Password lama',
                                    hintText: 'Masukan password lama anda',
                                    controller: _oldPassController,
                                    validator: (String? oldPassword) {
                                      if (oldPassword == null ||
                                          oldPassword.trim().length == 0) {
                                        return "Password lama tidak boleh kosong";
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(height: size.height * 0.03),
                                  PasswordFieldWidget(
                                    obscureText: _obscureTextNew,
                                    suffixPress: _toggleNew,
                                    labelText: 'Password baru',
                                    hintText: 'Masukan password baru anda',
                                    controller: _newPassController,
                                    validator: (String? newPassword) {
                                      if (newPassword == null ||
                                          newPassword.trim().length == 0) {
                                        return "Password baru tidak boleh kosong";
                                      } else if (newPassword !=
                                          _confirmPassController.text) {
                                        return "Password baru tidak cocok";
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(height: size.height * 0.03),
                                  PasswordFieldWidget(
                                    obscureText: _obscureTextConfirm,
                                    suffixPress: _toggleConfirm,
                                    labelText: 'Konfirmasi password',
                                    hintText: 'Konfirmasi password baru anda',
                                    controller: _confirmPassController,
                                    validator: (String? confirmPassword) {
                                      if (confirmPassword == null ||
                                          confirmPassword.trim().length == 0) {
                                        return "Password baru tidak boleh kosong";
                                      } else if (confirmPassword !=
                                          _newPassController.text) {
                                        return "Password baru tidak cocok";
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(height: size.height * 0.01),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          primary: Colors.green,
                                        ),
                                        onPressed: () {
                                          LoadingPopup.loadingPopUp(
                                            context,
                                            'Ubah Password...',
                                          );
                                          new Future.delayed(
                                              new Duration(seconds: 3), () {
                                            validatorForm2(context);
                                            Navigator.pop(context); //pop dialog
                                          });
                                        },
                                        child: Text(
                                          'Save',
                                          style: textButton,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
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
    );
  }
}
