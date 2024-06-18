import 'package:call_0953_manager/scenario/main/user/user_mileage_list_screen.dart';
import 'package:call_0953_manager/service/user_service.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as ma;
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
  final nameTextController = TextEditingController();
  final controller = DataGridController();

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
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(children: [

          SizedBox(
            height: 50,
            child: Row(children: [
              Flexible(
                flex: 1,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16),
                  child: TextFormBox(
                    controller: phoneTextController,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5)),
                    placeholder: '전화번호 검색',
                    obscureText: false,
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16),
                  child: TextFormBox(
                    controller: nameTextController,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5)),
                    placeholder: '닉네임 검색',
                    obscureText: false,
                  ),
                ),
              ),
            ]),
          ),
          userList.when(
            data: (data) {
              if (data.isEmpty) {
                return const Center(
                  child: Text('유저가 없습니다.'),
                );
              } else {
                List<User> list = data
                    .where((element) =>
                        element.call.contains(phoneTextController.text) == true)
                    .toList();
                list
                    .where((element) =>
                        element.name.contains(nameTextController.text) == true)
                    .toList();
                return SizedBox(
                    height: MediaQuery.of(context).size.height - 100,
                    child: SfDataGrid(
                        controller: controller,
                        source: UserDataSource(userData: list),
                        allowSorting: true,
                        columnWidthMode: ColumnWidthMode.fill,
                        sortingGestureType: SortingGestureType.doubleTap,
                        selectionMode: SelectionMode.single,
                        // showCheckboxColumn: true,
                        defaultColumnWidth:
                            (MediaQuery.of(context).size.width - 200) / 8,
                        showSortNumbers: true,
                        showHorizontalScrollbar: true,
                        showVerticalScrollbar: true,
                        shrinkWrapRows: true,
                        shrinkWrapColumns: true,
                        onSelectionChanged: (value, a) {
                          controller.selectedRow?.getCells();
                          print(controller.selectedRows.first.getCells().first.value);
                        },
                        onCellDoubleTap: (value) {
                          if (value.rowColumnIndex.rowIndex != -1 && value.rowColumnIndex.rowIndex != 0) {
                            Navigator.push(
                                        context,
                                        ma.MaterialPageRoute(
                                            builder: (context) =>
                                                UserMileageRecordScreen(
                                                  user: controller.selectedRows.first.getCells().first.value,
                                                )));
                          }
                        },
                        // onCellDoubleTap: (),
                        onCellTap: (value) {
                          if (value.rowColumnIndex.rowIndex != 0) {
                            controller.selectedRow?.getCells();
                            // print(controller.selectedRows);
                             controller.moveCurrentCellTo(value.rowColumnIndex);
                            // final b = controller.selectedRows
                            // print(value.rowColumnIndex);
                            // controller.moveCurrentCellTo(value.rowColumnIndex);
                            // print(controller.currentCell);

                            // b?.forEach((element) {
                            //   print(element.columnName);
                            //   if (element.columnName == 'call') {
                            //
                            //   }
                            // });
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
                        ]));
              }
            },
            error: (e, st) => Text('error'),
            loading: () => const Center(
              child: ProgressRing(),
            ),
          )
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
              DataGridCell(
                  columnName: 'destination', value: e.destination ?? ''),
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
