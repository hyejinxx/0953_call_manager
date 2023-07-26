import 'package:call_0953_manager/scenario/main/user/user_mileage_list_screen.dart';
import 'package:call_0953_manager/service/mileage_service.dart';
import 'package:call_0953_manager/service/user_service.dart';
import 'package:fluent_ui/fluent_ui.dart';
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

  final FutureProvider userListProvider =
      FutureProvider((ref) => UserService().getAllUser());

  @override
  Widget build(BuildContext context) {
    final userList = ref.watch(userListProvider);
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(children: [
          FutureBuilder(
              future: MileageService().getRequireMileage(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        '유저가 보유한 총 마일리지: ${snapshot.data![0]}  관리자 보유 필요 마일리지: ${snapshot.data![1]}  총 유저 수: ${snapshot.data![2]}',
                        style: const TextStyle(fontSize: 13),
                      ));
                } else {
                  return const Text('로딩중...');
                }
              }),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: TextFormBox(
              controller: phoneTextController,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5)),
              placeholder: '전화번호 검색',
              obscureText: false,
            ),
          ),
          Expanded(
              child: userList.when(
            data: (data) {
              if (data.isEmpty) {
                return const Center(
                  child: Text('유저가 없습니다.'),
                );
              } else {
                List<User> list = data
                   .where((element) =>
                   element.call.contains(phoneTextController.text) == true)
                   .toList() ;
                return SfDataGrid(
                    source: UserDataSource(userData: list),
                    allowSorting: true,
                    columnWidthMode: ColumnWidthMode.fill,
                    sortingGestureType: SortingGestureType.doubleTap,
                    // showCheckboxColumn: true,
                    showSortNumbers: true,
                    showHorizontalScrollbar: true,
                    showVerticalScrollbar: true,
                    shrinkWrapRows: true,
                    shrinkWrapColumns: true,
                    onCellTap: (value) {
                      if (value.rowColumnIndex.rowIndex != 0) {
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => UserMileageRecordScreen(
                        //               user: list[
                        //                       value.rowColumnIndex.rowIndex - 1]
                        //                   .call,
                        //             )));
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
                          columnName: 'destination',
                          label: Container(
                              padding: const EdgeInsets.all(8.0),
                              alignment: Alignment.center,
                              child: const Text(
                                '목적지',
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
                          columnName: 'destination',
                          label: Container(
                              padding: const EdgeInsets.all(8.0),
                              alignment: Alignment.center,
                              child: const Text(
                                '주 목적지',
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
            loading: () => const Center(
              child: ProgressRing(),
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
              DataGridCell(columnName: 'destination', value: e.destination??''),
              DataGridCell<String>(
                  columnName: 'joinDate', value: e.createdAt.toString()),
              DataGridCell<String>(
                  columnName: 'destination', value: e.destination ?? ''),
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
