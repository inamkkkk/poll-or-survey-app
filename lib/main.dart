import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:poll_app/providers/poll_provider.dart';
import 'package:poll_app/screens/poll_list_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PollProvider(),
      child: MaterialApp(
        title: 'Poll App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: PollListScreen(),
      ),
    );
  }
}