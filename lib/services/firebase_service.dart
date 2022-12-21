import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:smart_aquarium/components/utils/toast_message.dart';
import 'package:smart_aquarium/main.dart';

late final _ref = FirebaseDatabase.instance.ref();

class FirebaseService {
  static Future getDataSensor() async {
    final snapshot = _ref.child('data_sensor').get();
    return snapshot;
  }

  static Future addUser(email, password, phone, name, context) async {
    FirebaseApp app = await Firebase.initializeApp(
      name: 'secondary',
      options: Firebase.app().options,
    );
    try {
      UserCredential userCredential = await FirebaseAuth.instanceFor(app: app)
          .createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      final thisUser = FirebaseAuth.instanceFor(app: app).currentUser!;
      FirebaseDatabase.instanceFor(app: app)
          .ref('users')
          .child(thisUser.uid)
          .set({
        'displayName': name,
        'email': email,
        'phonenumber': phone,
        'role': 'user',
      });
      ToastMessage.successMessage('Pengguna baru $name berhasil ditambahkan');
      Navigator.of(context).pop('String');
      await app.delete();
      return Future.sync(() => userCredential);
    } on FirebaseAuthException catch (e) {
      ToastMessage.errorMessage(e.toString());
    }
  }

  static Future changeDataProfile(String name, String phone, context) async {
    Map<String, String> data = {"displayName": name, "phonenumber": phone};
    final currentUser = FirebaseAuth.instance.currentUser!;
    _ref.child('users').child(currentUser.uid).update(data);
    Navigator.of(context).pop('String'); //
    ToastMessage.successMessage('Data pribadi anda berhasil diubah');
  }

  static Future changePassword(
      String oldPassword, String newPassword, context) async {
    final currentUser = FirebaseAuth.instance.currentUser!;
    try {
      final credential = EmailAuthProvider.credential(
        email: currentUser.email.toString(),
        password: oldPassword,
      );
      await currentUser.reauthenticateWithCredential(credential).then((value) {
        currentUser.updatePassword(newPassword).then((_) {});
      });
      ToastMessage.successMessage('Password anda berhasil diubah');
      Navigator.of(context).pop('String');
    } on FirebaseAuthException catch (e) {
      ToastMessage.errorMessage(e.toString());
    }
  }

