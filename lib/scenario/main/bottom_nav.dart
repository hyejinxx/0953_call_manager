import 'package:call_0953_manager/scenario/main/mileage/account_manage_screen.dart';
import 'package:call_0953_manager/scenario/main/call/call_manage_screen.dart';
import 'package:call_0953_manager/scenario/main/mileage/mileage_manage_screen.dart';
import 'package:call_0953_manager/scenario/start/update_call_screen.dart';
import 'package:call_0953_manager/scenario/main/user/user_manage_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../style/style.dart';
import 'faq/faq_manage_screen.dart';

final bottomNavProvider = StateProvider<int>((ref) => 0);

class BottomNavigation extends ConsumerStatefulWidget {
  const BottomNavigation({Key? key}) : super(key: key);

  @override
  BottomNavigationState createState() => BottomNavigationState();
}

class BottomNavigationState extends ConsumerState<BottomNavigation> {
  @override
  Widget build(BuildContext context) {
    final currentPage = ref.watch(bottomNavProvider);
    final List<dynamic> screen = [
      const UserManageScreen(),
      const MileageManageScreen(),
      const AccountManageScreen(),
      const CallManageScreen(),
      const FAQManageScreen(),
    ];
    final List<String> screenTitle = [
      '유저 목록',
      '마일리지 관리',
      '출금 내역 관리',
      '전화번호 관리',
      'FAQ 관리',
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(screenTitle[currentPage],
            style: TextStyle(color: Colors.black), textAlign: TextAlign.center),
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
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const UpdateCallScreen()));
            },
          )
        ],
      ),
      body: SafeArea(child: screen.elementAt(currentPage)),
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.person,
                  color: Palette.bottomUnselectedColor,
                ),
                activeIcon: Icon(
                  Icons.person,
                  color: Palette.bottomSelectedColor,
                ),
                label: '유저 목록'),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.account_circle_rounded,
                  color: Palette.bottomUnselectedColor,
                ),
                activeIcon: Icon(
                  Icons.class_rounded,
                  color: Palette.bottomSelectedColor,
                  //
                ),
                label: '마일리지'),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.article_rounded,
                  color: Palette.bottomUnselectedColor,
                ),
                activeIcon: Icon(
                  Icons.article_rounded,
                  color: Palette.bottomSelectedColor,
                ),
                label: '출금 신청'),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.chat,
                  color: Palette.bottomUnselectedColor,
                ),
                activeIcon: Icon(
                  Icons.chat,
                  color: Palette.bottomSelectedColor,
                ),
                label: '콜 내역'),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.chat,
                  color: Palette.bottomUnselectedColor,
                ),
                activeIcon: Icon(
                  Icons.chat,
                  color: Palette.bottomSelectedColor,
                ),
                label: '공지사항'),
          ],
          currentIndex: currentPage,
          selectedItemColor: Palette.bottomSelectedColor,
          unselectedItemColor: Palette.bottomUnselectedColor,
          onTap: (index) {
            ref.read(bottomNavProvider.notifier).state = index;
          }),
    );
  }
}
