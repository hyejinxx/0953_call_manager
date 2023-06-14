
import 'package:flutter/material.dart';

class MileageManageScreen extends StatefulWidget {
  const MileageManageScreen({super.key});

  @override
  State<MileageManageScreen> createState() => _MileageManageScreenState();
}

class _MileageManageScreenState extends State<MileageManageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('마일리지 관리'),
      ),
      body: const Center(
        child: Text('마일리지 관리'),
      ),
    );
  }
}
