import 'package:call_0953_manager/service/call_service.dart';
import 'package:call_0953_manager/service/mileage_service.dart';
import 'package:flutter/material.dart';

class CallManageScreen extends StatefulWidget {
  const CallManageScreen({super.key});

  @override
  State<CallManageScreen> createState() => CallManageScreenState();
}

class CallManageScreenState extends State<CallManageScreen> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: FutureBuilder(
            future: CallService().getAllCall(),
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
                          Text('${snapshot.data![index].price}원')
                        ],
                      ),
                      subtitle: Text(snapshot.data![index].date
                          .toString()
                          .replaceAll('-', '/')),
                      expandedAlignment: Alignment.topLeft,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20, bottom: 10),
                          child: Text(
                              '전화번호 : ${snapshot.data![index].call}\n닉네임 : ${snapshot.data![index].name}\n대리 금액 : ${snapshot.data![index].price.toString()}\n적립금: ${snapshot.data![index].mileage}',
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