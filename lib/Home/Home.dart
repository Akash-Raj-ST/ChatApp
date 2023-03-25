import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {

  final int userID;

  const HomePage({super.key, required this.userID});

  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        appBar: AppBar(title: Text("Akash...${userID}")),
        body: const Center(
          child: Text("Welcome"),
        ),
      );
  }
}