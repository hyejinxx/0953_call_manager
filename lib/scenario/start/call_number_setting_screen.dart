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
    setController(); // TODO: implement initState
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
        appBar: AppBar(
          title: Text('전화번호 설정',
              style: const TextStyle(color: Colors.black),
              textAlign: TextAlign.center),
          backgroundColor: Colors.transparent,
          centerTitle: true,
          elevation: 0,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(0),
            child: Container(
              color: Colors.grey[300],
              height: 1,
            ),
          ),
          leadingWidth: 100,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            color: Colors.black,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        backgroundColor: Colors.white,
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
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: 300,
                  child: TextFormField(
                    controller: _textController2,
                    decoration: const InputDecoration(
                      labelText: '탁송',
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: 300,
                  child: TextFormField(
                    controller: _textController3,
                    decoration: const InputDecoration(
                      labelText: '대리운전',
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    ManagerService().setCallNumber({
                      'gisa': _textController1.text,
                      'taksong': _textController2.text,
                      'daeri': _textController3.text
                    }).then((value) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('수정되었습니다.')));
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                  ),
                  child:
                      const Text('수정', style: TextStyle(color: Colors.black)),
                ),
              ],
            ))));
  }
}
