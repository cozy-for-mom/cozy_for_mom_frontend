import 'package:cozy_for_mom_frontend/screen/tab/cozylog/cozylog_detail_screen.dart';
import 'package:cozy_for_mom_frontend/screen/tab/cozylog/cozylog_model.dart';
import 'package:cozy_for_mom_frontend/service/cozylog/cozylog_api_service.dart';
import 'package:cozy_for_mom_frontend/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/common/widget/select_bottom_modal.dart';
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

    final cozylogProvider =
        Provider.of<CozyLogApiService>(context, listen: false);

    return Scaffold(
      resizeToAvoidBottomInset: true,
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
                    top: AppUtils.scaleSize(context, 62),
                    left: 0,
                    child: Container(
                      padding: EdgeInsets.all(AppUtils.scaleSize(context, 10)),
                      width: screenWidth,
                      height: AppUtils.scaleSize(context, 52),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: AppUtils.scaleSize(context, 32),
                            height: AppUtils.scaleSize(context, 32),
                          ),
                          Text(
                            '글쓰기',
                            style: TextStyle(
                                color: mainTextColor,
                                fontWeight: FontWeight.w600,
                                fontSize: AppUtils.scaleSize(context, 18)),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: const Icon(Icons.close, size: 32),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: AppUtils.scaleSize(context, 132),
                    left: AppUtils.scaleSize(context, 20),
                    child: SizedBox(
                      width: screenWidth - AppUtils.scaleSize(context, 40),
                      height: AppUtils.scaleSize(context, 52),
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        controller: titleController,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: AppUtils.scaleSize(context, 20),
                        ),
                        cursorColor: primaryColor,
                        cursorHeight: AppUtils.scaleSize(context, 21),
                        cursorWidth: AppUtils.scaleSize(context, 1.5),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "제목을 입력해주세요",
                          hintStyle: TextStyle(
                            color: offButtonTextColor,
                            fontWeight: FontWeight.w500,
                            fontSize: AppUtils.scaleSize(context, 20),
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
                    top: AppUtils.scaleSize(context, 182),
                    left: AppUtils.scaleSize(context, 20),
                    child: Container(
                      width: screenWidth - AppUtils.scaleSize(context, 40),
                      height: AppUtils.scaleSize(context, 1.5),
                      color: bottomLineColor,
                    ),
                  ),
                  Positioned(
                      top: AppUtils.scaleSize(context, 217),
                      left: AppUtils.scaleSize(context, 20),
                      child: Container(
                        width: screenWidth - AppUtils.scaleSize(context, 40),
                        height: screenHeight - AppUtils.scaleSize(context, 360),
                        padding: EdgeInsets.only(
                            left: AppUtils.scaleSize(context, 25),
                            right: AppUtils.scaleSize(context, 15),
                            top: AppUtils.scaleSize(context, 20),
                            bottom: AppUtils.scaleSize(context, 20)),
                        decoration: BoxDecoration(
                            color: contentBoxTwoColor,
                            borderRadius: BorderRadius.circular(20)),

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
                              SizedBox(
                                height: screenHeight * 0.48,
                                child: Scrollbar(
                                  // 스크롤바 표현
                                  trackVisibility: true,
                                  thickness: 5.0,
                                  radius: const Radius.circular(10),

                                  child: SingleChildScrollView(
                                    controller: scrollController,
                                    scrollDirection: Axis.vertical,
                                    child: Column(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.only(
                                              bottom: AppUtils.scaleSize(
                                                  context, 20)),
                                          width: screenWidth -
                                              AppUtils.scaleSize(context, 80),
                                          child: TextFormField(
                                            focusNode: focusNode,
                                            keyboardType:
                                                TextInputType.multiline,
                                            controller: contentController,
                                            textAlignVertical:
                                                TextAlignVertical.top,
                                            textAlign: TextAlign.start,
                                            maxLines: null,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                              fontSize: AppUtils.scaleSize(
                                                  context, 14),
                                              height: AppUtils.scaleSize(
                                                  context, 1.5),
                                            ),
                                            cursorColor: primaryColor,
                                            cursorHeight:
                                                AppUtils.scaleSize(context, 15),
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
                                                fontSize: AppUtils.scaleSize(
                                                    context, 14),
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
                                              SizedBox(
                                                  height: AppUtils.scaleSize(
                                                      context, 10)),
                                            ],
                                          );
                                        }).toList(),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: AppUtils.scaleSize(context, 85),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        showModalBottomSheet(
                                          context: context,
                                          backgroundColor: Colors.transparent,
                                          builder: (BuildContext context) {
                                            return Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal:
                                                      AppUtils.scaleSize(
                                                          context, 18)),
                                              child: SelectBottomModal(
                                                  selec1: '직접 찍기',
                                                  selec2: '앨범에서 선택',
                                                  tap1: () {
                                                    _pickImage(
                                                        ImageSource.camera);
                                                  },
                                                  tap2: () {
                                                    _pickImage(
                                                        ImageSource.gallery);
                                                  }),
                                            );
                                          },
                                        );
                                      },
                                      child: Image(
                                          image: const AssetImage(
                                              'assets/images/icons/gallery.png'),
                                          width:
                                              AppUtils.scaleSize(context, 36),
                                          height:
                                              AppUtils.scaleSize(context, 36)),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        showModalBottomSheet(
                                          context: context,
                                          backgroundColor: Colors.transparent,
                                          builder: (BuildContext context) {
                                            return Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal:
                                                      AppUtils.scaleSize(
                                                          context, 18)),
                                              child: SelectBottomModal(
                                                selec1: '공개',
                                                selec2: '비공개',
                                                tap1: () {
                                                  setState(() {
                                                    mode =
                                                        CozyLogModeType.public;
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
                                              ),
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
                                          width:
                                              AppUtils.scaleSize(context, 36),
                                          height:
                                              AppUtils.scaleSize(context, 36)),
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
                    top: screenHeight - AppUtils.scaleSize(context, 80),
                    left: AppUtils.scaleSize(context, 20),
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
                        width: screenWidth - AppUtils.scaleSize(context, 40),
                        height: AppUtils.scaleSize(context, 56),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: isRegisterButtonEnabled()
                                ? primaryColor
                                : const Color(0xffC9DFF9),
                            borderRadius: BorderRadius.circular(12)),
                        child: Text(
                          "작성 완료",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: AppUtils.scaleSize(context, 16),
                          ),
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
