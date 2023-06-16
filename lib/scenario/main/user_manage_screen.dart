import 'package:call_0953_manager/service/user_service.dart';
import 'package:flutter/material.dart';

class UserManageScreen extends StatefulWidget {
  const UserManageScreen({super.key});

  @override
  State<UserManageScreen> createState() => _UserManageScreenState();
}

class _UserManageScreenState extends State<UserManageScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: FutureBuilder(
        future: UserService().getAllUser(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print(snapshot.data);
            return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (context, index) {
                return ExpansionTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(snapshot.data![index].name),
                      Text('${snapshot.data![index].call}')
                    ],
                  ),
                  // subtitle: Text(snapshot.data![index].date
                  //     .toString()
                  //     .replaceAll('-', '/')),
                  expandedAlignment: Alignment.topLeft,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20, bottom: 10),
                      child: Text(
                          '전화번호 : ${snapshot.data![index].call}\n닉네임 : ${snapshot.data![index].name}\n가입일 : ${snapshot.data![index].createdAt.toString()}\n마일리지: ${snapshot.data![index].mileage}',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500, height: 1.5  )
                      ),
                    )
                  ],
                );
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}