  static Future resetPassword(email, context) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      ToastMessage.successMessage('Reset password telah dikirim pada email');
      Navigator.of(context).pop('String');
    } on FirebaseAuthException catch (e) {
      ToastMessage.errorMessage(e.toString());
    }
  }

  static Future emailSignIn(String email, String password, context) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
            email: email.trim(),
            password: password.trim(),
          )
          .then((value) => Navigator.pop(context));
      ToastMessage.successLogin('$email Berhasil Masuk');
      OneSignal.shared.disablePush(false);
    } on FirebaseAuthException catch (e) {
      ToastMessage.errorMessage(e.toString());
    }
  }

  static Future signOut() async {
    FirebaseAuth.instance.signOut();
    OneSignal.shared.disablePush(true);
  }

  //service untuk halaman kontrol
  static Future updateModeControl(bool modeSwitched) async {
    _ref.update({'control/pump/mode': modeSwitched});
    _ref.update({'control/cooler/mode': modeSwitched});
    _ref.update({'control/drain/mode': modeSwitched});
    _ref.update({'control/heater/mode': modeSwitched});
    _ref.update({'control/servo/mode': modeSwitched});
    _ref.update({'control/uv/mode': modeSwitched});
    //ketika mode di ubah menjadi manual maupun otomatis, matikan semua control
    _ref.update({'control/pump/value': false});
    _ref.update({'control/cooler/value': false});
    _ref.update({'control/drain/value': false});
    _ref.update({'control/heater/value': false});
    _ref.update({'control/servo/value': false});
    _ref.update({'control/uv/value': false});
  }

  static Future updateSwitchControl(bool isSwitched, String key) async {
    _ref.child("control/$key").update({'value': isSwitched});
  }

  //service untuk halaman konfigurasi kontrol
  static Future saveJadwalPakan(hour1, minute1, hour2, minute2) async {
    try {
      _ref.child("jadwal_pakan/pkn1").update({
        'jam': hour1,
        'menit': minute1,
      });
      _ref.child("jadwal_pakan/pkn2").update({
        'jam': hour2,
        'menit': minute2,
      });
      ToastMessage.successMessage('Data Penjadwalan Pakan berhasil diubah');
    } catch (e) {
      ToastMessage.errorMessage(e.toString());
    }
  }

  static Future saveKonfigurasi(suhuMaks, suhuMin, phMaks, phMin, keruhMaks,
      amoniaMaks, airMaks, airMin, pakanMin, tinggiAkuarium) async {
    try {
      _ref.child("konfigurasiKontrol").update({
        'suhu_maks': suhuMaks,
        'suhu_min': suhuMin,
        'ph_maks': phMaks,
        'ph_min': phMin,
        'keruh_maks': keruhMaks,
        'amonia_maks': amoniaMaks,
        'air_maks': airMaks,
        'air_min': airMin,
        'pakan_min': pakanMin,
        'tinggi_akuarium': tinggiAkuarium,
      });
      ToastMessage.successMessage('Data Konfigurasi berhasil diubah');
    } catch (e) {
      ToastMessage.errorMessage(e.toString());
    }
  }

  //service untuk halaman data pertumbuhan ikan
  static Future getPertumbuhanIkan(String search) async {
    if (search.length > 0) {
      final snapshot = _ref.child('pertumbuhan').orderByChild('$search').get();
      return snapshot;
    }
    final snapshot = _ref.child('pertumbuhan').get();
    return snapshot;
  }

  static Future savePertumbuhanIkan(
      String date, String name, double long, String system) async {
    try {
      _ref.child("pertumbuhan").push().set({
        'date': date,
        'name': name,
        'long': long,
        'system': system,
      });
      ToastMessage.successMessage('Data pertumbuhan ikan berhasil ditambah');
    } catch (e) {
      ToastMessage.errorMessage(e.toString());
    }
  }

  static Future editPertumbuhanIkan(
      String date, String name, double long, String system, String id) async {
    try {
      _ref.child("pertumbuhan/$id").update({
        'date': date,
        'name': name,
        'long': long,
        'system': system,
      });
      ToastMessage.successMessage('Data pertumbuhan ikan berhasil diubah');
    } catch (e) {
      ToastMessage.errorMessage(e.toString());
    }
  }

  static Future deletePertumbuhanIkan(String id) async {
    try {
      _ref.child("pertumbuhan/$id").remove();
      ToastMessage.successMessage('Data pertumbuhan ikan berhasil dihapus');
    } catch (e) {
      ToastMessage.errorMessage(e.toString());
    }
  }

  static Future<List> jadwalpakan() async {
    final snapshot = await FirebaseDatabase.instance.ref('jadwal_pakan').get();
    final dataSnapshot =
        jsonDecode(jsonEncode(snapshot.value)) as Map<String, dynamic>;
    List listData = [
      dataSnapshot['pkn1']['jam'],
      dataSnapshot['pkn1']['menit'],
      dataSnapshot['pkn2']['jam'],
      dataSnapshot['pkn2']['menit']
    ];
    return listData;
  }

  static Future<List> configurecontrol() async {
    final snapshot =
        await FirebaseDatabase.instance.ref('konfigurasiKontrol').get();
    final dataSnapshot =
        jsonDecode(jsonEncode(snapshot.value)) as Map<String, dynamic>;
    List listData = [
      dataSnapshot['ph_maks'],
      dataSnapshot['ph_min'],
      dataSnapshot['suhu_maks'],
      dataSnapshot['suhu_min'],
      dataSnapshot['keruh_maks'],
      dataSnapshot['amonia_maks'],
      dataSnapshot['air_min'],
      dataSnapshot['air_maks'],
      dataSnapshot['pakan_min'],
      dataSnapshot['tinggi_akuarium'],
    ];
    return listData;
  }
}
