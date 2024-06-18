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
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) => ContentDialog(
                                title: const Text('이전 화면으로 이동하시겠습니까?', style: TextStyle(fontSize: 20)),
                                actions: [
                                  Button(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('닫기')),
                                  Button(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                      },
                                      child: const Text('이동'))
                                ],
                              ));
                    },
                    icon: const Icon(FluentIcons.back, size: 20)),
                const SizedBox(width: 10),
                IconButton(
                    icon: const Icon(
                      FluentIcons.accept,
                      size: 25,
                    ),
                    onPressed: () {
                      if (questionTextController.text.isEmpty || answerTextController.text.isEmpty) {
                        showInfoBar('입력 오류', '질문과 답변을 모두 입력해주세요', InfoBarSeverity.warning);
                      } else {
                        final faq = FAQ(
                          question: questionTextController.text,
                          answer: answerTextController.text,
                          createdAt: widget.faq == null ? DateTime.now().toString() : widget.faq!.createdAt,
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
                                      Button(onPressed: () => Navigator.pop(context), child: const Text('닫기')),
                                      Button(
                                          onPressed: () {
                                            AnnouncementService().pushFCM(isUpdate);
                                            Navigator.pop(context);
                                          },
                                          child: const Text('전송'))
                                    ],
                                  ));
                          showInfoBar('등록 완료', '등록 완료되었습니다.', InfoBarSeverity.success);
                          Navigator.pop(context);
                        }).onError((error, stackTrace) {
                          showInfoBar('등록 실패', '등록에 실패했습니다.', InfoBarSeverity.error);
                        }).whenComplete(() {
                          questionTextController.clear();
                          answerTextController.clear();
                        });
                      }
                    }),
              ],
            ),
            const SizedBox(height: 10),
            InfoLabel(
              label: '질문',
              child: TextBox(
                placeholder: '질문 입력',
                expands: false,
                controller: questionTextController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                maxLength: 10000,
              ),
            ),
            const SizedBox(height: 10),
            InfoLabel(
              label: '답변',
              child: TextBox(
                placeholder: '답변 입력',
                expands: true,
                controller: answerTextController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                maxLength: 10000,
              ),
            ),
          ],
        ));
  }

  showInfoBar(String title, String content, InfoBarSeverity infoBarSeverity) async {
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
