import 'package:call_0953_manager/model/faq.dart';
import 'package:call_0953_manager/service/announcement_service.dart';
import 'package:fluent_ui/fluent_ui.dart';

class NewFaQScreen extends StatefulWidget {
  NewFaQScreen({super.key, this.faq});

  FAQ? faq;

  @override
  State<NewFaQScreen> createState() => _NewFaQScreenState();
}

class _NewFaQScreenState extends State<NewFaQScreen> {
  final questionTextController = TextEditingController();
  final answerTextController = TextEditingController();

  @override
  void initState() {
    questionTextController.text = widget.faq?.question ?? '';
    answerTextController.text = widget.faq?.answer ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(FluentIcons.back)),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(10)),
              child: TextFormBox(
                controller: questionTextController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                maxLength: 300,
                style: const TextStyle(
                  fontSize: 14.0,
                ),
                placeholder: '질문을 적어주세요',
                obscureText: false,
                padding: const EdgeInsets.all(16),
              ),
            ),
            Expanded(
                child: Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: Colors.white),
              child: TextFormBox(
                controller: answerTextController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                maxLength: 10000,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white)),
                style: const TextStyle(
                  fontSize: 14.0,
                ),
                placeholder: '대답을 적어주세요',
                padding: const EdgeInsets.all(16),
              ),
            )),
            GestureDetector(
                onTap: () {
                  if (questionTextController.text.isEmpty ||
                      answerTextController.text.isEmpty) {
                    showInfoBar(
                        '입력 오류', '질문과 답변을 모두 입력해주세요', InfoBarSeverity.warning);
                  } else {
                    final faq = FAQ(
                      question: questionTextController.text,
                      answer: answerTextController.text,
                      createdAt: widget.faq == null
                          ? DateTime.now().toString()
                          : widget.faq!.createdAt,
                      writer: '관리자',
                      state: '등록',
                    );
                    final isUpdate = widget.faq != null;
                    AnnouncementService().saveFAQ(faq).then((value) async {
                      await showDialog(
                          context: context,
                          builder: (context) => ContentDialog(
                                title: const Text('업데이트 알림을 전송하시겠습니까?'),
                                actions: [
                                  Button(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('닫기')),
                                  Button(
                                      onPressed: () {
                                        AnnouncementService().pushFCM(isUpdate);
                                        Navigator.pop(context);
                                      },
                                      child: const Text('전송'))
                                ],
                              ));
                      showInfoBar(
                          '등록 완료', '등록 완료되었습니다.', InfoBarSeverity.success);
                      Navigator.pop(context);
                    }).onError((error, stackTrace) {
                      showInfoBar(
                          '등록 실패', '등록에 실패했습니다.', InfoBarSeverity.error);
                    }).whenComplete(() {
                      questionTextController.clear();
                      answerTextController.clear();
                    });
                  }
                },
                child: Container(
                  margin: const EdgeInsets.only(top: 10),
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

  showInfoBar(
      String title, String content, InfoBarSeverity infoBarSeverity) async {
    await displayInfoBar(context, builder: (context, close) {
      return InfoBar(
        title: Text(title),
        content: Text(content),
        action: IconButton(
          icon: const Icon(FluentIcons.clear),
          onPressed: close,
        ),
        severity: infoBarSeverity,
      );
    });
  }
}
