import 'package:call_0953_manager/model/announcement.dart';
import 'package:call_0953_manager/model/faq.dart';
import 'package:call_0953_manager/scenario/main/faq/new_ann_screen.dart';
import 'package:call_0953_manager/scenario/main/faq/new_faq_screen.dart';
import 'package:call_0953_manager/service/announcement_service.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as ma;
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FAQManageScreen extends ConsumerStatefulWidget {
  const FAQManageScreen({Key? key}) : super(key: key);

  @override
  FAQManageScreenState createState() => FAQManageScreenState();
}

class FAQManageScreenState extends ConsumerState<FAQManageScreen> {
  @override
  void initState() {
    super.initState();
  }

  final tabIndexProvider = StateProvider<int>((ref) => 0);

  @override
  Widget build(BuildContext context) {
    final tabIndex = ref.watch(tabIndexProvider);
    return TabView(
        currentIndex: tabIndex,
        tabs: [
          Tab(
            text: const Text('공지사항'),
            body: const AnnouncementPage(),
          ),
          Tab(
            text: const Text('FAQ'),
            body: const FAQPage(),
          ),
          Tab(
            text: const Text('User FAQ'),
            body: const NewFAQPage(),
          ),
        ],
        onChanged: (index) {
          ref.read(tabIndexProvider.notifier).state = index;
        });
  }
}

class FAQPage extends StatefulWidget {
  const FAQPage({Key? key}) : super(key: key);

  @override
  State<FAQPage> createState() => _FAQPageState();
}

class _FAQPageState extends State<FAQPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: FutureBuilder(
              future: AnnouncementService().getFAQ(),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data != null && snapshot.data!.isNotEmpty) {
                  var list = snapshot.data as List<FAQ>;
                  list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
                  list = list.reversed.toList();
                  return ListView.separated(
                    itemBuilder: (context, index) {
                      return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                ma.MaterialPageRoute(
                                    builder: (context) => NewFaQScreen(
                                          faq: list[index],
                                        )));
                          },
                          child: ListTile(
                            title: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      ma.MaterialPageRoute(
                                          builder: (context) => NewFaQScreen(
                                                faq: list[index],
                                              )));
                                },
                                child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 7),
                                    child: Text('Q${index + 1}. ${list[index].question}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                        )))),
                            trailing: Column(
                              children: [
                                FilledButton(
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return ContentDialog(content: const Text('삭제하시겠습니까?'), actions: [
                                            Button(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('취소')),
                                            Button(
                                                onPressed: () {
                                                  Navigator.pop(context, true);
                                                },
                                                child: const Text('확인'))
                                          ]);
                                        }).then((value) => {
                                          if (value == true) {AnnouncementService().deleateFAQ(list[index].createdAt).then((value) => setState(() {}))}
                                        });
                                    setState(() {});
                                  },
                                  child: const Text(
                                    '삭제',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                FilledButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        ma.MaterialPageRoute(
                                            builder: (context) => NewFaQScreen(
                                                  faq: list[index],
                                                )));
                                  },
                                  child: const Text(
                                    '수정',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                            subtitle: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: Text('A. ${list[index].answer.replaceAll('\\n', '\n').replaceAll('\\', '')}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                    ))),
                          ));
                    },
                    itemCount: list!.length,
                    separatorBuilder: (BuildContext context, int index) {
                      return const Divider();
                    },
                  );
                } else {
                  return const Center(
                    child: ProgressRing(),
                  );
                }
              }),
        ),
        Row(
          children: [
            GestureDetector(
                onTap: () {
                  Navigator.push(context, ma.MaterialPageRoute(builder: (context) => NewFaQScreen()));
                },
                child: Container(
                  color: Colors.yellow.withOpacity(0.7),
                  width: MediaQuery.of(context).size.width * 0.5 - 100,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: const Text('새 FaQ 작성'),
                )),
            GestureDetector(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return ContentDialog(
                          title: const Text('알림'),
                          content: const Text('업데이트 알림을 보내시겠습니까?'),
                          actions: [
                            Button(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('취소')),
                            Button(
                                onPressed: () {
                                  AnnouncementService()
                                      .pushFCM(true)
                                      .then((value) => showInfoBar('전송 완료', '업데이트 알림을 보냈습니다.', InfoBarSeverity.info))
                                      .catchError((e) => showInfoBar('전송 실패', '업데이트 알림을 전송에 실패했습니다.', InfoBarSeverity.error));
                                  Navigator.pop(context);
                                },
                                child: const Text('확인')),
                          ],
                        );
                      });
                },
                child: Container(
                  color: Colors.blue.withOpacity(0.7),
                  width: MediaQuery.of(context).size.width * 0.5 - 100,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: const Text(
                    '업데이트 알림 보내기',
                    style: TextStyle(color: Colors.white),
                  ),
                ))
          ],
        )
      ],
    );
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

