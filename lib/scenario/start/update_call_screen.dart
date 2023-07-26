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
    return SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Center(
            child: Stack(children: [
          SingleChildScrollView(
              child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Center(
                child: Image(
                  image: AssetImage('assets/image/0953.gif'),
                  width: 250,
                  height: 250,
                ),
              ),
              Button(
                  style: ButtonStyle(
                    backgroundColor: ButtonState.all(
                      Colors.yellow,
                    ),
                    elevation: ButtonState.all(10),
                    foregroundColor: ButtonState.all(Colors.white),
                  ),
                  child: const Text(
                    '콜 저장',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
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
                      ma.ScaffoldMessenger.of(context)
                          .showSnackBar(const ma.SnackBar(
                        content: Text('콜 저장이 완료되었습니다.'),
                        duration: Duration(seconds: 1),
                      ));
                    } else {
                      setState(() {
                        _saveState = SaveState.fail;
                      });
                      ma.ScaffoldMessenger.of(context)
                          .showSnackBar(const ma.SnackBar(
                        content: Text('콜 저장에 실패하였습니다.'),
                        duration: Duration(seconds: 1),
                      ));
                    }
                  }),
              const SizedBox(
                height: 20,
              ),
              mainBotton(
                  '전화번호 설정',
                  () => Navigator.push(
                      context,
                      ma.MaterialPageRoute(
                        builder: (context) => const CallNumberSettingScreen(),
                      ))),
              const SizedBox(
                height: 20,
              ),
              mainBotton('마일리지 설정', () {
                Navigator.push(
                    context,
                    ma.MaterialPageRoute(
                      builder: (context) => const MileageSettingScreen(),
                    ));
              }),
              const SizedBox(
                height: 20,
              ),
              mainBotton('이벤트 마일리지 설정', () {
                Navigator.push(
                    context,
                    ma.MaterialPageRoute(
                      builder: (context) => const BonusMileageSettingScreen(),
                    ));
              }),
            ],
          )),
          if (_saveState == SaveState.saving)
            const Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              right: 0,
              child: Center(
                child: SizedBox(width: 70, height: 70, child: ProgressRing()),
              ),
            ),
        ])));
  }

  Widget mainBotton(String text, Function() onTap) {
    return Button(
        style: ButtonStyle(
          backgroundColor: ButtonState.all(
            Colors.yellow,
          ),
          elevation: ButtonState.all(10),
          foregroundColor: ButtonState.all(Colors.white),
        ),
        onPressed: onTap,
        child: Text(
          text,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ));
  }
}
