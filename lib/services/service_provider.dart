import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class ServiceProvider with ChangeNotifier {

  int page = 1;
  List fetchedUsers = [];

  getUsers()async{
    final String usersApiUrl = 'https://6176555a03178d00173dab77.mockapi.io/users?page=$page&limit=10';
    final result = await http.get(Uri.parse(usersApiUrl)).then((res) {
      if(res.statusCode == 200 || res.statusCode == 201){
        print(res.body);
        return jsonDecode(res.body);
      }else{
        return null;
      }
    });
    return result;
  }


  addUser(String email, String imageUrl)async{
    const String usersApiUrl = 'https://6176555a03178d00173dab77.mockapi.io/users';
    final result = await http.post(Uri.parse(usersApiUrl),body: jsonEncode({
      'email' : email,
      'avatar' : imageUrl,
    })).then((res) {
      print(res.body);
      if(res.statusCode == 200 || res.statusCode == 201){
        return true;
      }else{
        return false;
      }
    });
    return result;
  }

  deleteUser(String id)async{
    final String usersApiUrl = 'https://6176555a03178d00173dab77.mockapi.io/users/$id';
    final result = await http.delete(Uri.parse(usersApiUrl)).then((res) {
      print(res.body);
      if(res.statusCode == 200 || res.statusCode == 201){
        return true;
      }else{
        return false;
      }
    });
    return result;
  }

  editUser(String id,Map editedBody)async{
    final String usersApiUrl = 'https://6176555a03178d00173dab77.mockapi.io/users/$id';
    final result = await http.patch(Uri.parse(usersApiUrl),body: editedBody).then((res) {
      print(res.body);
      if(res.statusCode == 200 || res.statusCode == 201){
        return jsonDecode(res.body);
      }else{
        return false;
      }
    });
    return result;
  }

  addLocation(String id,List locations)async{
    final String usersApiUrl = 'https://6176555a03178d00173dab77.mockapi.io/users/$id';
    String parsedLocations = '';
    for (var element in locations) {
      parsedLocations += element;
      if(element != locations.last){
        parsedLocations += ',';
      }
    }

    final result = await http.patch(Uri.parse(usersApiUrl),body: {
    'location': parsedLocations
    },headers: {
      'Accept': 'application/json'
    }).then((res) {
      print(res.body);
      if(res.statusCode == 200 || res.statusCode == 201){
        return true;
      }else{
        return false;
      }
    });
    return result;
  }
}
