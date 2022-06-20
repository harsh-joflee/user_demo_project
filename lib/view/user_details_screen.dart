// ignore_for_file: deprecated_member_use
import 'package:demo/controller/usercontroller.dart';
import 'package:demo/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../service/database_helper.dart';

class UserDetails extends StatefulWidget {
  final UserElement user;
  final int index;
  const UserDetails({Key? key, required this.user, required this.index})
      : super(key: key);
  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  final TextEditingController biocontroller = TextEditingController();
  final UserController userController = Get.find<UserController>();

  void _toggleFavorite() {
    userController.isFavorited.value = !userController.isFavorited.value;
    widget.user.isFavourite = userController.isFavorited.value;
    print("isFavorited: ${widget.user.isFavourite}");
  }

  UserElement? user;
  @override
  Widget build(BuildContext context) {
    biocontroller.text = widget.user.bio ?? '';
    userController.isFavorited.value = widget.user.isFavourite ?? false;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white60,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        leading: IconButton(
          onPressed: () {
            Get.back(result: user ?? widget.user);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
          ),
        ),
        actions: [
          Obx(
            () => IconButton(
              icon: (userController.isFavorited.value
                  ? Icon(
                      Icons.star,
                      color: Colors.yellow[700],
                    )
                  : const Icon(
                      Icons.star,
                      color: Colors.grey,
                    )),
              iconSize: 30,
              onPressed: _toggleFavorite,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(80),
              child: Image.asset(
                "assets/profile_image.jpeg",
                height: 125,
                width: 125,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25),
              child: Row(
                children: <Widget>[
                  Row(
                    children: [
                      Text(
                        "FirstName \n" "${widget.user.firstName ?? "N/A"}",
                        style: const TextStyle(fontSize: 15),
                      ),
                      const SizedBox(
                        width: 80,
                        height: 80,
                      ),
                      Text(
                        "LastName \n" "${widget.user.lastName ?? "N/A"}",
                        style: const TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.only(left: 25),
              child: Row(
                children: [
                  Text(
                    "Email \n" "${widget.user.email ?? "N/A"}",
                    style: const TextStyle(fontSize: 15),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            SizedBox(
              height: 100,
              width: 300,
              child: TextFormField(
                controller: biocontroller,
                onChanged: (value) {
                  widget.user.bio = biocontroller.text.toString();
                  print("Bio: ${widget.user.bio}");
                },
                decoration: InputDecoration(
                  labelText: "Bio",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 80),
            SizedBox(
              height: 50,
              width: 325,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    )),
                child: const Text(
                  "Save",
                  style: TextStyle(fontSize: 20),
                ),
                onPressed: () async {
                  int updatedId = await DatabaseHelper()
                      .update(userController.userList[widget.index]);
                  userController.userList.value = userController.searchList
                      .value = await DatabaseHelper().getAllUserElement();
                  print(
                      "isFavorited: ${userController.userList[widget.index].isFavourite}");
                  user = userController.userList[widget.index];
                  Get.back(result: user ?? widget.user);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
