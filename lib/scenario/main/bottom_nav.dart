import 'package:call_0953_manager/scenario/main/account_manage_screen.dart';
import 'package:call_0953_manager/scenario/main/mileage_manage_screen.dart';
import 'package:call_0953_manager/scenario/main/update_call.dart';
import 'package:call_0953_manager/scenario/main/user_manage_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../style/style.dart';
import 'faq_manage_screen.dart';

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
      const FAQManageScreen(),
      const UpdateCallScreen(),
    ];

    return Scaffold(
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
                label: '회원관리'),
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
                label: '출금'),
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
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.chat,
                  color: Palette.bottomUnselectedColor,
                ),
                activeIcon: Icon(
                  Icons.chat,
                  color: Palette.bottomSelectedColor,
                ),
                label: '콜 저장'),
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
