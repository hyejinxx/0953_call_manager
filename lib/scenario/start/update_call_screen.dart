import 'package:call_0953_manager/scenario/main/bottom_nav.dart';
import 'package:call_0953_manager/service/call_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

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
    return Scaffold(
        backgroundColor: Colors.white,
        body: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Center(
                child: Stack(children: [Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Center(
                  child: Image(
                    image: AssetImage('assets/image/0953.gif'),
                    width: 350,
                    height: 350,
                  ),
                ),
                InkWell(
                  onTap: () async {
                    setState(() {
                      _saveState = SaveState.saving;
                    });
                    final result = await CallService().excelToCall();
                    if (result) {
                      setState(() {
                        _saveState = SaveState.success;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('콜 저장이 완료되었습니다.'),
                        duration: Duration(seconds: 1),
                      ));
                    } else {
                      setState(() {
                        _saveState = SaveState.fail;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('콜 저장에 실패하였습니다.'),
                        duration: Duration(seconds: 1),
                      ));
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.yellow,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset:
                              const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    width: 200,
                    padding: const EdgeInsets.all(20.0),
                    child: const Text(
                      '콜 저장하기',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),

                ),
                const SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BottomNavigation(),
                        ));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey[300],
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset:
                              const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    width: 200,
                    padding: const EdgeInsets.all(20.0),
                    child: const Text(
                      '유저 관리',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ), if (_saveState == SaveState.saving)
    const Positioned(
    top: 0,
    bottom: 0,
    left: 0,
    right: 0,
    child: Center(
    child: SizedBox(width: 70, height: 70, child: CircularProgressIndicator(backgroundColor: Colors.amber, strokeWidth: 7,)),
    ),
    ),  ]))));
  }
}
