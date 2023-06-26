import 'package:call_0953_manager/model/withdraw.dart';
import 'package:call_0953_manager/scenario/main/withdraw/withdraw_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../service/mileage_service.dart';
import '../user/user_mileage_list_screen.dart';

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

  WithdrawStatus isAll = WithdrawStatus.all;

  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        ExpansionTile(
          title: const Text('출금 상태 선택'),
          children: [
            RadioListTile(
              title: const Text("전체"),
              value: WithdrawStatus.all,
              groupValue: isAll,
              onChanged: (WithdrawStatus? value) {
                setState(() {
                  isAll = value!;
                });
              },
            ),
            RadioListTile(
              title: const Text("출금 요청"),
              value: WithdrawStatus.waiting,
              groupValue: isAll,
              onChanged: (WithdrawStatus? value) {
                setState(() {
                  isAll = value!;
                });
              },
            ),
            RadioListTile(
              title: const Text("출금 완료"),
              value: WithdrawStatus.completed,
              groupValue: isAll,
              onChanged: (WithdrawStatus? value) {
                setState(() {
                  isAll = value!;
                });
              },
            ),
            RadioListTile(
              title: const Text("출금 거절"),
              value: WithdrawStatus.rejected,
              groupValue: isAll,
              onChanged: (WithdrawStatus? value) {
                setState(() {
                  isAll = value!;
                });
              },
            ),
          ],
        ),
        const Divider(),
        Expanded(
            child: FutureBuilder(
          future: MileageService().getWithdraw(),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              snapshot.data!.sort((a, b) => b.createdAt.compareTo(a.createdAt));
              List<Withdraw> result = snapshot.data!.where((element) {
                if (isAll == WithdrawStatus.all) {
                  return true;
                } else if (isAll == WithdrawStatus.waiting) {
                  return element.status == '요청대기';
                } else if (isAll == WithdrawStatus.completed) {
                  return element.status == '출금완료';
                } else if (isAll == WithdrawStatus.rejected) {
                  return element.status!.contains('출금거절');
                } else {
                  return false;
                }
              }).toList();
              return
                SfDataGrid(
                  onCellTap: (value) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => WithdrawScreen(
                              withdraw:result[value.rowColumnIndex.rowIndex-1],
                            )));
                  },
                    defaultColumnWidth: MediaQuery.of(context).size.width/7, source: WithdrawSource(withdraw: result), columns: <GridColumn>[
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
                ]);
              ListView.builder(
                itemCount: result.length,
                itemBuilder: (context, index) {
                  return ExpansionTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(result[index].userCall),
                        Text('요청 금액: ${result[index].amount}원')
                      ],
                    ),
                    subtitle: Text(
                        result[index].status == '요청대기'
                            ? '요청 대기중'
                            : result[index].status == '출금완료'
                                ? '출금 완료'
                                : '출금 거절',),
                    expandedAlignment: Alignment.topLeft,
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(
                              left: 20, bottom: 10, right: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text(
                                  '전화번호 : ${result[index].userCall}\n'
                                  '은행 : ${result[index].bank}\n'
                                  '계좌번호 : ${result[index].account}\n'
                                  '예금주 : ${result[index].name}\n'
                                  '출금 상태 : ${result[index].status}',
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      height: 1.5)),
                              if(result[index].status == '요청대기')...[
                                Column(children: [
                                  ElevatedButton(onPressed: ()async{
                                    final re = await showDialog(context: context, builder: (BuildContext context) => AlertDialog(
                                      title: const Text('출금 완료'),
                                      content: const Text('출금을 완료하시겠습니까?'),
                                      actions: [
                                        TextButton(onPressed: (){
                                          Navigator.pop(context, true);
                                        }, child: const Text('확인')),
                                        TextButton(onPressed: (){
                                          Navigator.pop(context, false);
                                        }, child: const Text('취소')),
                                      ],
                                    ));
                                    if(re == true){
                                      MileageService().updateWithdraw(result[index], '출금완료');
                                      setState(() {
                                        result[index].status = '출금완료';
                                      });
                                      setState(() {
                                      });
                                    }
                                  }, child: const Text('출금 완료')),
                                  const SizedBox(height: 10,),
                                  ElevatedButton(onPressed: ()async{
                                    final re = await showDialog(context: context, builder: (BuildContext context) => AlertDialog(
                                      title: const Text('출금 거절'),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Text('출금을 거절하시겠습니까?'),
                                          const SizedBox(height: 10,),
                                          TextField(
                                            controller: _controller,
                                            decoration: const InputDecoration(
                                              border: OutlineInputBorder(),
                                              labelText: '거절 사유',
                                            ),
                                          ),
                                        ],
                                      ),
                                      actions: [
                                        TextButton(onPressed: (){
                                          Navigator.pop(context, true);
                                        }, child: const Text('확인')),
                                        TextButton(onPressed: (){
                                          Navigator.pop(context, false);
                                        }, child: const Text('취소')),
                                      ],
                                    ));
                                    if(re){
                                      MileageService().updateWithdraw(result[index], '출금거절${_controller.text}');
                                      setState(() {
                                        result[index].status = '출금거절';
                                      });
                                      setState(() {
                                        result[index].status = '출금거절';
                                      });
                                    }
                                  }, child: const Text('출금 거절')),
                                ],),
                              ]
                            ],
                          ))
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
        ))
      ]),
    );
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
      DataGridCell<String>(
          columnName: 'account', value: e.account),
      DataGridCell<String>(
            columnName: 'date', value: e.createdAt),
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
