import 'package:call_0953_manager/service/call_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class UpdateCallScreen extends StatefulWidget {
  const UpdateCallScreen({Key? key}) : super(key: key);

  @override
  State<UpdateCallScreen> createState() => _UpdateCallScreenState();
}

class _UpdateCallScreenState extends State<UpdateCallScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text('콜 내역 저장',
                style: TextStyle(color: Colors.black),
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
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              color: Colors.black,
              onPressed: () {
                Navigator.pop(context);
              },
            )),
        body: Column(
          children: [
            InkWell(
              onTap: () async {
                CallService().excelToCall();
              },
              child: Container(
                padding: const EdgeInsets.all(20.0),
                child: Text('파일 가져오기')

              ),
            ),

          ],

        ));
  }
}
