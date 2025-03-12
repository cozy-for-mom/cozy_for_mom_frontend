import 'dart:math';

import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/common/widget/complite_alert.dart';
import 'package:cozy_for_mom_frontend/common/widget/delete_modal.dart';
import 'package:cozy_for_mom_frontend/screen/tab/community/cozylog_edit_screen.dart';
import 'package:cozy_for_mom_frontend/screen/tab/cozylog/cozylog_comment_component.dart';
import 'package:cozy_for_mom_frontend/screen/tab/cozylog/cozylog_comment_model.dart';
import 'package:cozy_for_mom_frontend/screen/tab/cozylog/cozylog_model.dart';
import 'package:cozy_for_mom_frontend/service/cozylog/block_api_service.dart';
import 'package:cozy_for_mom_frontend/service/cozylog/cozylog_api_service.dart';
import 'package:cozy_for_mom_frontend/service/cozylog/cozylog_comment_api_service.dart';
import 'package:cozy_for_mom_frontend/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:cozy_for_mom_frontend/service/user/token_manager.dart'
    as TokenManager;

// 목록 --> 상세 페이지 --replacement--> 수정페이지 --replacement--> 상세페이지
class CozyLogDetailScreen extends StatefulWidget {
  final int id;
  const CozyLogDetailScreen({super.key, required this.id});

  @override
  State<CozyLogDetailScreen> createState() => _CozyLogDetailScreenState();
}

class _CozyLogDetailScreenState extends State<CozyLogDetailScreen> {
  late Future<CozyLog?> futureCozyLog;
  late Future<List<CozyLogComment>?> futureComments;
  bool isMyCozyLog = false;
  int? parentCommentIdToReply;
  int? commentIdToUpdate;
  DateFormat dateFormat = DateFormat('yyyy. MM. dd HH:mm');
  String commentInput = '';
  final tokenManager = TokenManager.TokenManager();
  bool isEditMode = false;

  Image submitIcon = const Image(
      image: AssetImage(
    "assets/images/icons/submit_inactive.png",
  ));

  TextEditingController textController = TextEditingController();

  void reloadCozyLog() {
    futureCozyLog = CozyLogApiService().getCozyLog(context, widget.id);
  }

  final reportedReasons = [
    "비방, 불쾌감을 주는 글이에요.",
    "허위 정보가 있는 글이에요.",
    "광고성 내용이 포함된 글이에요.",
    "선정적, 음란물을 작성해 거부감을 느껴요.",
  ];

  int? selectedIndex;

  @override
  void initState() {
    super.initState();
    CozyLogApiService().countCozylogView(context, widget.id);
    futureCozyLog = CozyLogApiService().getCozyLog(context, widget.id);
    futureCozyLog.then((value) {
      if (value != null) {
        setIsMyCozyLog(value);
      }
    });

    futureComments =
        CozyLogCommentApiService().getCozyLogComments(context, widget.id);
  }

