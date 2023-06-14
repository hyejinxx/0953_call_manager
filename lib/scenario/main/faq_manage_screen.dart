import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FAQManageScreen extends ConsumerStatefulWidget {
  const FAQManageScreen({Key? key}) : super(key: key);

  @override
  FAQManageScreenState createState() => FAQManageScreenState();
}

class FAQManageScreenState extends ConsumerState<FAQManageScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  final pageProvider = StateProvider<int>((ref) => 0);

  @override
  void initState() {
    // TODO: implement initState
    _pageController.addListener(() {
      ref.read(pageProvider.notifier).state =
          _pageController.page?.round() ?? 0;
    });

    super.initState();
  }

  final page = [
    const FAQPage(),
    const AnnouncementPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('FAQ 관리'),
        ),
        body: Column(
          children: [
            const TabBar(tabs: [
              Tab(text: 'FAQ'),
              Tab(text: '공지사항'),
            ]),
            Expanded(
              child: PageView(
                controller: _pageController,
                children: page,
              ),
            ),
          ],
        ));
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
    return const Placeholder();
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
    return const Placeholder();
  }
}
