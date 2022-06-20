import 'package:demo/controller/usercontroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../service/database_helper.dart';

class FavouriteUserScreen extends StatefulWidget {
  const FavouriteUserScreen({Key? key}) : super(key: key);
  @override
  State<FavouriteUserScreen> createState() => _FavouriteUserScreenState();
}

class _FavouriteUserScreenState extends State<FavouriteUserScreen> {
  final UserController userController = Get.find<UserController>();

  Future<void> favouriteUser() async {
    userController.isFavouriteLoading.value = true;
    userController.favouriteList.value = await DatabaseHelper().favourite();
    print(userController.favouriteList);
    userController.isFavouriteLoading.value = false;
  }

  @override
  void initState() {
    super.initState();
    favouriteUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0.05,
        backgroundColor: Colors.white60,
        title: const Text(
          "Favourite User Screen",
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
          ),
        ),
      ),
      body: Obx(
        () => Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 16),
          child: userController.isFavouriteLoading.value
              ? const Center(child: CircularProgressIndicator())
              : userController.favouriteList.isEmpty
                  ? const Center(
                      child: Text('NO USER FOUND'),
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      itemCount: userController.favouriteList.length,
                      itemBuilder: (context, index) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            ListTile(
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(60),
                                child: Image.asset(
                                  "assets/profile_image.jpeg",
                                ),
                              ),
                              title: Text(
                                '${userController.favouriteList[index].firstName} ${userController.favouriteList[index].lastName}',
                                style: const TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w500),
                              ),
                              subtitle: Text(
                                userController.favouriteList[index].bio ??
                                    "Lorem Ipsum is simply..",
                                style: const TextStyle(
                                    fontWeight: FontWeight.w400),
                              ),
                              trailing: (userController.favouriteList[index]
                                              .isFavourite !=
                                          null &&
                                      userController.favouriteList[index]
                                              .isFavourite ==
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
    );
  }
}