  void setIsMyCozyLog(CozyLog cozyLog) async {
    final userId = await tokenManager.getUserId();
    bool newIsMyCozyLog = cozyLog.writer.id == userId;
    if (newIsMyCozyLog != isMyCozyLog) {
      setState(() {
        isMyCozyLog = newIsMyCozyLog;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    BlockApiService blockApi = BlockApiService();
    final isTablet = screenWidth > 600;
    final isSmall = screenHeight < 670;
    final paddingValue = isTablet ? 30.w : 20.w;
    return FutureBuilder(
      future: futureCozyLog,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final cozyLog = snapshot.data!;
          return Scaffold(
            backgroundColor: backgroundColor,
            appBar: PreferredSize(
              preferredSize: Size(screenWidth, 60.w),
              child: Padding(
                padding: EdgeInsets.only(
                    top: paddingValue, bottom: paddingValue - 20.w, right: 8.w),
                child: Column(
                  children: [
                    SizedBox(height: isSmall ? 0.w : 40.w),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: Image(
                            image: const AssetImage(
                                'assets/images/icons/back_ios.png'),
                            width: min(34.w, 44),
                            height: min(34.w, 44),
                            color: mainTextColor,
                          ),
                          onPressed: () {
                            Navigator.of(context).pop(true);
                          },
                        ),
                        const Spacer(),
                        Text(
                          isMyCozyLog ? '내 코지로그' : '코지로그',
                          style: TextStyle(
                            color: mainTextColor,
                            fontWeight: FontWeight.w600,
                            fontSize: min(18.sp, 28),
                          ),
                        ),
                        const Spacer(),
                        SizedBox(
                          width: min(32.w, 42),
                          height: min(32.w, 42),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            body: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    physics: ClampingScrollPhysics(),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: paddingValue, vertical: 8.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            cozyLog.title,
                            style: TextStyle(
                                fontSize: min(20.sp, 30),
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            height: 17.w,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  InkWell(
                                    onTap: isMyCozyLog
                                        ? null
                                        : () {
                                            showModalBottomSheet<void>(
                                              backgroundColor:
                                                  Colors.transparent,
                                              elevation: 0.0,
                                              context: context,
                                              builder: (BuildContext context) {
                                                return SizedBox(
                                                  height: isTablet
                                                      ? 234.w -
                                                          60.w -
                                                          paddingValue
                                                      : 234.w - 60.w,
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical: 8.w),
                                                        width: screenWidth -
                                                            2 * paddingValue,
                                                        height:
                                                            95.w - paddingValue,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      20.w),
                                                          color: Colors.white,
                                                        ),
                                                        child: Center(
                                                          child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: <Widget>[
                                                                ListTile(
                                                                  title: Center(
                                                                      child:
                                                                          Text(
                                                                    '작성자 차단하기',
                                                                    style: TextStyle(
                                                                        color:
                                                                            deleteButtonColor,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w600,
                                                                        fontSize: min(
                                                                            16.sp,
                                                                            26)),
                                                                  )),
                                                                  onTap:
                                                                      () async {
                                                                    await blockApi.blockUser(
                                                                        context,
                                                                        cozyLog
                                                                            .writer
                                                                            .id);
                                                                    if (mounted) {
                                                                      // TODO 제대로 동작하는지 확인 필요
                                                                      await CompleteAlertModal
                                                                          .showCompleteDialog(
                                                                        context,
                                                                        '작성자가',
                                                                        '차단',
                                                                      );
                                                                    }
                                                                    if (mounted) {
                                                                      Navigator.pop(
                                                                          context);
                                                                    }
                                                                  },
                                                                ),
                                                              ]),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 15.w,
                                                      ),
                                                      InkWell(
                                                        onTap: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Container(
                                                          width: screenWidth -
                                                              2 * paddingValue,
                                                          height: min(56.w, 96),
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12.w),
                                                            color:
                                                                induceButtonColor,
                                                          ),
                                                          child: Center(
                                                              child: Text(
                                                            "취소",
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize: min(
                                                                  16.sp, 26),
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
                                    child: cozyLog.writer.imageUrl == null
                                        ? Image.asset(
                                            "assets/images/icons/momProfile.png",
                                            width: min(50.w, 100),
                                            height: min(50.w, 100),
                                          )
                                        : ClipOval(
                                            child: Image.network(
                                              cozyLog.writer.imageUrl!,
                                              fit: BoxFit.cover,
                                              width: min(50.w, 100),
                                              height: min(50.w, 100),
                                            ),
                                          ),
                                  ),
                                  SizedBox(
                                    width: 15.w,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        cozyLog.writer.nickname,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: min(14.sp, 24),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5.w,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            dateFormat
                                                .format(cozyLog.createdAt),
                                            style: TextStyle(
                                              color: const Color(0xffAAAAAA),
                                              fontWeight: FontWeight.w500,
                                              fontSize: min(14.sp, 24),
                                            ),
                                          ),
                                          isMyCozyLog
                                              ? Text(
                                                  "・${cozyLog.mode == CozyLogModeType.public ? "공개" : "비공개"}",
                                                  style: TextStyle(
                                                    color:
                                                        const Color(0xffAAAAAA),
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: min(14.sp, 24),
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
                                  ? SizedBox(
                                      width: min(15.w, 25),
                                      height: min(32.w, 42),
                                      child: IconButton(
                                        padding: EdgeInsets.zero,
                                        onPressed: () {
                                          showModalBottomSheet<void>(
                                            backgroundColor: Colors.transparent,
                                            elevation: 0.0,
                                            context: context,
                                            builder: (BuildContext context) {
                                              return SizedBox(
                                                height: isTablet
                                                    ? 234.w - paddingValue
                                                    : 234.w,
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 8.w),
                                                      width: screenWidth -
                                                          2 * paddingValue,
                                                      height:
                                                          153.w - paddingValue,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20.w),
                                                        color: Colors.white,
                                                      ),
                                                      child: Center(
                                                        child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceAround,
                                                            children: <Widget>[
                                                              ListTile(
                                                                title: Center(
                                                                    child: Text(
                                                                  '수정하기',
                                                                  style:
                                                                      TextStyle(
                                                                    color:
                                                                        mainTextColor,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    fontSize: min(
                                                                        16.sp,
                                                                        26),
                                                                  ),
                                                                )),
                                                                onTap:
                                                                    () async {
                                                                  await Navigator
                                                                      .push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              CozylogEditPage(
                                                                        id: widget
                                                                            .id,
                                                                      ),
                                                                    ),
                                                                  ).then(
                                                                      (value) {
                                                                    if (value ==
                                                                        true) {
                                                                      Navigator.pop(
                                                                          context,
                                                                          true);
                                                                      Navigator.pop(
                                                                          context,
                                                                          true);
                                                                    }
                                                                  });
                                                                },
                                                              ),
                                                              ListTile(
                                                                title: Center(
                                                                    child: Text(
                                                                  '글 삭제하기',
                                                                  style:
                                                                      TextStyle(
                                                                    color:
                                                                        mainTextColor,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    fontSize: min(
                                                                        16.sp,
                                                                        26),
                                                                  ),
                                                                )),
                                                                onTap:
                                                                    () async {
                                                                  showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (BuildContext
                                                                            context) {
                                                                      return DeleteModal(
                                                                        title:
                                                                            '코지로그가',
                                                                        text:
                                                                            '삭제된 글은 다시 복구할 수 없습니다.\n삭제하시겠습니까?',
                                                                        tapFunc:
                                                                            () async {
                                                                          await CozyLogApiService().deleteCozyLog(
                                                                              context,
                                                                              cozyLog.cozyLogId!);
                                                                          setState(
                                                                              () {});
                                                                        },
                                                                        shouldCloseParentCnt:
                                                                            3,
                                                                      );
                                                                    },
                                                                    barrierDismissible:
                                                                        false,
                                                                  );
                                                                },
                                                              ),
                                                            ]),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 15.w,
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: Container(
                                                        width: screenWidth -
                                                            2 * paddingValue,
                                                        height: min(56.w, 96),
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      12.w),
                                                          color:
                                                              induceButtonColor,
                                                        ),
                                                        child: Center(
                                                            child: Text(
                                                          "취소",
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize:
                                                                min(16.sp, 26),
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
                                        icon: Image(
                                          image: const AssetImage(
                                              'assets/images/icons/more_vert_outlined.png'),
                                          color: const Color(0xff858998),
                                          width: min(3.w, 6),
                                          height: min(17.w, 34),
                                        ),
                                      ),
                                    )
                                  : Row(
                                      children: [
                                        SizedBox(
                                          width: min(25.w, 35),
                                          height: min(32.w, 42),
                                          child: IconButton(
                                            padding: EdgeInsets.zero,
                                            onPressed: () async {
                                              // 스크랩 상태에 따른 API 호출
                                              if (cozyLog.isScrapped) {
                                                await CozyLogApiService()
                                                    .unscrapCozyLog(
                                                        context, widget.id);
                                              } else {
                                                await CozyLogApiService()
                                                    .scrapCozyLog(
                                                        context, widget.id);
                                              }

                                              // 상태 업데이트
                                              setState(() {
                                                futureCozyLog =
                                                    CozyLogApiService()
                                                        .getCozyLog(
                                                            context, widget.id);
                                              });
                                            },
                                            icon: cozyLog.isScrapped
                                                ? Image(
                                                    image: const AssetImage(
                                                        'assets/images/icons/scrap_fill.png'),
                                                    width: min(12.75.w, 22.75),
                                                    height: min(17.w, 27),
                                                  )
                                                : Image(
                                                    image: const AssetImage(
                                                        'assets/images/icons/unscrap.png'),
                                                    width: min(12.75.w, 22.75),
                                                    height: min(17.w, 27),
                                                  ),
                                          ),
                                        ),
                                        SizedBox(width: 4.w),
                                        SizedBox(
                                          width: min(15.w, 25),
                                          height: min(32.w, 42),
                                          child: IconButton(
                                            padding: EdgeInsets.zero,
                                            onPressed: () {
                                              showModalBottomSheet<void>(
                                                backgroundColor:
                                                    Colors.transparent,
                                                elevation: 0.0,
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return SizedBox(
                                                    height: isTablet
                                                        ? 234.w -
                                                            60.w -
                                                            paddingValue
                                                        : 234.w - 60.w,
                                                    child: Column(
                                                      children: [
                                                        Container(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  vertical:
                                                                      8.w),
                                                          width: screenWidth -
                                                              2 * paddingValue,
                                                          height: 95.w -
                                                              paddingValue,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20.w),
                                                            color: Colors.white,
                                                          ),
                                                          child: Center(
                                                            child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: <Widget>[
                                                                  ListTile(
                                                                    title: Center(
                                                                        child: Text(
                                                                      '글 신고하기',
                                                                      style: TextStyle(
                                                                          color:
                                                                              deleteButtonColor,
                                                                          fontWeight: FontWeight
                                                                              .w600,
                                                                          fontSize: min(
                                                                              16.sp,
                                                                              26)),
                                                                    )),
                                                                    onTap:
                                                                        () async {
                                                                      Navigator.pop(
                                                                          context);
                                                                      showModalBottomSheet(
                                                                        backgroundColor:
                                                                            Colors.transparent,
                                                                        isScrollControlled:
                                                                            true,
                                                                        elevation:
                                                                            0.0,
                                                                        context:
                                                                            context,
                                                                        builder:
                                                                            (context) {
                                                                          return StatefulBuilder(builder:
                                                                              (BuildContext context, StateSetter modalSetState) {
                                                                            return Wrap(children: [
                                                                              Container(
                                                                                alignment: AlignmentDirectional.centerEnd,
                                                                                margin: EdgeInsets.only(bottom: min(15.w, 15)),
                                                                                height: 20.w,
                                                                                child: IconButton(
                                                                                  icon: const Icon(Icons.close),
                                                                                  iconSize: min(20.w, 40),
                                                                                  onPressed: () {
                                                                                    Navigator.of(context).pop(); // 팝업 닫기
                                                                                  },
                                                                                ),
                                                                              ),
                                                                              Container(
                                                                                height: isSmall? screenHeight * 0.7 : screenHeight * 0.6,
                                                                                decoration: BoxDecoration(
                                                                                  color: Colors.white,
                                                                                  borderRadius: BorderRadius.only(
                                                                                    topLeft: Radius.circular(20.w),
                                                                                    topRight: Radius.circular(20.w),
                                                                                  ),
                                                                                ),
                                                                                child: Padding(
                                                                                  padding: EdgeInsets.symmetric(vertical: 30.w, horizontal: 25.w),
                                                                                  child: Column(
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      Text(
                                                                                        "게시글 신고 사유를 알려주세요.",
                                                                                        style: TextStyle(
                                                                                          color: Colors.black,
                                                                                          fontWeight: FontWeight.w600,
                                                                                          fontSize: min(22.sp, 32),
                                                                                        ),
                                                                                      ),
                                                                                      SizedBox(
                                                                                        height: 5.w,
                                                                                      ),
                                                                                      Text(
                                                                                        "신고하는 이유에 해당하는 항목을 선택해주세요.",
                                                                                        style: TextStyle(
                                                                                          color: const Color(0xff8C909E),
                                                                                          fontWeight: FontWeight.w500,
                                                                                          fontSize: min(14.sp, 24),
                                                                                        ),
                                                                                      ),
                                                                                      SizedBox(
                                                                                        height: min(30.w, 40),
                                                                                      ),
                                                                                      Expanded(
                                                                                        child: ListView.builder(
                                                                                          physics: const NeverScrollableScrollPhysics(),
                                                                                          itemCount: reportedReasons.length,
                                                                                          itemBuilder: (context, index) {
                                                                                            return Padding(
                                                                                              padding: EdgeInsets.symmetric(
                                                                                                vertical: min(8.w, 12),
                                                                                              ),
                                                                                              child: Container(
                                                                                                height: min(48.w, 88),
                                                                                                decoration: BoxDecoration(
                                                                                                  color: const Color(0xffF7F7FA),
                                                                                                  borderRadius: BorderRadius.circular(10.w),
                                                                                                  border: selectedIndex == index
                                                                                                      ? Border.all(
                                                                                                          color: primaryColor,
                                                                                                          width: 2.w,
                                                                                                        )
                                                                                                      : null,
                                                                                                ),
                                                                                                child: InkWell(
                                                                                                  onTap: () {
                                                                                                    modalSetState(() {
                                                                                                      if (selectedIndex == index) {
                                                                                                        selectedIndex = null; // 선택 해제
                                                                                                      } else {
                                                                                                        selectedIndex = index; // 선택 변경
                                                                                                      }
                                                                                                    });
                                                                                                  },
                                                                                                  child: Align(
                                                                                                    alignment: Alignment.centerLeft,
                                                                                                    child: Padding(
                                                                                                      padding: EdgeInsets.symmetric(vertical: 10.w, horizontal: min(20.w, 30)),
                                                                                                      child: Row(
                                                                                                        children: [
                                                                                                          Icon(
                                                                                                            Icons.check,
                                                                                                            color: selectedIndex == index ? primaryColor : const Color(0xffD9D9D9),
                                                                                                            size: min(18.w, 28),
                                                                                                            weight: 5.w,
                                                                                                          ),
                                                                                                          SizedBox(
                                                                                                            width: 20.w,
                                                                                                          ),
                                                                                                          Text(
                                                                                                            reportedReasons[index],
                                                                                                            textAlign: TextAlign.start,
                                                                                                            style: TextStyle(
                                                                                                              color: selectedIndex == index ? Colors.black : const Color(0xff858998),
                                                                                                              fontWeight: FontWeight.w400,
                                                                                                              fontSize: min(14.sp, 24),
                                                                                                            ),
                                                                                                          ),
                                                                                                        ],
                                                                                                      ),
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                            );
                                                                                          },
                                                                                        ),
                                                                                      ),
                                                                                      Row(
                                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                        children: [
                                                                                          InkWell(
                                                                                            onTap: () {
                                                                                              Navigator.of(context).pop(); // 팝업 닫기
                                                                                            },
                                                                                            child: Container(
                                                                                              width: screenWidth * 0.42,
                                                                                              height: min(48.w, 88),
                                                                                              decoration: BoxDecoration(
                                                                                                  color: Colors.transparent,
                                                                                                  borderRadius: BorderRadius.circular(30.w),
                                                                                                  border: Border.all(
                                                                                                    color: const Color(0xffD9D9D9),
                                                                                                    width: 1.w,
                                                                                                  )),
                                                                                              child: Center(
                                                                                                child: Text(
                                                                                                  '취소',
                                                                                                  style: TextStyle(color: const Color(0xff858998), fontSize: min(14.sp, 24), fontWeight: FontWeight.w600),
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          InkWell(
                                                                                            onTap: () async {
                                                                                              if (selectedIndex != null) {
                                                                                                await blockApi.violateCozyLog(context, cozyLog.cozyLogId!, reportedReasons[selectedIndex!]);
                                                                                                if (mounted) {
                                                                                                  await CompleteAlertModal.showCompleteDialog(
                                                                                                    context,
                                                                                                    '코지로그가',
                                                                                                    '신고',
                                                                                                  );
                                                                                                }
                                                                                                if (mounted) {
                                                                                                  Navigator.pop(context); // 신고 사유 선택 모달 닫힘
                                                                                                  Navigator.pop(context, true); // 신고한 코지로그 디테일 페이지에서 나감
                                                                                                }
                                                                                              }
                                                                                            },
                                                                                            child: Container(
                                                                                              width: screenWidth * 0.42,
                                                                                              height: min(48.w, 88),
                                                                                              decoration: BoxDecoration(
                                                                                                  color: Colors.transparent,
                                                                                                  borderRadius: BorderRadius.circular(30.w),
                                                                                                  border: Border.all(
                                                                                                    color: selectedIndex == null ? offButtonColor : const Color(0xffFC4141),
                                                                                                    width: 1.w,
                                                                                                  )),
                                                                                              child: Center(
                                                                                                child: Text(
                                                                                                  '신고하기',
                                                                                                  style: TextStyle(color: selectedIndex == null ? offButtonColor : const Color(0xffFC4141), fontSize: min(14.sp, 24), fontWeight: FontWeight.w600),
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      )
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              )
                                                                            ]);
                                                                          });
                                                                        },
                                                                      );
                                                                    },
                                                                  ),
                                                                ]),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 15.w,
                                                        ),
                                                        InkWell(
                                                          onTap: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: Container(
                                                            width: screenWidth -
                                                                2 * paddingValue,
                                                            height:
                                                                min(56.w, 96),
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          12.w),
                                                              color:
                                                                  induceButtonColor,
                                                            ),
                                                            child: Center(
                                                                child: Text(
                                                              "취소",
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontSize: min(
                                                                    16.sp, 26),
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
                                            icon: Image(
                                              image: const AssetImage(
                                                  'assets/images/icons/more_vert_outlined.png'),
                                              color: const Color(0xff858998),
                                              width: min(3.w, 6),
                                              height: min(17.w, 34),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                            ],
                          ),
                          SizedBox(height: 10.w),
                          const Divider(
                            color: Color(0xffE1E1E7),
                          ),
                          SizedBox(
                            height: 20.w,
                          ),
                          Text(
                            cozyLog.content,
                            style: TextStyle(
                                color: mainTextColor,
                                fontWeight: FontWeight.w500,
                                fontSize: min(14.sp, 24)),
                          ),
                          SizedBox(
                            height: 22.w,
                          ),

                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: cozyLog.imageList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return SizedBox(
                                child: Column(
                                  children: [
                                    Container(
                                      clipBehavior: Clip.hardEdge,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(20.w),
                                      ),
                                      child: Image.network(
                                        cozyLog.imageList[index].imageUrl,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10.w,
                                    ),
                                    Text(
                                      cozyLog.imageList[index].description,
                                      style: TextStyle(
                                        color: const Color(0xffAAAAAA),
                                        fontWeight: FontWeight.w500,
                                        fontSize: min(12.sp, 22),
                                      ),
                                      textAlign:
                                          TextAlign.center, // TODO start가 나으려나?
                                    ),
                                    SizedBox(
                                      height: 12.w,
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          SizedBox(
                            width: 144.w,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Image(
                                      image: const AssetImage(
                                          'assets/images/icons/scrap_gray.png'),
                                      width: min(11.76.w, 21.76),
                                      height: min(15.68.w, 25.68),
                                      color: Colors.black,
                                    ),
                                    SizedBox(width: 8.w),
                                    Text(
                                      '스크랩 ${cozyLog.scrapCount}',
                                      style: TextStyle(
                                        color: const Color(0xff8C909E),
                                        fontWeight: FontWeight.w600,
                                        fontSize: min(12.sp, 22),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Image(
                                        image: const AssetImage(
                                            'assets/images/icons/comment.png'),
                                        width: min(16.w, 26),
                                        height: min(15.68.w, 25.68),
                                        color: Colors.black),
                                    SizedBox(width: 8.w),
                                    Text('댓글 ${cozyLog.commentCount}',
                                        style: TextStyle(
                                            color: const Color(0xff8C909E),
                                            fontWeight: FontWeight.w600,
                                            fontSize: min(12.sp, 22))),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 30.w),
                          // 댓글 목록
                          Divider(
                            height: 30.w,
                            color: mainLineColor,
                          ),
                          FutureBuilder(
                              future: futureComments,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return SizedBox(
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: snapshot.data!.length,
                                      itemBuilder: (context, index) {
                                        if ((!snapshot
                                                .data![index].isDeleted) ||
                                            (snapshot.data![index].isDeleted &&
                                                snapshot.data![index]
                                                    .subComments!.isNotEmpty)) {
                                          return Column(
                                            children: [
                                              CozyLogCommentComponent(
                                                  cozyLog: cozyLog,
                                                  isMyCozyLog: isMyCozyLog,
                                                  comment:
                                                      snapshot.data![index],
                                                  subComments: snapshot
                                                          .data![index]
                                                          .subComments ??
                                                      [],
                                                  onReply: () {
                                                    setState(() {
                                                      parentCommentIdToReply =
                                                          snapshot.data![index]
                                                              .parentId;
                                                      textController.text = '';
                                                      submitIcon = Image(
                                                        image: const AssetImage(
                                                          "assets/images/icons/submit_inactive.png",
                                                        ),
                                                        width: min(20.w, 30),
                                                        height: min(20.w, 30),
                                                      );
                                                    });
                                                  },
                                                  requestCommentsUpdate: () {
                                                    setState(() {
                                                      futureCozyLog =
                                                          CozyLogApiService()
                                                              .getCozyLog(
                                                                  context,
                                                                  widget.id);
                                                      futureComments =
                                                          CozyLogCommentApiService()
                                                              .getCozyLogComments(
                                                                  context,
                                                                  widget.id);
                                                    });
                                                  },
                                                  onCommentUpdate:
                                                      (CozyLogComment comment) {
                                                    setState(() {
                                                      commentIdToUpdate =
                                                          comment.commentId;
                                                      textController.text =
                                                          comment.content;
                                                      submitIcon = Image(
                                                        image: const AssetImage(
                                                          "assets/images/icons/submit_active.png",
                                                        ),
                                                        width: min(20.w, 30),
                                                        height: min(20.w, 30),
                                                      );
                                                    });
                                                  }),
                                              SizedBox(height: 15.w),
                                            ],
                                          );
                                        } else {
                                          return Container();
                                        }
                                      },
                                    ),
                                  );
                                } else {
                                  return Container();
                                }
                              }),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(
                      left: 25.w, right: 25.w, bottom: 25.w, top: 15.w),
                  decoration: const BoxDecoration(
                    color: Colors.white, // 배경색 설정
                  ),
                  child: Container(
                    width: screenWidth - paddingValue,
                    height: 36.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.w),
                      color: const Color(0xffF7F7FA),
                    ),
                    padding: EdgeInsets.only(left: 20.w, right: 6.w),
                    child: Center(
                      child: TextField(
                        textAlignVertical: TextAlignVertical.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: min(14.sp, 24),
                        ),
                        keyboardType: TextInputType.text,
                        maxLines: 1,
                        maxLength: 250,
                        controller: textController,
                        onChanged: (text) {
                          if (text != '') {
                            setState(() {
                              commentInput = text;
                              submitIcon = Image(
                                image: const AssetImage(
                                  "assets/images/icons/submit_active.png",
                                ),
                                width: min(20.w, 30),
                                height: min(20.w, 30),
                              );
                            });
                          } else {
                            setState(() {
                              commentInput = '';
                              submitIcon = Image(
                                image: const AssetImage(
                                  "assets/images/icons/submit_inactive.png",
                                ),
                                width: min(20.w, 30),
                                height: min(20.w, 30),
                              );
                            });
                          }
                        },
                        cursorHeight: AppUtils.scaleSize(context, 14.5),
                        cursorWidth: AppUtils.scaleSize(context, 1),
                        cursorColor: primaryColor,
                        decoration: InputDecoration(
                          isDense: true,
                          counterText: '',
                          hintText: parentCommentIdToReply != null
                              ? "답글을 남겨주세요."
                              : "댓글을 남겨주세요.",
                          hintStyle: TextStyle(
                            color: const Color(0xffBCC0C7),
                            fontWeight: FontWeight.w400,
                            fontSize: min(14.sp, 24),
                          ),
                          suffixIcon: GestureDetector(
                            onTap: () async {
                              if (commentInput != '') {
                                if (commentIdToUpdate == null) {
                                  await CozyLogCommentApiService().postComment(
                                    context,
                                    widget.id,
                                    parentCommentIdToReply,
                                    commentInput,
                                  );
                                  reloadCozyLog();
                                } else {
                                  await CozyLogCommentApiService()
                                      .updateComment(
                                    context,
                                    widget.id,
                                    commentIdToUpdate!,
                                    parentCommentIdToReply,
                                    commentInput,
                                  );
                                }
                                if (mounted) {
                                  await CompleteAlertModal.showCompleteDialog(
                                      context, '댓글이', '등록');
                                }
                                setState(() {
                                  textController.text = '';
                                  futureComments = CozyLogCommentApiService()
                                      .getCozyLogComments(context, widget.id);
                                  parentCommentIdToReply = null;
                                });
                              }
                            },
                            child: Padding(
                              padding: EdgeInsets.all(8.w),
                              child: submitIcon,
                            ),
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return const Center(
              child: CircularProgressIndicator(
            backgroundColor: primaryColor,
            color: Colors.white,
          ));
        }
      },
    );
  }
}
