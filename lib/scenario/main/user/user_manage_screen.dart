import 'package:call_0953_manager/scenario/main/user/user_mileage_list_screen.dart';
import 'package:call_0953_manager/service/user_service.dart';
import 'package:flutter/material.dart';

class UserManageScreen extends StatefulWidget {
  const UserManageScreen({super.key});

  @override
  State<UserManageScreen> createState() => _UserManageScreenState();
}

class _UserManageScreenState extends State<UserManageScreen> {
  final phoneTextController = TextEditingController();

  @override
  void initState() {
    phoneTextController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: TextField(
              controller: phoneTextController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: '검색할 유저의 번호를 입력하세요',
              ),
              obscureText: false,
            ),
          ),
          Expanded(
              child: FutureBuilder(
            future: UserService().getAllUser(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                print(snapshot.data);
                final userList = snapshot.data!
                    .where((element) =>
                        element.call.contains(phoneTextController.text))
                    .toList();
                if (userList.isEmpty) {
                  return const Center(
                    child: Text('검색 결과가 없습니다.'),
                  );
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data?.length,
                    itemBuilder: (context, index) {
                      return ExpansionTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(userList[index].name),
                            Text(userList[index].call)
                          ],
                        ),
                        expandedAlignment: Alignment.topLeft,
                        children: [
                          Padding(
                              padding: const EdgeInsets.only(
                                  left: 20, bottom: 10, right: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(
                                      '전화번호 : ${userList[index].call}\n닉네임 : ${userList[index].name}\n가입일 : ${userList[index].createdAt.toString().substring(0, 11)}\n마일리지: ${userList[index].mileage}',
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          height: 1.5)),
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                UserMileageRecordScreen(
                                                    user: userList[index].call),
                                          ));
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          border:
                                              Border.all(color: Colors.black)),
                                      child: const Text('마일리지 내역'),
                                    ),
                                  )
                                ],
                              ))
                        ],
                      );
                    },
                  );
                }
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          )),
        ]));
  }
}
