import 'package:flappwrite_water_tracker/pages/home.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlAppwirte Water Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: AppBarTheme(
          elevation: 0,
          color: Colors.transparent,
          iconTheme: IconThemeData(color: Colors.blue),
          actionsIconTheme: IconThemeData(color: Colors.blue),
          titleTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
          textTheme: TextTheme(
            headline6: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      home: HomePage(),
    );
  }
}
