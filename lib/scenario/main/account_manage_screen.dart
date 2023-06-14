

import 'package:flutter/material.dart';

class AccountManageScreen extends StatefulWidget {
  const AccountManageScreen({Key? key}) : super(key: key);

  @override
  State<AccountManageScreen> createState() => _AccountManageScreenState();
}

class _AccountManageScreenState extends State<AccountManageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('출금 내역 관리'),
      ),
      body: const Center(
        child: Text('출금 내역 관리'),
      ),
    );
  }
}
