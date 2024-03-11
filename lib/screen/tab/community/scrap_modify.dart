import 'package:cozy_for_mom_frontend/screen/tab/community/my_scrap.dart';
import 'package:cozy_for_mom_frontend/screen/tab/cozylog/cozylog_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/screen/tab/community/recent_cozylog_view.dart';
import 'package:cozy_for_mom_frontend/screen/tab/community/list_modify_state.dart';

class ScrapListModify extends StatefulWidget {
  final List<CozyLogForList> cozyLogs;
  const ScrapListModify({super.key, this.cozyLogs = const []});

  @override
  State<ScrapListModify> createState() => _ScrapListModifyState();
}

class _ScrapListModifyState extends State<ScrapListModify> {
  bool isAllSelected = false;
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    const boxHeight = 20 + 143.0; //screenHeight * (0.6);
    ListModifyState scrapListModifyState = context.watch<ListModifyState>();
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
                    Consumer<ListModifyState>(
                      builder: (context, cozylogListModifyState, child) {
                        return Text(
                          '${scrapListModifyState.selectedCount}/${widget.cozyLogs.length}',
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
                        onTap: () {
                          isAllSelected
                              ? scrapListModifyState.clearSelection()
                              : scrapListModifyState
                                  .setAllSelected(widget.cozyLogs);
                          setState(() {
                            isAllSelected = !isAllSelected;
                          });
                        },
                        child: Text(isAllSelected ? '전체해제' : '전체선택',
                            style: const TextStyle(
                                color: offButtonTextColor,
                                fontWeight: FontWeight.w400,
                                fontSize: 14)),
                      ),
                      const SizedBox(width: 24),
                      InkWell(
                        onTap: () {
                          scrapListModifyState.clearSelection();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const MyScrap()));
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
                      isEditMode: true,
                      listModifyState: scrapListModifyState,
                      onSelectedChanged: (isSelected) {
                        scrapListModifyState.toggleSelected(cozylog.cozyLogId);
                        setState(() {});
                      }))
                  .toList(),
            ),
          ),
        )
      ],
    );
  }
}
