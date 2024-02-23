// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Container(height: MediaQuery.of(context).size.height,
        width:  MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
        gradient: LinearGradient(  begin: Alignment.topLeft,
      end: Alignment.bottomRight,
        colors: [Colors.purple, Colors.blueAccent],
        )
        ),
          child: Column(
            children: [
              Text('hello')
            ],
          ),
        ),
      )),
    );
  }
}
