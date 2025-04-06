import 'dart:math';

import 'package:cozy_for_mom_frontend/screen/tab/cozylog/cozylog_detail_screen.dart';
import 'package:cozy_for_mom_frontend/screen/tab/cozylog/cozylog_model.dart';
import 'package:cozy_for_mom_frontend/service/cozylog/cozylog_api_service.dart';
import 'package:cozy_for_mom_frontend/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/common/widget/select_bottom_modal.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:cozy_for_mom_frontend/screen/tab/community/image_text_card.dart';
import 'package:cozy_for_mom_frontend/service/image_api.dart';
import 'package:provider/provider.dart';

class CozylogEditPage extends StatefulWidget {
  final int id;
  const CozylogEditPage({
    super.key,
    required this.id,
  });

  @override
  State<CozylogEditPage> createState() => _CozylogEditPageState();
}

class _CozylogEditPageState extends State<CozylogEditPage> {
  late Future<CozyLog?> futureCozyLog;
  Color bottomLineColor = mainLineColor;

  late TextEditingController titleController;
  late TextEditingController contentController;

  ScrollController scrollController = ScrollController();
  ImageApiService imageApiService = ImageApiService();
  FocusNode focusNode = FocusNode();

  bool isRegisterButtonEnabled() {
    return titleController.text.isNotEmpty && contentController.text.isNotEmpty;
  }

  File? selectedImage;
  late CozyLogModeType mode;

  List<CozyLogImage> selectedImages = [];

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (mounted) {
      Navigator.of(context).pop();
    }

