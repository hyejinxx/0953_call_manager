import 'package:call_0953_manager/model/mileage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../service/mileage_service.dart';

class MileageAddScreen extends StatefulWidget {
  const MileageAddScreen({Key? key, this.call, this.name}) : super(key: key);

  final String? call;
  final String? name;

  @override
  State<MileageAddScreen> createState() => _MileageAddScreenState();
}

class _MileageAddScreenState extends State<MileageAddScreen> {
  final phoneTextController = TextEditingController();
  final amountTextController = TextEditingController();
  final memoTextController = TextEditingController(text: '이벤트 마일리지');

  @override
  void initState() {
    if (widget.call == null) {
      phoneTextController.text = '';
    } else {
      phoneTextController.text = widget.call!;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('마일리지 입력', style: TextStyle(color: Colors.black), textAlign: TextAlign.center),
          backgroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(0),
            child: Container(
              color: Colors.grey[300],
              height: 1,
            ),
          ),
        ),
        backgroundColor: Colors.white,
        body: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                child: TextField(
                  controller: phoneTextController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '마일리지를 적립할 전화번호를 입력하세요.',
                  ),
                  obscureText: false,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                child: TextField(
                  controller: amountTextController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '마일리지 금액을 입력하세요',
                  ),
                  obscureText: false,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                child: TextField(
                  controller: memoTextController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '마일리지 사유',
                  ),
                  obscureText: false,
                ),
              ),
              ElevatedButton(
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(const Size(80, 50)),
                  backgroundColor: MaterialStateProperty.all(const Color.fromRGBO(249, 224, 0, 1.0)),
                ),
                onPressed: () async {
                  if (phoneTextController.text.isEmpty) {
                    showSnackBar('전화번호를 입력해주세요.');
                    return;
                  }
                  if (amountTextController.text.isEmpty || amountTextController.text == '0') {
                    showSnackBar('금액을 입력해주세요.');
                    return;
                  }
                  MileageService()
                      .saveMileage(Mileage(
                          orderNumber: DateTime.now().millisecondsSinceEpoch.toString() + phoneTextController.text,
                          name: widget.name ?? '',
                          call: phoneTextController.text,
                          type: memoTextController.text,
                          amount: int.parse(amountTextController.text),
                          startAddress: '',
                          endAddress: '',
                          sumMileage: 0,
                          date: DateFormat('yyyy-MM-dd').format(DateTime.now())))
                      .then((value) {
                    showSnackBar('적립되었습니다.');
                    Navigator.pop(context);
                  });
                },
                child: const Text('적립', style: TextStyle(color: Colors.black)),
              ),
            ])));
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 1),
      ),
    );
  }
}
