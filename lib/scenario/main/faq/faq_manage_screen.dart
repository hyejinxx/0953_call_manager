import 'package:call_0953_manager/model/faq.dart';
import 'package:call_0953_manager/scenario/main/faq/new_ann_screen.dart';
import 'package:call_0953_manager/scenario/main/faq/new_faq_screen.dart';
import 'package:call_0953_manager/service/announcement_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FAQManageScreen extends ConsumerStatefulWidget {
  const FAQManageScreen({Key? key}) : super(key: key);

  @override
  FAQManageScreenState createState() => FAQManageScreenState();
}

class FAQManageScreenState extends ConsumerState<FAQManageScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  final tab = [const AnnouncementPage(), const FAQPage(), const NewFAQPage()];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(controller: _tabController, tabs: [
          Container(
            height: 80,
            alignment: Alignment.center,
            child: const Text(
              '공지사항',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
          Container(
            height: 80,
            alignment: Alignment.center,
            child: const Text(
              'FAQ',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
          Container(
            height: 80,
            alignment: Alignment.center,
            child: const Text(
              'User FAQ',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
        ]),
        Expanded(child: TabBarView(controller: _tabController, children: tab))
      ],
    );
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
                return snapshot.hasData
                    ? ListView.separated(
                        itemBuilder: (context, index) {
                          return InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => NewFaQScreen(
                                              faq: snapshot.data![index],
                                            )));
                              },
                              child: ListTile(
                                title: Container(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 7),
                                    child: Text(
                                        'Q${index + 1}. ${snapshot.data![index].question}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                        ))),
                                trailing: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.yellow,
                                  ),
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                              content: Text('삭제하시겠습니까?'),
                                              actions: [
                                                TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text('취소')),
                                                TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(
                                                          context, true);
                                                    },
                                                    child: const Text('확인'))
                                              ]);
                                        }).then((value) => {
                                          if (value == true)
                                            {
                                              AnnouncementService()
                                                  .deleateFAQ(snapshot
                                                      .data![index].createdAt)
                                                  .then((value) =>
                                                      setState(() {}))
                                            }
                                        });
                                    setState(() {});
                                  },
                                  child: Text(
                                    '삭제',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                                subtitle: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Text(
                                        'A. ${snapshot.data![index].answer.replaceAll('\\n', '\n').replaceAll('\\', '')}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black54,
                                          fontWeight: FontWeight.w500,
                                        ))),
                              ));
                        },
                        itemCount: snapshot.data!.length,
                        separatorBuilder: (BuildContext context, int index) {
                          return const Divider();
                        },
                      )
                    : const Center(
                        child: CircularProgressIndicator(),
                      );
              }),
        ),
        Row(children: [
          InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => NewFaQScreen()));
              },
              child: Container(
                color: Colors.yellow.withOpacity(0.7),
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: const Text('새 FaQ 작성'),
              )),
          InkWell(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('알림'),
                        content: const Text('업데이트 알림을 보내시겠습니까?'),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('취소')),
                          TextButton(
                              onPressed: () {
                                AnnouncementService()
                                    .pushFCM(true)
                                    .then((value) =>
                                    showToast('업데이트 알림을 보냈습니다.'))
                                    .catchError((e) =>
                                    showToast('업데이트 알림을 보내는데 실패했습니다.'));
                                Navigator.pop(context);
                              },
                              child: const Text('확인')),
                        ],
                      );
                    });
              },
              child: Container(
                color: Colors.blue.withOpacity(0.7),
                width: MediaQuery.of(context).size.width * 0.5,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: const Text('업데이트 알림 보내기', style: TextStyle(color: Colors.white),),
              ))
        ],)


      ],
    );
  }
  showToast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
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
        FutureBuilder(
            future: AnnouncementService().getPopUpAnnouncement(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PopUpScreen(text: snapshot.data!)));
                    },
                    child: Container(
                      color: Colors.grey.withOpacity(0.7),
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Text('팝업 공지사항 수정'),
                    ));
              } else {
                return Container();
              }
            }),
        Expanded(
          child: FutureBuilder(
              future: AnnouncementService().getAnnouncement(),
              builder: (context, snapshot) {
                return snapshot.hasData
                    ? ListView.separated(
                        itemBuilder: (context, index) {
                          return InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => NewAnnoScreen(
                                              ann: snapshot.data![index],
                                            )));
                              },
                              child: ListTile(
                                title: Container(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 7),
                                    child: Row(children: [
                                      const Icon(Icons.arrow_right,
                                          size: 20, color: Colors.black),
                                      Text(snapshot.data![index].title,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600,
                                          ))
                                    ])),
                                trailing: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.yellow,
                                  ),
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                              content: Text('삭제하시겠습니까?'),
                                              actions: [
                                                TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text('취소')),
                                                TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(
                                                          context, true);
                                                    },
                                                    child: const Text('확인'))
                                              ]);
                                        }).then((value) => {
                                          if (value == true)
                                            {
                                              AnnouncementService()
                                                  .deleateAnn(snapshot
                                                      .data![index].createdAt)
                                                  .then((value) =>
                                                      setState(() {}))
                                            }
                                        });
                                    setState(() {});
                                  },
                                  child: Text(
                                    '삭제',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                                subtitle: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Text(
                                        snapshot.data![index].content
                                            .replaceAll('\\n', '\n')
                                            .replaceAll('\\', ''),
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black54,
                                          fontWeight: FontWeight.w500,
                                        ))),
                              ));
                        },
                        itemCount: snapshot.data!.length,
                        separatorBuilder: (BuildContext context, int index) {
                          return const Divider();
                        },
                      )
                    : const Center(
                        child: CircularProgressIndicator(),
                      );
              }),
        ),
        Row(
          children: [
            InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => NewAnnoScreen()));
                },
                child: Container(
                  color: Colors.yellow.withOpacity(0.7),
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: const Text('새 공지 작성'),
                )),
            InkWell(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('알림'),
                          content: const Text('업데이트 알림을 보내시겠습니까?'),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('취소')),
                            TextButton(
                                onPressed: () {
                                  AnnouncementService()
                                      .pushFCM(true)
                                      .then((value) =>
                                      showToast('업데이트 알림을 보냈습니다.'))
                                      .catchError((e) =>
                                      showToast('업데이트 알림을 보내는데 실패했습니다.'));
                                  Navigator.pop(context);
                                },
                                child: const Text('확인')),
                          ],
                        );
                      });
                },
                child: Container(
                    color: Colors.blue.withOpacity(0.9),
                    width: MediaQuery.of(context).size.width * 0.5,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: const Text(
                      '업데이트 알림 보내기',
                      style: TextStyle(color: Colors.white),
                    )))
          ],
        )

      ],
    );
  }
  showToast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
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
                          return InkWell(
                              onTap: () {
                                showModalBottomSheet(
                                    context: context,
                                    builder: (context) => AnswerScreen(
                                          faq: snapshot.data![index],
                                        ));
                              },
                              child: ListTile(
                                title: Container(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 7),
                                    child: Text(
                                        'Q${index + 1}. ${snapshot.data![index].question}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                        ))),
                                subtitle: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Text(
                                        snapshot.data![index].answer == ''
                                            ? '아직 답변을 하지 않았습니다'
                                            : 'A. ${snapshot.data![index].answer.replaceAll('\\n', '\n').replaceAll('\\', '')}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black54,
                                          fontWeight: FontWeight.w500,
                                        ))),
                                trailing: IconButton(
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                                content: Text('삭제하시겠습니까?'),
                                                actions: [
                                                  TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: const Text('취소')),
                                                  TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(
                                                            context, true);
                                                      },
                                                      child: const Text('확인'))
                                                ]);
                                          }).then((value) => {
                                            if (value == true)
                                              {
                                                AnnouncementService()
                                                    .deleteNewFAQ(
                                                        snapshot.data![index])
                                                    .then((value) =>
                                                        setState(() {}))
                                              }
                                          });
                                      setState(() {});
                                    },
                                    icon: const Icon(Icons.delete)),
                              ));
                        },
                        itemCount: snapshot.data!.length,
                        separatorBuilder: (BuildContext context, int index) {
                          return const Divider();
                        },
                      )
                    : const Center(
                        child: CircularProgressIndicator(),
                      );
              }))
    ]);

    // InkWell(
    //     onTap: () {
    //
    //     },
    //     child: Container(
    //       color: Colors.yellow.withOpacity(0.7),
    //       width: MediaQuery.of(context).size.width,
    //       alignment: Alignment.center,
    //       padding: const EdgeInsets.symmetric(vertical: 16),
    //       child: const Text('새 FaQ 작성'),
    //     ))
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: const Text('팝업 공지사항 수정', style: TextStyle(color: Colors.black)),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: Colors.white,
        ),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey[200]),
                    child: TextField(
                        controller: contentController,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        maxLength: 10000,
                        style: const TextStyle(
                          fontSize: 14.0,
                        ),
                        decoration: InputDecoration(
                          focusedBorder:
                          const UnderlineInputBorder(borderSide: BorderSide.none),
                          contentPadding: const EdgeInsets.all(16),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          hintText: '공지사항을 적어주세요',
                          hintStyle: TextStyle(
                            color: Colors.black.withOpacity(0.7),
                            fontSize: 14.0,
                          ),
                        )),
                  )),
              GestureDetector(
                  onTap: () {
                    if (
                        contentController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('내용을 입력해주세요')));
                      return;
                    }

                    AnnouncementService()
                        .savePopUpAnnouncement(contentController.text)
                        .then((value) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text('등록되었습니다')));
                      Navigator.pop(context);
                    }).onError((error, stackTrace) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text('등록에 실패했습니다')));
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(top: 10),
                    color: Colors.yellow.withOpacity(0.7),
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Text('등록하기',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 16.0)),
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
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const SizedBox(height: 20),
        Text(widget.faq.question,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.w600,
            )),
        const SizedBox(height: 20),
        Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: TextField(
                controller: controller,
                maxLines: 10,
                decoration: const InputDecoration(
                    hintText: '답변을 입력해주세요',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey))))),
        InkWell(
            onTap: () {
              widget.faq.answer = controller.text;
              AnnouncementService().saveAnswerFAQ(widget.faq).then((value) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(const SnackBar(content: Text('답변이 저장되었습니다')));
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
    );
  }
}
