import 'package:call_0953_manager/scenario/main/user/user_mileage_list_screen.dart';
import 'package:call_0953_manager/service/user_service.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../model/user.dart';

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
                  return SfDataGrid(
                      source: UserDataSource(userData: snapshot.data!),
                      columnWidthMode: ColumnWidthMode.fill,
                      columns: <GridColumn>[
                        GridColumn(
                            columnName: 'call',
                            label: Container(
                                padding: const EdgeInsets.all(8.0),
                                alignment: Alignment.center,
                                child: const Text(
                                  '전화번호',
                                  overflow: TextOverflow.ellipsis,
                                ))),
                        GridColumn(
                            columnName: 'name',
                            label: Container(
                                padding: const EdgeInsets.all(8.0),
                                alignment: Alignment.center,
                                child: const Text(
                                  '닉네임',
                                  overflow: TextOverflow.ellipsis,
                                ))),
                        GridColumn(
                            columnName: 'mileage',
                            label: Container(
                                padding: const EdgeInsets.all(8.0),
                                alignment: Alignment.center,
                                child: const Text(
                                  '마일리지',
                                  overflow: TextOverflow.ellipsis,
                                ))),
                        GridColumn(
                            columnName: 'joinDate',
                            label: Container(
                                padding: const EdgeInsets.all(8.0),
                                alignment: Alignment.center,
                                child: const Text(
                                  '가입일',
                                  overflow: TextOverflow.ellipsis,
                                ))),
                        GridColumn(
                            columnName: 'store',
                            label: Container(
                                padding: const EdgeInsets.all(8.0),
                                alignment: Alignment.center,
                                child: const Text(
                                  '가맹점',
                                  overflow: TextOverflow.ellipsis,
                                ))),
                      ]);
                }
              } else {
                return const Center(
                  child: Text('검색 결과가 없습니다.'),
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          )),
        ]));
  }

  Widget userItem(User user) => ExpansionTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [Text(user.name), Text(user.call)],
        ),
        expandedAlignment: Alignment.topLeft,
        children: [
          Padding(
              padding: const EdgeInsets.only(left: 20, bottom: 10, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                      '전화번호 : ${user.call}\n닉네임 : ${user.name}\n가입일 : ${user.createdAt.toString().substring(0, 11)}\n마일리지: ${user.mileage}',
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
                                UserMileageRecordScreen(user: user.call),
                          ));
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: Colors.black)),
                      child: const Text('마일리지 내역'),
                    ),
                  )
                ],
              ))
        ],
      );
}

class UserDataSource extends DataGridSource {
  /// Creates the employee data source class with required details.
  UserDataSource({required List<User> userData}) {
    _userData = userData
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<String>(columnName: 'call', value: e.call),
              DataGridCell<String>(columnName: 'name', value: e.name),
              DataGridCell<int>(columnName: 'mileage', value: e.mileage),
              DataGridCell<String>(
                  columnName: 'joinDate', value: e.createdAt.toString()),
              DataGridCell<String>(columnName: 'store', value: e.store ?? ''),
            ]))
        .toList();
  }

  List<DataGridRow> _userData = [];

  @override
  List<DataGridRow> get rows => _userData;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
      return Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8.0),
        child: Text(e.value.toString()),
      );
    }).toList());
  }
}
