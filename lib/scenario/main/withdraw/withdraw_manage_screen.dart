import 'package:call_0953_manager/model/withdraw.dart';
import 'package:call_0953_manager/scenario/main/withdraw/withdraw_screen.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../service/mileage_service.dart';

enum WithdrawStatus { all, waiting, completed, rejected }

class WithdrawManageScreen extends ConsumerStatefulWidget {
  const WithdrawManageScreen({super.key});

  @override
  _WithdrawManageScreenState createState() => _WithdrawManageScreenState();
}

class _WithdrawManageScreenState extends ConsumerState<WithdrawManageScreen> {
  final firstDate = StateProvider(
      (ref) => DateTime.now().subtract(const Duration(days: 365)));
  final lastDate = StateProvider((ref) => DateTime.now());

  final indexProvider = StateProvider<int>((ref) => 0);
  final withdrawListProvider =
      FutureProvider((ref) => MileageService().getWithdraw());
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final radioIndex = ref.watch(indexProvider);
    final withdrawList = ref.watch(withdrawListProvider);

    final radioButtons = ['전체', '출금 요청', '출금 완료', '출금 거절'];

    return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: withdrawList.when(
          data: (data) {
            if (data.isNotEmpty) {
              List<Withdraw> result = data.where((element) {
                if (radioIndex == 0) {
                  return true;
                } else if (radioIndex == 1) {
                  return element.status == '요청대기';
                } else if (radioIndex == 2) {
                  return element.status == '출금완료';
                } else if (radioIndex == 3) {
                  return element.status!.contains('출금거절');
                } else {
                  return false;
                }
              }).toList();

              return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                    for (int i = 0; i < 4; i++) ...[
                      Padding(padding: const EdgeInsets.all(10), child: Row(children: [
                        RadioButton(
                          checked: radioIndex == i,
                          // set onChanged to null to disable the button
                          onChanged: (value) =>
                              ref.read(indexProvider.notifier).state = i,
                        ),
                        const SizedBox(width: 4),
                        Text(radioButtons[i])
                      ]),)
                    ]]),
                      SizedBox(
                    width: double.infinity,
                    child:
                      SfDataGrid(
                        onCellDoubleTap: (detail) {
                          if (detail.rowColumnIndex.rowIndex == 0) {
                            ref.read(indexProvider.notifier).state =
                                detail.rowColumnIndex.columnIndex;
                          }
                        },
                        onCellTap: (value) {
                          if (value.rowColumnIndex.rowIndex != 0) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => WithdrawScreen(
                                          withdraw: result.reversed.toList()[
                                              value.rowColumnIndex.rowIndex -
                                                  1],
                                        )));
                          }
                        },
                        defaultColumnWidth:
                            (MediaQuery.of(context).size.width - 200) / 7,
                        sortingGestureType: SortingGestureType.doubleTap,
                        // showCheckboxColumn: true,
                        showSortNumbers: true,
                        showHorizontalScrollbar: true,
                        showVerticalScrollbar: true,
                        shrinkWrapRows: true,
                        shrinkWrapColumns: true,
                        allowSorting: true,
                        source:
                            WithdrawSource(withdraw: result.reversed.toList()),
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
                                    '예금주',
                                    overflow: TextOverflow.ellipsis,
                                  ))),
                          GridColumn(
                              columnName: 'amount',
                              label: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  alignment: Alignment.center,
                                  child: const Text(
                                    '요청금액',
                                    overflow: TextOverflow.ellipsis,
                                  ))),
                          GridColumn(
                              columnName: 'bank',
                              label: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  alignment: Alignment.center,
                                  child: const Text(
                                    '은행',
                                    overflow: TextOverflow.ellipsis,
                                  ))),
                          GridColumn(
                              columnName: 'account',
                              label: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  alignment: Alignment.center,
                                  child: const Text(
                                    '계좌번호',
                                    overflow: TextOverflow.ellipsis,
                                  ))),
                          GridColumn(
                              columnName: 'date',
                              label: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  alignment: Alignment.center,
                                  child: const Text(
                                    '요청일',
                                    overflow: TextOverflow.ellipsis,
                                  ))),
                          GridColumn(
                              columnName: 'status',
                              label: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  alignment: Alignment.center,
                                  child: const Text(
                                    '출금상태',
                                    overflow: TextOverflow.ellipsis,
                                  ))),
                        ],
                      ))

                  ]);
            } else {
              return const Center(
                child: Text('출금 내역이 없습니다.'),
              );
            }
          },
          loading: () => const Center(child: ProgressRing()),
          error: (error, stack) {
            return Center(
              child: Text(error.toString()),
            );
          },
        ));
  }
}

class WithdrawSource extends DataGridSource {
  /// Creates the employee data source class with required details.
  WithdrawSource({required List<Withdraw> withdraw}) {
    _withdraw = withdraw
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<String>(columnName: 'call', value: e.userCall),
              DataGridCell<String>(columnName: 'name', value: e.name),
              DataGridCell<int>(columnName: 'amount', value: e.amount),
              DataGridCell<String>(columnName: 'bank', value: e.bank),
              DataGridCell<String>(columnName: 'account', value: e.account),
              DataGridCell<String>(columnName: 'date', value: e.createdAt),
              DataGridCell<String>(columnName: 'status', value: e.status!),
            ]))
        .toList();
  }

  List<DataGridRow> _withdraw = [];

  @override
  List<DataGridRow> get rows => _withdraw;

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
