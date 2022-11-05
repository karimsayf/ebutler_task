import 'dart:convert';

import 'package:ebutler_task/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';

class DeskStorage with ChangeNotifier {
  static const secureStorage = FlutterSecureStorage();

  addUser({required User user}) async {
    final key = await secureStorage.read(key: 'key');
    final encryptionKey = base64Url.decode(key!);
    var hive = await Hive.openBox('Users',
        encryptionCipher: HiveAesCipher(encryptionKey));

    await hive.add({
      'email' : user.email,
      'password' : user.password,
    });
  }
  
  setAuthenticatedUser(User user)async{
    final key = await secureStorage.read(key: 'key');
    final encryptionKey = base64Url.decode(key!);
    var hive = await Hive.openBox('Auth',
        encryptionCipher: HiveAesCipher(encryptionKey));

    await hive.put('email', user.email);
    await hive.put('lastLogin', DateTime.now());
  }

  getUsers() async {
    final key = await secureStorage.read(key: 'key');
    final encryptionKey = base64Url.decode(key!);
    var hive = await Hive.openBox('Users',
        encryptionCipher: HiveAesCipher(encryptionKey));
    return hive.toMap();
  }
  
  getAuthUser()async{
    final key = await secureStorage.read(key: 'key');
    final encryptionKey = base64Url.decode(key!);
    var hive = await Hive.openBox('Auth',
        encryptionCipher: HiveAesCipher(encryptionKey));
    return {
      'email' : hive.get('email'),
      'lastLogin' : hive.get('lastLogin')
    };
  }

  clearAllUsers()async{
    final key = await secureStorage.read(key: 'key');
    final encryptionKey = base64Url.decode(key!);
    var hive = await Hive.openBox('Users',
        encryptionCipher: HiveAesCipher(encryptionKey));
    return hive.clear();
  }

}