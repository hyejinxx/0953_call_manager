import 'package:call_0953_manager/scenario/start/call_number_setting_screen.dart';
import 'package:call_0953_manager/scenario/start/mileage_setting_screen.dart';
import 'package:call_0953_manager/service/call_service.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as ma;

import 'bonus_mileage_setting_screen.dart';

enum SaveState { init, saving, success, fail }

class UpdateCallScreen extends StatefulWidget {
  const UpdateCallScreen({Key? key}) : super(key: key);

  @override
  State<UpdateCallScreen> createState() => _UpdateCallScreenState();
}

class _UpdateCallScreenState extends State<UpdateCallScreen> {
  SaveState _saveState = SaveState.init;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('콜 관리'),
          const SizedBox(height: 10),
          Button(
              child: const Text('콜 저장(구)'),
              onPressed: () async {
                setState(() {
                  _saveState = SaveState.saving;
                });
                final result = await CallService()
                    .excelToCall()
                    .onError((error, stackTrace) => false);
                if (result) {
                  setState(() {
                    _saveState = SaveState.success;
                  });
                  ma.ScaffoldMessenger.of(context).showSnackBar(const ma.SnackBar(
                    content: Text('콜 저장이 완료되었습니다.'),
                    duration: Duration(seconds: 1),
                  ));
                } else {
                  setState(() {
                    _saveState = SaveState.fail;
                  });
                  ma.ScaffoldMessenger.of(context).showSnackBar(const ma.SnackBar(
                    content: Text('콜 저장에 실패하였습니다.'),
                    duration: Duration(seconds: 1),
                  ));
                }
              }),
          const SizedBox(height: 10),
          Button(child: const Text('콜 저장(신)'), onPressed: () {}),
          const SizedBox(height: 20),
          const Text('마일리지 설정'),
          const SizedBox(height: 10),
          Button(
              child: const Text('마일리지 설정'),
              onPressed: () {
                Navigator.push(
                    context,
                    ma.MaterialPageRoute(
                      builder: (context) => const MileageSettingScreen(),
                    ));
              }),
          const SizedBox(height: 10),
          Button(
              child: const Text('이벤트 마일리지 설정'),
              onPressed: () {
                Navigator.push(
                    context,
                    ma.MaterialPageRoute(
                      builder: (context) => const BonusMileageSettingScreen(),
                    ));
              }),
          const SizedBox(height: 20),
          const Text('기타 설정'),
          Button(
              child: const Text('전화번호 설정'),
              onPressed: () => Navigator.push(
                  context,
                  ma.MaterialPageRoute(
                    builder: (context) => const CallNumberSettingScreen(),
                  ))),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget mainBotton(String text, Function() onTap) {
    return Button(
        style: ButtonStyle(
          backgroundColor: ButtonState.all(
            Colors.yellow,
          ),
          foregroundColor: ButtonState.all(Colors.black),
        ),
        onPressed: onTap,
        child: Text(
          text,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ));
  }
}