class AnnouncementPage extends StatefulWidget {
  const AnnouncementPage({Key? key}) : super(key: key);

  @override
  State<AnnouncementPage> createState() => _AnnouncementPageState();
}

class _AnnouncementPageState extends State<AnnouncementPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: FutureBuilder(
              future: AnnouncementService().getAnnouncement(),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data != null && snapshot.data!.isNotEmpty) {
                  var list = snapshot.data as List<Announcement>;
                  list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
                  list = list.reversed.toList();
                  return ListView.separated(
                    itemBuilder: (context, index) {
                      return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                ma.MaterialPageRoute(
                                    builder: (context) => NewAnnoScreen(
                                          ann: list[index],
                                        )));
                          },
                          child: ListTile(
                            title: Container(
                                padding: const EdgeInsets.symmetric(vertical: 7),
                                child: Row(children: [
                                  Text(list![index].title,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                      ))
                                ])),
                            trailing: Column(
                              children: [
                                FilledButton(
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return ContentDialog(content: const Text('삭제하시겠습니까?'), actions: [
                                            Button(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('취소')),
                                            Button(
                                                onPressed: () {
                                                  Navigator.pop(context, true);
                                                },
                                                child: const Text('확인'))
                                          ]);
                                        }).then((value) => {
                                          if (value == true) {AnnouncementService().deleateAnn(snapshot.data![index].createdAt).then((value) => setState(() {}))}
                                        });
                                    setState(() {});
                                  },
                                  child: const Text(
                                    '삭제',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                FilledButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        ma.MaterialPageRoute(
                                            builder: (context) => NewAnnoScreen(
                                                  ann: list![index],
                                                )));
                                  },
                                  child: const Text(
                                    '수정',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                            subtitle: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: Text(list![index].content.replaceAll('\\n', '\n').replaceAll('\\', ''),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                    ))),
                          ));
                    },
                    itemCount: list.length,
                    separatorBuilder: (BuildContext context, int index) {
                      return const Divider();
                    },
                  );
                } else {
                  return const Center(
                    child: ProgressRing(),
                  );
                }
              }),
        ),
        Row(
          children: [
            GestureDetector(
                onTap: () {
                  Navigator.push(context, ma.MaterialPageRoute(builder: (context) => NewAnnoScreen()));
                },
                child: Container(
                  color: Colors.yellow.withOpacity(0.7),
                  width: (MediaQuery.of(context).size.width - 200) / 3,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: const Text('새 공지 작성'),
                )),
            GestureDetector(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return ContentDialog(
                          title: const Text('알림'),
                          content: const Text('업데이트 알림을 보내시겠습니까?'),
                          actions: [
                            Button(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('취소')),
                            Button(
                                onPressed: () {
                                  AnnouncementService()
                                      .pushFCM(true)
                                      .then((value) => showInfoBar('전송 완료', '업데이트 알림을 보냈습니다.', InfoBarSeverity.info))
                                      .catchError((e) => showInfoBar('전송 실패', '업데이트 알림을 전송에 실패했습니다.', InfoBarSeverity.error));
                                  Navigator.pop(context);
                                },
                                child: const Text('확인')),
                          ],
                        );
                      });
                },
                child: Container(
                    color: Colors.blue.withOpacity(0.9),
                    width: (MediaQuery.of(context).size.width - 200) / 3,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: const Text(
                      '업데이트 알림 보내기',
                      style: TextStyle(color: Colors.white),
                    ))),
            FutureBuilder(
                future: AnnouncementService().getPopUpAnnouncement(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return GestureDetector(
                        onTap: () {
                          Navigator.push(context, ma.MaterialPageRoute(builder: (context) => PopUpScreen(text: snapshot.data!)));
                        },
                        child: Container(
                          color: Colors.grey.withOpacity(0.3),
                          width: (MediaQuery.of(context).size.width - 200) / 3,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: const Text('팝업 공지사항 수정'),
                        ));
                  } else {
                    return Container();
                  }
                }),
          ],
        )
      ],
    );
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

class NewFAQPage extends StatefulWidget {
  const NewFAQPage({Key? key}) : super(key: key);

  @override
  State<NewFAQPage> createState() => NewFAQPageState();
}

