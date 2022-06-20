import 'dart:convert';

import 'package:demo/model/user_model.dart';
import 'package:dio/dio.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/utils.dart';

import '../controller/usercontroller.dart';

class ApiServices {
  final UserController userController = Get.put(UserController());
  var dio = Dio();

  Future<List<UserElement>> fetchUsers() async {
    print(("fetchUsers called"));
    try {
      userController.isLoading.value = true;
      final Response response = await dio.get(
          "https://verified-mammal-79.hasura.app/api/rest/users",
          queryParameters: {"since": 5});
      userController.isLoading.value = false;
      if (response.statusCode == 200) {
        userController.userList.value = userController.searchList.value =
            userFromJson(jsonEncode(response.data)).users ?? [];
        return userController.userList;
      } else {
        throw Exception('Failed to load users');
      }
    } catch (e) {
      print(e);
    }
    return [];
  }
}
