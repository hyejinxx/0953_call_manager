import 'package:call_0953_manager/service/mileage_service.dart';
import 'package:flutter/material.dart';

class MileageManageScreen extends StatefulWidget {
  const MileageManageScreen({super.key});

  @override
  State<MileageManageScreen> createState() => _MileageManageScreenState();
}

class _MileageManageScreenState extends State<MileageManageScreen> {
  bool isAll = true;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(children: [
        CheckboxListTile(
          title: InkWell(
            onTap: () {
              setState(() {
                isAll = !isAll;
              });
            },
            child: const Text('모든 마일리지 보기'),
          ),
          value: isAll,
          onChanged: (value) {
            setState(() {
              isAll = value!;
            });
          },
        ),
        if (!isAll) ...[
          Row(
            children: [
              const Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: '검색할 유저의 번호를 입력하세요',
                    ),
                    obscureText: false,
                  ),
                ),
              ),
              IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.search),
                  color: Colors.black)
            ],
          ),
        ],
        Expanded(child:
        FutureBuilder(
          future: MileageService().getAllMileage(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              print(snapshot.data);
               snapshot.data!.sort((a, b) => b.date.compareTo(a.date));
              return ListView.builder(
                itemCount: snapshot.data?.length,
                itemBuilder: (context, index) {
                  return ExpansionTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(snapshot.data![index].name),
                        Text('${snapshot.data![index].amount}원')
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
                            '전화번호 : ${snapshot.data![index].call}\n닉네임 : ${snapshot.data![index].name}\n적립금 : ${snapshot.data![index].amount.toString()}\n적립 종류: ${snapshot.data![index].type}',
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                height: 1.5)),
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
        ))
      ]),
    );
  }
}
