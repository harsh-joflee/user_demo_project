import 'package:demo/service/api_services.dart';
import 'package:dio/dio.dart';
import 'package:get/state_manager.dart';

import '../model/user_model.dart';
import '../service/database_helper.dart';

class UserController extends GetxController {
  RxBool isDialogOpen = false.obs;
  RxInt connectionStatus = 0.obs;
  RxBool isLoading = false.obs;
  RxBool isFavorited = false.obs;
  RxBool isFavouriteLoading = false.obs;
  
  RxList<UserElement> searchList = <UserElement>[].obs;
  RxList<UserElement> userList = <UserElement>[].obs;
  RxList<UserElement> favouriteList = <UserElement>[].obs;
  var dio = Dio();

  Future<List<UserElement>> checkDatabaseStatusAndGetUserList() async {
    isLoading.value = true;
    userList.value =
        searchList.value = await DatabaseHelper().getAllUserElement();
    isLoading.value = false;
    print("Database UserList $userList ");
    if (userList.isEmpty) {
      await ApiServices().fetchUsers();
      //insert data
      await DatabaseHelper().insert(userList);
      print("Api UserList $userList");
      return searchList;
    }
    return searchList;
  }
}
