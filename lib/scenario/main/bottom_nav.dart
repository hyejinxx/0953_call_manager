import 'package:call_0953_manager/scenario/main/call/call_manage_screen.dart';
import 'package:call_0953_manager/scenario/main/mileage/mileage_manage_screen.dart';
import 'package:call_0953_manager/scenario/main/withdraw/withdraw_manage_screen.dart';
import 'package:call_0953_manager/scenario/start/update_call_screen.dart';
import 'package:call_0953_manager/scenario/main/user/user_manage_screen.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../service/mileage_service.dart';
import 'faq/faq_manage_screen.dart';

//
// import '../../style/style.dart';
// import 'faq/faq_manage_screen.dart';
//
// final bottomNavProvider = StateProvider<int>((ref) => 0);
//
// class BottomNavigation extends ConsumerStatefulWidget {
//   const BottomNavigation({Key? key}) : super(key: key);
//
//   @override
//   BottomNavigationState createState() => BottomNavigationState();
// }
//
// class BottomNavigationState extends ConsumerState<BottomNavigation> {
//   @override
//   Widget build(BuildContext context) {
//     final currentPage = ref.watch(bottomNavProvider);
//     final List<dynamic> screen = [
//       const UserManageScreen(),
//       const MileageManageScreen(),
//       const WithdrawManageScreen(),
//       const CallManageScreen(),
//       const FAQManageScreen(),
//     ];
//     final List<String> screenTitle = [
//       '유저 목록',
//       '마일리지 관리',
//       '출금 내역 관리',
//       '대리 기록 관리',
//       'FAQ 관리',
//     ];
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(screenTitle[currentPage],
//             style: TextStyle(color: Colors.black), textAlign: TextAlign.center),
//         backgroundColor: Colors.transparent,
//         centerTitle: true,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios),
//           color: Colors.black,
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//         bottom: PreferredSize(
//           preferredSize: const Size.fromHeight(0),
//           child: Container(
//             color: Colors.grey[300],
//             height: 1,
//           ),
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.logout),
//             onPressed: () {
//               Navigator.pushReplacement(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => const UpdateCallScreen()));
//             },
//           )
//         ],
//       ),
//       body: SafeArea(child: screen.elementAt(currentPage)),
//       bottomNavigationBar: BottomNavigationBar(
//           type: BottomNavigationBarType.fixed,
//           backgroundColor: Colors.white,
//           items: const <BottomNavigationBarItem>[
//             BottomNavigationBarItem(
//                 icon: Icon(
//                   Icons.person,
//                   color: Palette.bottomUnselectedColor,
//                 ),
//                 activeIcon: Icon(
//                   Icons.person,
//                   color: Palette.bottomSelectedColor,
//                 ),
//                 label: '유저 목록'),
//             BottomNavigationBarItem(
//                 icon: Icon(
//                   Icons.account_circle_rounded,
//                   color: Palette.bottomUnselectedColor,
//                 ),
//                 activeIcon: Icon(
//                   Icons.class_rounded,
//                   color: Palette.bottomSelectedColor,
//                   //
//                 ),
//                 label: '마일리지'),
//             BottomNavigationBarItem(
//                 icon: Icon(
//                   Icons.article_rounded,
//                   color: Palette.bottomUnselectedColor,
//                 ),
//                 activeIcon: Icon(
//                   Icons.article_rounded,
//                   color: Palette.bottomSelectedColor,
//                 ),
//                 label: '출금 신청'),
//             BottomNavigationBarItem(
//                 icon: Icon(
//                   Icons.chat,
//                   color: Palette.bottomUnselectedColor,
//                 ),
//                 activeIcon: Icon(
//                   Icons.chat,
//                   color: Palette.bottomSelectedColor,
//                 ),
//                 label: '콜 내역'),
//             BottomNavigationBarItem(
//                 icon: Icon(
//                   Icons.chat,
//                   color: Palette.bottomUnselectedColor,
//                 ),
//                 activeIcon: Icon(
//                   Icons.chat,
//                   color: Palette.bottomSelectedColor,
//                 ),
//                 label: '공지사항'),
//           ],
//           currentIndex: currentPage,
//           selectedItemColor: Palette.bottomSelectedColor,
//           unselectedItemColor: Palette.bottomUnselectedColor,
//           onTap: (index) {
//             ref.read(bottomNavProvider.notifier).state = index;
//           }),
//     );
//   }
// }

final navProvider = StateProvider<int>((ref) => 0);

class WindowView extends ConsumerStatefulWidget {
  const WindowView({super.key});

  @override
  _WindowViewState createState() => _WindowViewState();
}

class _WindowViewState extends ConsumerState<WindowView> {
  final List<dynamic> screen = [
    const UserManageScreen(),
    const MileageManageScreen(),
    const WithdrawManageScreen(),
    const CallManageScreen(),
    const FAQManageScreen(),
    const UpdateCallScreen(),
  ];
  final List<String> screenTitle = ['유저 목록', '마일리지 관리', '출금 내역 관리', '대리 기록 관리', '공지사항', '콜 업데이트'];

  @override
  Widget build(BuildContext context) {
    final currentPage = ref.watch(navProvider);
    return NavigationView(
      appBar: NavigationAppBar(
        leading: Container(
          child: Image(
            image: AssetImage('assets/image/0953_2.png'),
          ),
        ),
        title: Row(children: [
          const Text('해피해피 0953', style: TextStyle(color: Colors.black), textAlign: TextAlign.center),
          const SizedBox(
            width: 10,
          ),
          FutureBuilder(
              future: MileageService().getRequireMileage(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(
                    '유저가 보유한 총 마일리지: ${snapshot.data![0]}  관리자 보유 필요 마일리지: ${snapshot.data![1]}  총 유저 수: ${snapshot.data![2]}',
                    style: const TextStyle(fontSize: 12),
                  );
                } else {
                  return const Text('로딩중...');
                }
              }),
        ]),
      ),
      pane: NavigationPane(
        size: const NavigationPaneSize(
          compactWidth: 56.0,
          openMaxWidth: 200.0,
        ),
        displayMode: PaneDisplayMode.auto,
        items: <NavigationPaneItem>[
          PaneItem(icon: const Icon(FluentIcons.account_management), title: Text(screenTitle.elementAt(0)), body: screen.elementAt(0)),
          PaneItem(icon: const Icon(FluentIcons.folder_list), title: Text(screenTitle.elementAt(1)), body: screen.elementAt(1)),
          PaneItem(icon: const Icon(FluentIcons.bill), title: Text(screenTitle.elementAt(2)), body: screen.elementAt(2)),
          PaneItem(icon: const Icon(FluentIcons.phone), title: Text(screenTitle.elementAt(3)), body: screen.elementAt(3)),
          PaneItem(icon: const Icon(FluentIcons.post_update), title: Text(screenTitle.elementAt(4)), body: screen.elementAt(4)),
          PaneItem(icon: const Icon(FluentIcons.phone), title: Text(screenTitle.elementAt(5)), body: screen.elementAt(5)),
        ],
        selected: currentPage,
        onChanged: (i) => ref.read(navProvider.notifier).state = i,
      ),
    );
  }
}