    if (mounted && pickedFile != null) {
      imageApiService.uploadImage(context, pickedFile).then((value) => {
            setState(() {
              selectedImages.add(CozyLogImage(
                imageId: null, // Set appropriate ID if needed
                imageUrl: value!, // Use path as URL for simplicity
                description: "",
              ));
            })
          });
    }
  }

  void _moveUp(int index) {
    if (index > 0) {
      setState(() {
        final temp = selectedImages[index - 1];
        selectedImages[index - 1] = selectedImages[index];
        selectedImages[index] = temp;
      });
    }
  }

  void _moveDown(int index) {
    if (index < selectedImages.length - 1) {
      setState(() {
        final temp = selectedImages[index + 1];
        selectedImages[index + 1] = selectedImages[index];
        selectedImages[index] = temp;
      });
    }
  }

  void _deleteImage(int index) {
    setState(() {
      selectedImages.removeAt(index);
    });
  }

  void _updateDescription(int index, String description) {
    setState(() {
      selectedImages[index].description = description;
    });
  }

  @override
  void initState() {
    super.initState();
    futureCozyLog = CozyLogApiService().getCozyLog(context, widget.id);
    futureCozyLog.then((cozyLog) => {
          setState(() {
            titleController = TextEditingController(text: cozyLog!.title);
            contentController = TextEditingController(text: cozyLog.content);
            mode = cozyLog.mode;
            selectedImages = cozyLog.imageList;
          })
        });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final keyboardPadding = MediaQuery.of(context).viewInsets.bottom;
    final isTablet = screenWidth > 600;
    final paddingValue = isTablet ? 30.w : 20.w;

    final cozylogProvider =
        Provider.of<CozyLogApiService>(context, listen: false);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: backgroundColor,
      body: FutureBuilder(
        future: futureCozyLog,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final cozyLog = snapshot.data!;
            return SizedBox(
              height: screenHeight,
              child: Stack(
                children: [
                  Positioned(
                    top: isTablet ? 17.h : 47.h,
                    left: 0.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 10.w, vertical: 10.h),
                      width: screenWidth,
                      height: 52.w,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: min(32.w, 42),
                            height: min(32.w, 42),
                          ),
                          Text(
                            '글쓰기',
                            style: TextStyle(
                                color: mainTextColor,
                                fontWeight: FontWeight.w600,
                                fontSize: min(18.sp, 28)),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Icon(
                              Icons.close,
                              size: min(28.w, 38),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 132.h,
                    left: paddingValue,
                    child: SizedBox(
                      width: screenWidth - 2 * paddingValue,
                      height: 52.w,
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        controller: titleController,
                        textAlign: TextAlign.start,
                        maxLength: 38,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: min(20.sp, 30),
                        ),
                        cursorColor: primaryColor,
                        cursorHeight: AppUtils.scaleSize(context, 21),
                        cursorWidth: AppUtils.scaleSize(context, 1.5),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          counterText: '',
                          hintText: "제목을 입력해주세요",
                          hintStyle: TextStyle(
                            color: offButtonTextColor,
                            fontWeight: FontWeight.w500,
                            fontSize: min(20.sp, 30),
                          ),
                        ),
                        onChanged: (text) {
                          setState(() {
                            if (text.isNotEmpty) {
                              bottomLineColor = primaryColor;
                            } else {
                              bottomLineColor = mainLineColor;
                            }
                          });
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    top: 182.h,
                    left: paddingValue,
                    child: Container(
                      width: screenWidth - 2 * paddingValue,
                      height: 1.5.w,
                      color: bottomLineColor,
                    ),
                  ),
                  Positioned(
                      top: 217.h,
                      left: paddingValue,
                      child: Container(
                        width: screenWidth - 2 * paddingValue,
                        height: screenHeight * 0.59,
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.w, vertical: isTablet ? 15.w : 20.w),
                        decoration: BoxDecoration(
                            color: contentBoxTwoColor,
                            borderRadius: BorderRadius.circular(20.w)),

                        child: GestureDetector(
                          onTap: () {
                            // 키보드가 활성화 상태인지 체크하고 키보드를 내린다.
                            FocusScopeNode currentFocus =
                                FocusScope.of(context);
                            if (!currentFocus.hasPrimaryFocus) {
                              currentFocus.unfocus();
                            }
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: screenHeight * 0.48,
                                padding: EdgeInsets.only(
                                    bottom: keyboardPadding / 2),
                                child: Scrollbar(
                                  // 스크롤바 표현
                                  controller: scrollController,
                                  trackVisibility: true,
                                  thickness: 5.0,
                                  radius: Radius.circular(10.w),
                                  child: SingleChildScrollView(
                                    physics: ClampingScrollPhysics(),
                                    controller: scrollController,
                                    scrollDirection: Axis.vertical,
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          width: screenWidth - 2 * paddingValue,
                                          child: TextFormField(
                                            focusNode: focusNode,
                                            keyboardType:
                                                TextInputType.multiline,
                                            controller: contentController,
                                            textAlignVertical:
                                                TextAlignVertical.center,
                                            textAlign: TextAlign.start,
                                            maxLines: null,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                              fontSize: min(14.sp, 24),
                                              height: min(1.5.w, 1.5),
                                            ),
                                            cursorColor: primaryColor,
                                            cursorHeight:
                                                AppUtils.scaleSize(context, 14),
                                            cursorWidth: AppUtils.scaleSize(
                                                context, 1.5),
                                            decoration: InputDecoration(
                                              isDense: true,
                                              contentPadding: EdgeInsets.zero,
                                              border: InputBorder.none,
                                              hintText: "오늘 하루는 어땠나요?",
                                              hintStyle: TextStyle(
                                                color: offButtonTextColor,
                                                fontWeight: FontWeight.w500,
                                                fontSize: min(14.sp, 24),
                                              ),
                                            ),
                                            onChanged: (text) {
                                              setState(() {});
                                            },
                                          ),
                                        ),
                                        ...selectedImages
                                            .asMap()
                                            .entries
                                            .map((entry) {
                                          int index = entry.key;
                                          CozyLogImage image = entry.value;
                                          return Column(
                                            children: [
                                              SizedBox(height: 10.w),
                                              ImageTextCard(
                                                key: ValueKey(image.imageUrl),
                                                image: image,
                                                onMoveUp: () => _moveUp(index),
                                                onMoveDown: () =>
                                                    _moveDown(index),
                                                onDelete: () =>
                                                    _deleteImage(index),
                                                onDescriptionChanged:
                                                    (description) =>
                                                        _updateDescription(
                                                            index, description),
                                              ),
                                              SizedBox(height: 10.w),
                                            ],
                                          );
                                        }).toList(),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: min(85.w, 115),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        showModalBottomSheet(
                                          context: context,
                                          backgroundColor: Colors.transparent,
                                          elevation: 0.0,
                                          builder: (BuildContext context) {
                                            return SelectBottomModal(
                                                selec1: '직접 찍기',
                                                selec2: '앨범에서 선택',
                                                tap1: () {
                                                  _pickImage(
                                                      ImageSource.camera);
                                                },
                                                tap2: () {
                                                  _pickImage(
                                                      ImageSource.gallery);
                                                });
                                          },
                                        );
                                      },
                                      child: Image(
                                          image: const AssetImage(
                                              'assets/images/icons/gallery.png'),
                                          width: min(36.w, 46),
                                          height: min(36.w, 46)),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        showModalBottomSheet(
                                          context: context,
                                          backgroundColor: Colors.transparent,
                                          elevation: 0.0,
                                          builder: (BuildContext context) {
                                            return SelectBottomModal(
                                              selec1: '공개',
                                              selec2: '비공개',
                                              tap1: () {
                                                setState(() {
                                                  mode = CozyLogModeType.public;
                                                });
                                                Navigator.pop(context);
                                              },
                                              tap2: () {
                                                setState(() {
                                                  mode =
                                                      CozyLogModeType.private;
                                                });
                                                Navigator.pop(context);
                                              },
                                            );
                                          },
                                        );
                                      },
                                      child: Image(
                                          image: AssetImage(
                                            mode == CozyLogModeType.private
                                                ? 'assets/images/icons/cozylog_private.png'
                                                : 'assets/images/icons/cozylog_public.png',
                                          ),
                                          width: min(36.w, 46),
                                          height: min(36.w, 46)),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        // ),
                      )),
                  Positioned(
                    bottom: 0.h,
                    child: InkWell(
                      onTap: () {
                        if (isRegisterButtonEnabled()) {
                          CozyLogApiService()
                              .updateCozyLog(
                                context,
                                cozyLog.cozyLogId!,
                                titleController.text,
                                contentController.text,
                                selectedImages,
                                mode,
                              )
                              .then(
                                (value) => {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CozyLogDetailScreen(
                                        id: value!,
                                      ),
                                    ),
                                  ).then((value) {
                                    if (value == true) {
                                      Navigator.pop(context,
                                          true); // true를 반환하여 목록 화면에서 업데이트를 트리거
                                    }
                                  })
                                },
                              );
                        }
                      },
                      child: Container(
                        width: screenWidth,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter, // 그라데이션 시작점
                            end: Alignment.topCenter, // 그라데이션 끝점
                            colors: [
                              Colors.white, // 시작 색상
                              Colors.white.withOpacity(0.0), // 끝 색상
                            ],
                          ),
                        ),
                        padding: EdgeInsets.only(
                            top: 20.w, bottom: 54.w - paddingValue),
                        child: Container(
                          height: min(56.w, 96),
                          margin:
                              EdgeInsets.symmetric(horizontal: paddingValue),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: isRegisterButtonEnabled()
                                  ? primaryColor
                                  : const Color(0xffC9DFF9),
                              borderRadius: BorderRadius.circular(12.w)),
                          child: Text("작성 완료",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: min(16.sp, 26))),
                        ),
                      ),
                    ),
                  )
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
      ),
    );
  }
}
