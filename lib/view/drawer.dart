import 'package:demo/service/database_helper.dart';
import 'package:demo/view/favourite_user_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/usercontroller.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  final UserController userController = Get.find<UserController>();

  Future<void> deleteUser() async {
    userController.isLoading.value = true;
    userController.userList.value = userController.searchList.value =
        await DatabaseHelper().deleteAllUserElement();
    userController.isLoading.value = false;
    print(userController.userList);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Drawer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(top: 35, bottom: 20),
              child: const DrawerHeader(
                child: Center(
                  child: CircleAvatar(
                    radius: 80,
                    backgroundImage: AssetImage(
                      "assets/profile_image.jpeg",
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            const ListTile(
              leading: Icon(
                Icons.home,
                size: 30,
                color: Colors.black,
              ),
              title: Text(
                "Home",
                style: TextStyle(fontSize: 20),
              ),
            ),
            GestureDetector(
              onTap: () {
                Get.to(const FavouriteUserScreen());
              },
              child: ListTile(
                leading: Icon(
                  Icons.star,
                  size: 30,
                  color: Colors.yellow[700],
                ),
                title: const Text(
                  "Favourite",
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () async {
                await deleteUser();
              },
              child: const Padding(
                padding: EdgeInsets.only(bottom: 30),
                child: Center(
                  child: Text(
                    "Clear data",
                    style: TextStyle(
                      color: Colors.transparent,
                      fontSize: 16,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.red,
                      shadows: [
                        Shadow(
                          color: Colors.red,
                          offset: Offset(0, -3),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
