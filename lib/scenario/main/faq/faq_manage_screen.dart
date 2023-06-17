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
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  final tab = [
    const AnnouncementPage(),
    const FAQPage(),

  ];

  @override
  Widget build(BuildContext context) {
    return Column(
          children: [
             TabBar(
              controller: _tabController,
                tabs: [
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
            ]),
        Expanded(child:
           TabBarView(
             controller: _tabController,
               children: tab)
        )
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
    return const Center(
      child: Text('FAQ'),
    );
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
    return const Center(
      child: Text('공지사항'),
    );
  }
}
