import 'package:flutter/material.dart';

class UserManageScreen extends StatefulWidget {
  const UserManageScreen({super.key});

  @override
  State<UserManageScreen> createState() => _UserManageScreenState();
}

class _UserManageScreenState extends State<UserManageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('회원 관리'),
      ),
      body: const Center(
        child: Text('회원 관리'),
      ),
    );
  }
}
