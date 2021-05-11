import 'package:appwrite/appwrite.dart';
import 'package:flappwrite_water_tracker/data/service/api_service.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          ElevatedButton(
              onPressed: () async {
                try {
                  await ApiService.instance.verifyEmail();
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Verification email sent")));
                } on AppwriteException catch (e) {
                  print(e.message);
                }
              },
              child: Text("Verify email"))
        ],
      ),
    );
  }
}
