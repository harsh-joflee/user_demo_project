// ignore_for_file: deprecated_member_use, unrelated_type_equality_checks
import 'package:demo/controller/usercontroller.dart';
import 'package:demo/model/user_model.dart';
import 'package:demo/service/network_services.dart';
import 'package:demo/view/drawer.dart';
import 'package:demo/view/user_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../service/database_helper.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({Key? key}) : super(key: key);

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  final UserController userController = Get.put(UserController());
  @override
  void initState() {
    NetWorkConection().checkstatus(context);
    userController.checkDatabaseStatusAndGetUserList();
    super.initState();
  }

  Future<void> searchUser(String value) async {
    if (value != '') {
      userController.searchList.value = await DatabaseHelper().search(value);
    } else {
      userController.searchList.value = await DatabaseHelper().search('');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0.05,
        backgroundColor: Colors.white60,
        title: Container(
          width: double.infinity,
          height: 40,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(20)),
          child: Center(
            child: TextField(
              onChanged: (value) {
                searchUser(value);
              },
              decoration: const InputDecoration(
                suffixIcon: Icon(Icons.search),
                hintText: 'Search',
                hintStyle: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                contentPadding: EdgeInsets.only(left: 10, top: 6),
                border: InputBorder.none,
              ),
            ),
          ),
        ),
      ),
      body: Obx(
        () => Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 16),
          child: userController.isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : userController.searchList.isEmpty
                  ? const Center(
                      child: Text('NO USER FOUND'),
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      itemCount: userController.searchList.length,
                      itemBuilder: (context, index) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            ListTile(
                              onTap: () async {
                                UserElement result = await Get.to(UserDetails(
                                  user: userController.searchList[index],
                                  index: index,
                                ));
                                userController.searchList[index] = result;
                              },
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(60),
                                child: Image.asset(
                                  "assets/profile_image.jpeg",
                                ),
                              ),
                              title: Text(
                                '${userController.searchList[index].firstName} ${userController.searchList[index].lastName}',
                                style: const TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w500),
                              ),
                              subtitle: Text(
                                userController.searchList[index].bio ??
                                    "Lorem Ipsum is simply..",
                                style: const TextStyle(
                                    fontWeight: FontWeight.w400),
                              ),
                              trailing: (userController
                                              .searchList[index].isFavourite !=
                                          null &&
                                      userController
                                              .searchList[index].isFavourite ==
                                          true
                                  ? Icon(
                                      Icons.star,
                                      color: Colors.yellow[700],
                                      size: 30,
                                    )
                                  : const Icon(
                                      Icons.star,
                                      color: Colors.grey,
                                      size: 30,
                                    )),
                            ),
                          ],
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const Padding(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: Divider(),
                        );
                      },
                    ),
        ),
      ),
      drawer: const MyDrawer(),
    );
  }
}
