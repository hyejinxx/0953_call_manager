import 'package:call_0953_manager/scenario/main/user/user_mileage_list_screen.dart';
import 'package:call_0953_manager/service/mileage_service.dart';
import 'package:call_0953_manager/service/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../model/user.dart';

class UserManageScreen extends ConsumerStatefulWidget {
  const UserManageScreen({super.key});

  @override
  _UserManageScreenState createState() => _UserManageScreenState();
}

class _UserManageScreenState extends ConsumerState<UserManageScreen> {
  final phoneTextController = TextEditingController();

  @override
  void initState() {
    phoneTextController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  final indexProvider = StateProvider<int>((ref) => 0);
  final FutureProvider userListProvider =
  FutureProvider((ref) => UserService().getAllUser());

  @override
  Widget build(BuildContext context) {
    final index = ref.watch(indexProvider);
    final userList = ref.watch(userListProvider);
    return Container(
        width: MediaQuery
            .of(context)
            .size
            .width,
        height: MediaQuery
            .of(context)
            .size
            .height,
        child: Column(children: [
          FutureBuilder(
              future: MileageService().getRequireMileage(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(
                      '총 마일리지: ${snapshot.data![0]}  보유 필요 마일리지: ${snapshot
                          .data![1]} 유저 수: ${snapshot.data![2]}');
                } else {
                  return const Text('보유 필요 금액: 0');
                }
              }),
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
              child: userList.when(
                data: (data) {
                  if (data.isEmpty) {
                    return const Center(
                      child: Text('검색 결과가 없습니다.'),
                    );
                  } else {
                     // List<User> list = data
                     //    .where((element) =>
                     //    element.call.contains(phoneTextController.text))
                     //    .toList() ;

                     List<User> list = data;


                    if (index == 0) {
                      list.sort((a, b) => a.call.compareTo(b.call));
                    } else if (index == 1) {
                      list.sort((a, b) => a.name.compareTo(b.name));
                    } else if (index == 2) {
                      list                          .sort((a, b) =>
                      a.mileage ?? 0.compareTo(b.mileage ?? 0));
                    } else if (index == 3) {
                      list.sort((a, b) => a.createdAt.compareTo(b.createdAt));
                    }  else {
                      list.sort((a, b) => a.createdAt.compareTo(b.createdAt));
                    }

                    return SfDataGrid(
                        source: UserDataSource(userData: list),
                        columnWidthMode: ColumnWidthMode.fill,
                        onCellTap: (value) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      UserMileageRecordScreen(
                                        user: list[
                                        value.rowColumnIndex.rowIndex - 1]
                                            .call,
                                      )));
                        },
                        onCellDoubleTap: (details) {
                          if (details.rowColumnIndex.rowIndex == 0) {
                            ref
                                .read(indexProvider.notifier)
                                .state =
                                details.rowColumnIndex.columnIndex;
                          }
                        },
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
                          GridColumn(
                              columnName: 'storeCall',
                              label: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  alignment: Alignment.center,
                                  child: const Text(
                                    '가맹점 번호',
                                    overflow: TextOverflow.ellipsis,
                                  ))),
                        ]);
                  }
                },
                error: (e, st) => Text('error'),
                loading: () =>
                const Center(
                  child: CircularProgressIndicator(),
                ),
              ))
        ]));
  }
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
              DataGridCell<String>(
                  columnName: 'storeCall', value: e.storeCall ?? ''),
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
