import 'package:chatapp/service/authentication.dart';
import 'package:flutter/material.dart';

import 'package:chatapp/Auth/auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context)=>AuthenticationService())
      ],
      child: const MaterialApp(
        title: 'Flutter Demo',
        home: Authentication(),
      ),
    );
  }
}

