import 'package:call_0953_manager/model/faq.dart';
import 'package:call_0953_manager/service/announcement_service.dart';
import 'package:flutter/material.dart';

class NewFaQScreen extends StatefulWidget {
  const NewFaQScreen({super.key});

  @override
  State<NewFaQScreen> createState() => _NewFaQScreenState();
}

class _NewFaQScreenState extends State<NewFaQScreen> {
  final questionTextController = TextEditingController();
  final answerTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
          child: TextField(
              controller: answerTextController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              maxLength: 300,
              style: const TextStyle(
                fontSize: 14.0,
              ),
              decoration: InputDecoration(
                focusedBorder:
                    const UnderlineInputBorder(borderSide: BorderSide.none),
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding: const EdgeInsets.all(16),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(12),
                ),
                hintText: '질문을 적어주세요',
                hintStyle: TextStyle(
                  color: Colors.black.withOpacity(0.7),
                  fontSize: 14.0,
                ),
              )),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
          child: TextField(
              controller: answerTextController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              maxLength: 10000,
              style: const TextStyle(
                fontSize: 14.0,
              ),
              decoration: InputDecoration(
                focusedBorder:
                    const UnderlineInputBorder(borderSide: BorderSide.none),
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding: const EdgeInsets.all(16),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(12),
                ),
                hintText: '대답을 적어주세요',
                hintStyle: TextStyle(
                  color: Colors.black.withOpacity(0.7),
                  fontSize: 14.0,
                ),
              )),
        ),
        SizedBox(
          height: 20,
        ),
        InkWell(
            onTap: () {
              if (questionTextController.text.isEmpty ||
                  answerTextController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('질문과 답변을 모두 입력해주세요'),
                  ),
                );
              } else {
                final faq = FAQ(
                  question: questionTextController.text,
                  answer: answerTextController.text,
                  createdAt: DateTime.now().toString(),
                  writer: '관리자',
                  state: '등록',
                );
                AnnouncementService().saveFAQ(faq).then((value) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('등록되었습니다'),
                    ),
                  );
                  Navigator.pop(context);
                }).onError((error, stackTrace){
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('등록에 실패했습니다'),
                    ),
                  );
                }).whenComplete((){
                  questionTextController.clear();
                  answerTextController.clear();
                });
              }
            },
            child: Container(
              color: Colors.yellow.withOpacity(0.7),
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: const Text('등록하기',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 16.0)),
            ))
      ],
    ));
  }
}