class NewFAQPageState extends State<NewFAQPage> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Expanded(
          child: FutureBuilder(
              future: AnnouncementService().getNewFAQ(),
              builder: (context, snapshot) {
                return snapshot.hasData
                    ? ListView.separated(
                        itemBuilder: (context, index) {
                          return GestureDetector(
                              onTap: () {
                                ma.showBottomSheet(
                                    context: context,
                                    builder: (context) => AnswerScreen(
                                          faq: snapshot.data![index],
                                        ));
                              },
                              child: ListTile(
                                title: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 7),
                                    child: Text('Q${index + 1}. ${snapshot.data![index].question}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                        ))),
                                subtitle: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10),
                                    child: Text(
                                        snapshot.data![index].answer == '' ? '아직 답변을 하지 않았습니다' : 'A. ${snapshot.data![index].answer.replaceAll('\\n', '\n').replaceAll('\\', '')}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                        ))),
                                trailing: IconButton(
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return ContentDialog(content: const Text('삭제하시겠습니까?'), actions: [
                                              Button(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text('취소')),
                                              Button(
                                                  onPressed: () {
                                                    Navigator.pop(context, true);
                                                  },
                                                  child: const Text('확인'))
                                            ]);
                                          }).then((value) => {
                                            if (value == true) {AnnouncementService().deleteNewFAQ(snapshot.data![index]).then((value) => setState(() {}))}
                                          });
                                      setState(() {});
                                    },
                                    icon: const Icon(FluentIcons.delete)),
                              ));
                        },
                        itemCount: snapshot.data!.length,
                        separatorBuilder: (BuildContext context, int index) {
                          return const Divider();
                        },
                      )
                    : const Center(
                        child: ProgressRing(),
                      );
              })),
      GestureDetector(
          onTap: () {},
          child: Container(
            color: Colors.yellow.withOpacity(0.7),
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: const Text('새 FaQ 작성'),
          ))
    ]);
  }
}

class PopUpScreen extends StatefulWidget {
  const PopUpScreen({super.key, required this.text});

  final String text;

  @override
  State<PopUpScreen> createState() => _PopUpScreenState();
}

class _PopUpScreenState extends State<PopUpScreen> {
  final contentController = TextEditingController();

  @override
  void initState() {
    contentController.text = widget.text;
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.max, children: [
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(FluentIcons.back)),
          Expanded(
              child: Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white),
            child: TextFormBox(
              controller: contentController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(10),
              ),
              maxLength: 10000,
              style: const TextStyle(
                fontSize: 14.0,
              ),
              placeholder: '공지사항을 적어주세요',
            ),
          )),
          GestureDetector(
              onTap: () {
                if (contentController.text.isEmpty) {
                  showInfoBar('입력 오류', '내용을 입력해주세요', InfoBarSeverity.warning);
                  return;
                }

                AnnouncementService().savePopUpAnnouncement(contentController.text).then((value) {
                  showInfoBar('등록 완료', '등록가 완료되었습니다.', InfoBarSeverity.warning);

                  Navigator.pop(context);
                }).onError((error, stackTrace) {
                  showInfoBar('오류', '오류가 발생했습니다', InfoBarSeverity.error);
                });
              },
              child: Container(
                margin: const EdgeInsets.only(top: 10),
                color: Colors.yellow.withOpacity(0.7),
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: const Text('등록하기', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 16.0)),
              ))
        ]));
  }
}

class AnswerScreen extends StatefulWidget {
  const AnswerScreen({super.key, required this.faq});

  final FAQ faq;

  @override
  State<AnswerScreen> createState() => AnswerScreenState();
}

class AnswerScreenState extends State<AnswerScreen> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(height: 10),
            Text(widget.faq.question,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                )),
            const SizedBox(height: 10),
            Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: TextFormBox(
                  controller: controller,
                  maxLines: 10,
                  placeholder: '답변을 입력해주세요',
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.grey[200]),
                )),
            GestureDetector(
                onTap: () {
                  widget.faq.answer = controller.text;
                  AnnouncementService().saveAnswerFAQ(widget.faq).then((value) async {
                    AnnouncementService().pushAnswer(widget.faq.writer);
                    await displayInfoBar(context, builder: (context, close) {
                      return InfoBar(
                        title: const Text('등록 완료'),
                        content: const Text('답변 등록이 완료되었습니다'),
                        action: IconButton(
                          icon: const Icon(FluentIcons.clear),
                          onPressed: close,
                        ),
                        severity: InfoBarSeverity.success,
                      );
                    });
                  });
                  Navigator.pop(context);
                },
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    color: Colors.yellow,
                    height: 60,
                    alignment: Alignment.center,
                    child: const Text(
                      '답변하기',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    )))
          ],
        ));
  }
}
