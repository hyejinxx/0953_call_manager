import 'package:call_0953_manager/service/manager_service.dart';
import 'package:flutter/material.dart';

class CallNumberSettingScreen extends StatefulWidget {
  const CallNumberSettingScreen({super.key});

  @override
  State<CallNumberSettingScreen> createState() =>
      _CallNumberSettingScreenState();
}

class _CallNumberSettingScreenState extends State<CallNumberSettingScreen> {
  final _textController1 = TextEditingController();
  final _textController2 = TextEditingController();
  final _textController3 = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void setController() async {
    ManagerService().getCallNumber().then((value) {
      setState(() {
        _textController1.text = value['gisa'] ?? '';
        _textController2.text = value['taksong'] ?? '';
        _textController3.text = value['daeri'] ?? '';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.all(20.0),
            child: Center(
                child: Column(
              children: [
                SizedBox(
                  width: 300,
                  child: TextFormField(
                    controller: _textController1,
                    decoration: const InputDecoration(
                      labelText: '일일기사',
                    ),
                    obscureText: true,
                  ),
                ),
                const SizedBox(height: 20,),
                SizedBox(
                  width: 300,
                  child: TextFormField(
                    controller: _textController1,
                    decoration: const InputDecoration(
                      labelText: '탁송',
                    ),
                    obscureText: true,
                  ),
                ),
                const SizedBox(height: 20,),
                SizedBox(
                  width: 300,
                  child: TextFormField(
                    controller: _textController1,
                    decoration: const InputDecoration(
                      labelText: '대리운전',
                    ),
                    obscureText: true,
                  ),
                ),
                const SizedBox(height: 20,),
                ElevatedButton(
                  onPressed: () {
                   ManagerService().setCallNumber({'gisa':_textController1.text,'taksong':_textController2.text,'daeri':_textController3.text}).then((value) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('수정되었습니다.')));
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                  ),
                  child: const Text('수정',
                      style: TextStyle(color: Colors.black)),
                ),
              ],
            ))));
  }
}
