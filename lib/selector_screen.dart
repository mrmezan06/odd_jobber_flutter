import 'package:flutter/material.dart';
import 'package:odd_jobber/User/login_screen.dart';
import 'package:get/get.dart';

void _userHome() async {
  Get.to(LoginPage());
}

class selector_screen extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:Text('Registration'),),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Please, Choose One'),
            SizedBox(height: 8.0),
            ElevatedButton(
              onPressed:_userHome,
              child: Text("Client Login"),
            ),
            SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: () {
                // Respond to button press
              },
              child: Text("Worker Login"),
            ),
          ],
        ),
      ),
    );
  }
}