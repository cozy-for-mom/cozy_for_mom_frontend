import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/screen/tab/community/recent_cozylog_view.dart';
import 'package:cozy_for_mom_frontend/model/cozylog_model.dart';
import 'package:cozy_for_mom_frontend/screen/tab/community/my_cozylog.dart';

class CozylogListModify extends StatefulWidget {
  final List<CozyLog> cozyLogs;
  const CozylogListModify({super.key, this.cozyLogs = const []});

  @override
  State<CozylogListModify> createState() => _CozylogListModifyState();
}

class CozylogListModifyState extends ChangeNotifier {
  int _selectedCount = 0;

  int get selectedCount => _selectedCount;

  void incrementSelectedCount() {
    _selectedCount++;
    notifyListeners();
  }

  void decrementSelectedCount() {
    _selectedCount--;
    notifyListeners();
  }
}

class _CozylogListModifyState extends State<CozylogListModify> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    const boxHeight = 20 + 143.0; //screenHeight * (0.6);
    CozylogListModifyState cozylogListModifyState =
        context.watch<CozylogListModifyState>();
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
                        image: AssetImage('assets/images/icons/cozylog.png'),
                        width: 25.02,
                        height: 23.32),
                    const SizedBox(width: 8),
                    Consumer<CozylogListModifyState>(
                      builder: (context, cozylogListModifyState, child) {
                        return Text(
                          '${cozylogListModifyState.selectedCount}/${widget.cozyLogs.length}',
                          style: const TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 14),
                        );
                      },
                    ),
                  ]),
                  Row(
                    children: [
                      InkWell(
                        onTap: () {},
                        child: const Text('전체선택',
                            style: TextStyle(
                                color: offButtonTextColor,
                                fontWeight: FontWeight.w400,
                                fontSize: 14)),
                      ),
                      const SizedBox(width: 24),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const MyCozylog()));
                        },
                        child: const Text('편집완료',
                            style: TextStyle(
                                color: offButtonTextColor,
                                fontWeight: FontWeight.w400,
                                fontSize: 14)),
                      ),
                    ],
                  ),
                ]),
          ),
        ),
        const SizedBox(height: 22),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
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
                      isEditMode: true,
                      onSelectedChanged: (isSelected) {
                        // isSelected가 변경되면 호출되는 콜백 함수
                        if (isSelected) {
                          cozylogListModifyState.incrementSelectedCount();
                        } else {
                          cozylogListModifyState.decrementSelectedCount();
                        }
                        setState(() {}); // setState를 호출하여 UI 업데이트
                      }))
                  .toList(),
            ),
          ),
        )
      ],
    );
  }
}