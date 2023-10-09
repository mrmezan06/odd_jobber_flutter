import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:odd_jobber/User/user_profile.dart';

class HomePage extends StatelessWidget {



  


  final ButtonStyle style = ElevatedButton.styleFrom(
      minimumSize: Size(188, 48),
      backgroundColor: Color(0xFF051B8B),
      elevation: 6,
      textStyle: const TextStyle(fontSize: 16),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(50),
          )));

  // void _userHome(var phone) async {
  //   Get.to(UserProfileScreen());
  // }

  void userHome(phone){
    Get.to(UserProfileScreen(), arguments: [phone]);
  }

  @override
  Widget build(BuildContext context) {
    var data = Get.arguments;
    var phone = data[0];
    var id = data[1];
    //print(phone);

    return Scaffold(
      backgroundColor: const Color(0xff0F2B2F),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Welcome to Flutter!',
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
                style: style,
                onPressed: () => userHome(phone),
                child: const Text(
                  'TEST AGAIN',
                  style: TextStyle(fontSize: 14, color: Colors.white),
                )),
          ],
        ),
      ),
    );
  }
}