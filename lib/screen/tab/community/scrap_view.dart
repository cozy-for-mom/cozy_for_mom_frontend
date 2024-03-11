import 'package:cozy_for_mom_frontend/screen/tab/community/my_scrap.dart';
import 'package:cozy_for_mom_frontend/screen/tab/cozylog/cozylog_model.dart';
import 'package:flutter/material.dart';
import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/screen/tab/community/recent_cozylog_view.dart';

class ScrapListView extends StatefulWidget {
  final List<CozyLogForList> cozyLogs;
  const ScrapListView({super.key, this.cozyLogs = const []});

  @override
  State<ScrapListView> createState() => _ScrapListViewState();
}

class _ScrapListViewState extends State<ScrapListView> {
  bool isEditMode = false;
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    const boxHeight = 20 + 143.0; //screenHeight * (0.6);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            width: screenWidth - 40,
            height: 53,
            decoration: BoxDecoration(
                color: const Color(0xffF0F0F5),
                borderRadius: BorderRadius.circular(30)),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(children: [
                    const Image(
                        image: AssetImage('assets/images/icons/scrap.png'),
                        width: 18.4,
                        height: 24),
                    const SizedBox(width: 8),
                    Text(
                      '${widget.cozyLogs.length}개의 스크랩',
                      style: const TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 14),
                    ),
                  ]),
                  InkWell(
                    onTap: () {
                      widget.cozyLogs.isNotEmpty
                          ? setState(() {
                              isEditMode = !isEditMode;
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          MyScrap(isEditMode: isEditMode)));
                            })
                          : setState(() {});
                    },
                    child: const Text(
                      '편집',
                      style: TextStyle(
                          color: offButtonTextColor,
                          fontWeight: FontWeight.w400,
                          fontSize: 14),
                    ),
                  ),
                ]),
          ),
        ),
        const SizedBox(height: 22),
        widget.cozyLogs.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 60),
                child: Container(
                  width: screenWidth - 40,
                  height: boxHeight * widget.cozyLogs.length + 20,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: contentBoxTwoColor),
                  child: Column(
                    children: widget.cozyLogs
                        .map((cozylog) => CozylogViewWidget(
                              cozylog: cozylog,
                              isEditMode: isEditMode,
                            ))
                        .toList(),
                  ),
                ),
              )
            : SizedBox(
                width: 160,
                height: screenHeight * (0.6),
                child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image(
                          image:
                              AssetImage('assets/images/icons/scrap_off.png'),
                          width: 34.54,
                          height: 45.05),
                      SizedBox(height: 12),
                      Text('코지로그를 스크랩 해보세요!',
                          style: TextStyle(
                              color: Color(0xff9397A4),
                              fontWeight: FontWeight.w500,
                              fontSize: 14)),
                    ]),
              )
      ],
    );
  }
}
