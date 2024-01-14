import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/screen/mom/alarm/alarm_setting.dart';
import 'package:cozy_for_mom_frontend/screen/tab/cozylog/cozylog_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CozyLogDetailScreen extends StatefulWidget {
  const CozyLogDetailScreen({super.key});

  @override
  State<CozyLogDetailScreen> createState() => _CozyLogDetailScreenState();
}

class _CozyLogDetailScreenState extends State<CozyLogDetailScreen> {
  late CozyLog cozyLog;
  late bool isMyCozyLog;
  DateFormat dateFormat = DateFormat('yyyy. MM. dd hh:mm');
  String commentInput = '';

  Image submitIcon = const Image(
      image: AssetImage(
    "assets/images/icons/submit_inactive.png",
  ));

  late TextEditingController textController;

  @override
  void initState() {
    super.initState();
    cozyLog = CozyLog(
      cozyLogId: 1,
      title: "오늘은 태동을 느낀 날",
      writer: CozyLogWriter(id: 2, nickname: "쥬쥬", imageUrl: null),
      content: "오늘은 미롱이가 ㅎㅎ 후후훟\n슈슈슈슝",
      imageList: [
        CozyLogImage(
          imageUrl:
              "https://t1.daumcdn.net/thumb/R720x0/?fname=http://t1.daumcdn.net/brunch/service/user/2a4t/image/w_yQeuiLSMJCqBEn7wiD__r07T4.jpg",
          description: "샐러드",
        ),
        CozyLogImage(
          imageUrl:
              "https://homecuisine.co.kr/files/attach/images/140/568/068/1a35dcd464cc1c5520b7b4a8c4ed7532.JPG",
          description: "찜닭",
        ),
      ],
      mode: CozyLogModeType.public,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      scrapCount: 4,
      viewCount: 40,
      isScrapped: false,
    );
    isMyCozyLog = cozyLog.writer.id == 2;
    textController = TextEditingController(text: commentInput);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size(400, 60),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  const Text(
                    '내 코지로그',
                    style: TextStyle(
                      color: mainTextColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                  IconButton(
                    icon: const Image(
                      image: AssetImage('assets/images/icons/alert.png'),
                      height: 32,
                      width: 32,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AlarmSettingPage(
                            type: CardType.supplement,
                          ),
                        ),
                      );
                    },
                  )
                ],
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              cozyLog.title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 17,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SizedBox(
                      height: 50,
                      child: cozyLog.writer.imageUrl == null
                          ? Image.asset("assets/images/icons/momProfile.png")
                          : Image.network(
                              cozyLog.writer.imageUrl!,
                            ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          cozyLog.writer.nickname,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Text(
                              dateFormat.format(cozyLog.createdAt),
                              style: const TextStyle(
                                color: Color(0xffAAAAAA),
                              ),
                            ),
                            isMyCozyLog
                                ? Text(
                                    "・${cozyLog.mode == CozyLogModeType.public ? "공개" : "비공개"}",
                                    style: const TextStyle(
                                      color: Color(0xffAAAAAA),
                                    ),
                                  )
                                : Container()
                          ],
                        ),
                      ],
                    )
                  ],
                ),
                isMyCozyLog
                    ? IconButton(
                        onPressed: () {
                          showModalBottomSheet<void>(
                            backgroundColor: Colors.transparent,
                            context: context,
                            builder: (BuildContext context) {
                              return SizedBox(
                                height: 220,
                                child: Column(
                                  children: [
                                    Container(
                                      width: 350,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.white,
                                      ),
                                      child: Center(
                                        child: Column(children: <Widget>[
                                          ListTile(
                                            title: const Center(
                                                child: Text(
                                              '수정하기',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                              ),
                                            )),
                                            onTap: () {
                                              // TODO 수정하기 페이지로 이동
                                              Navigator.pop(context);
                                            },
                                          ),
                                          ListTile(
                                            title: const Center(
                                                child: Text(
                                              '삭제하기',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                              ),
                                            )),
                                            onTap: () {
                                              // TODO 삭제하기 API 호출
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ]),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: Container(
                                        width: 350,
                                        height: 56,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          color: const Color(0xffC9DFF9),
                                        ),
                                        child: const Center(
                                            child: Text(
                                          "취소",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        )),
                                      ),
                                    )
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        icon: const Icon(
                          Icons.more_vert_outlined,
                          color: Color(0xff858998),
                        ),
                      )
                    : IconButton(
                        onPressed: () {
                          // 스크랩 버튼 누르기 API
                        },
                        icon: cozyLog.isScrapped
                            ? const Icon(
                                Icons.bookmark_rounded,
                                color: Color(0xff858998),
                              )
                            : const Icon(
                                Icons.bookmark_outline_rounded,
                                color: Color(0xff858998),
                              ),
                      ), // TODO 아이콘으로 수정 필요
              ],
            ),
            const Divider(
              color: Color(0xffE1E1E7),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              cozyLog.content,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(
              height: 22,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: cozyLog.imageList.length,
                itemBuilder: (BuildContext context, int index) {
                  return SizedBox(
                    child: Column(
                      children: [
                        Container(
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Image.network(
                            cozyLog.imageList[index].imageUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          cozyLog.imageList[index].description,
                          style: const TextStyle(
                            color: Color(0xffAAAAAA),
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                height: 36,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    20,
                  ),
                  color: const Color(0xffF7F7FA),
                ),
                child: TextField(
                  controller: textController,
                  onChanged: (text) {
                    if (text != '') {
                      setState(() {
                        commentInput = text;
                        submitIcon = const Image(
                            image: AssetImage(
                          "assets/images/icons/submit_active.png",
                        ));
                      });
                    } else {
                      setState(() {
                        commentInput = '';
                        submitIcon = const Image(
                            image: AssetImage(
                          "assets/images/icons/submit_inactive.png",
                        ));
                      });
                    }
                  },
                  cursorColor: primaryColor,
                  decoration: InputDecoration(
                    hintText: "댓글을 남겨주세요.",
                    hintStyle: const TextStyle(
                      color: Color(0xffBCC0C7),
                      fontSize: 14,
                    ),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        if (commentInput != '') {
                          print("send"); // TODO API 호출
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: submitIcon,
                      ),
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
