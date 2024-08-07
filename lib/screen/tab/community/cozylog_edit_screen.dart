import 'package:cozy_for_mom_frontend/screen/tab/cozylog/cozylog_detail_screen.dart';
import 'package:cozy_for_mom_frontend/screen/tab/cozylog/cozylog_model.dart';
import 'package:cozy_for_mom_frontend/service/cozylog/cozylog_api_service.dart';
import 'package:flutter/material.dart';
import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/common/widget/select_bottom_modal.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:cozy_for_mom_frontend/screen/tab/community/image_text_card.dart';
import 'package:cozy_for_mom_frontend/service/image_api.dart';

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
  late Future<CozyLog> futureCozyLog;
  Color bottomLineColor = mainLineColor;

  late TextEditingController titleController;
  late TextEditingController contentController;

  ScrollController scrollController = ScrollController();
  ImageApiService imageApiService = ImageApiService();
  FocusNode focusNode = FocusNode();

  bool isRegisterButtonEnabled() {
    return titleController.text.isNotEmpty || contentController.text.isNotEmpty;
  }

  File? selectedImage;
  late CozyLogModeType mode;

  List<CozyLogImage> selectedImages = [];

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    Navigator.of(context).pop();

    if (pickedFile != null) {
      setState(() {
        selectedImages.add(CozyLogImage(
          imageId: null, // Set appropriate ID if needed
          imageUrl: pickedFile.path, // Use path as URL for simplicity
          description: "",
        ));
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
    futureCozyLog = CozyLogApiService().getCozyLog(widget.id);
    futureCozyLog.then((cozyLog) => {
          setState(() {
            titleController = TextEditingController(text: cozyLog.title);
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
                    top: 62,
                    left: 0,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      width: screenWidth,
                      height: 52,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(
                            width: 32,
                            height: 32,
                          ),
                          const Text(
                            '글쓰기',
                            style: TextStyle(
                                color: mainTextColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 18),
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
                    top: 132,
                    left: 20,
                    child: SizedBox(
                      width: screenWidth - 40,
                      height: 52,
                      child: TextFormField(
                        controller: titleController,
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                        ),
                        cursorColor: primaryColor,
                        cursorHeight: 21,
                        cursorWidth: 1.5,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "제목을 입력해주세요",
                          hintStyle: TextStyle(
                            color: offButtonTextColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
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
                    top: 182,
                    left: 20,
                    child: Container(
                      width: screenWidth - 40,
                      height: 1.5,
                      color: bottomLineColor,
                    ),
                  ),
                  Positioned(
                      top: 217,
                      left: 20,
                      child: Container(
                        width: screenWidth - 40,
                        height: screenHeight - 360,
                        padding: const EdgeInsets.only(
                            left: 25, right: 15, top: 20, bottom: 20),
                        decoration: BoxDecoration(
                            color: contentBoxTwoColor,
                            borderRadius: BorderRadius.circular(20)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.only(bottom: 10),
                              width: screenWidth - 80,
                              height: (screenHeight - 360 - 40 - 36 - 70) /
                                  2, // TODO 텍스트필드와 이미지 카드 개수 및 배치 논의 후, 수정
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: TextFormField(
                                  controller: contentController,
                                  textAlignVertical: TextAlignVertical.top,
                                  textAlign: TextAlign.start,
                                  maxLines: null,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                    height: 1.5,
                                  ),
                                  cursorColor: primaryColor,
                                  cursorHeight: 15,
                                  cursorWidth: 1.5,
                                  decoration: const InputDecoration(
                                    isDense: true,
                                    contentPadding: EdgeInsets.zero,
                                    border: InputBorder.none,
                                    hintText: "오늘 하루는 어땠나요?",
                                    hintStyle: TextStyle(
                                      color: offButtonTextColor,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                    ),
                                  ),
                                  onChanged: (text) {
                                    setState(() {});
                                  },
                                ),
                              ),
                            ),
                            ...selectedImages.asMap().entries.map((entry) {
                              int index = entry.key;
                              CozyLogImage image = entry.value;
                              return Column(
                                children: [
                                  ImageTextCard(
                                    image: image,
                                    onMoveUp: () => _moveUp(index),
                                    onMoveDown: () => _moveDown(index),
                                    onDelete: () => _deleteImage(index),
                                    onDescriptionChanged: (description) => _updateDescription(index, description),
                                  ),
                                  const SizedBox(height: 10),
                                ],
                              );
                            }).toList(),
                            SizedBox(
                              width: 85,
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
                                          return SelectBottomModal(
                                            selec1: '직접 찍기',
                                            selec2: '앨범에서 선택',
                                            tap1: () {
                                              print(
                                                '카메라 구현',
                                              ); // TODO 카메라 연동 구현
                                            },
                                            tap2: _pickImage,
                                          );
                                        },
                                      );
                                    },
                                    child: const Image(
                                        image: AssetImage(
                                            'assets/images/icons/gallery.png'),
                                        width: 36,
                                        height: 36),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      showModalBottomSheet(
                                        context: context,
                                        backgroundColor: Colors.transparent,
                                        builder: (BuildContext context) {
                                          return SelectBottomModal(
                                            selec1: '공개',
                                            selec2: '비공개',
                                            tap1: () {
                                              mode = CozyLogModeType.public;
                                              Navigator.pop(context);
                                            },
                                            tap2: () {
                                              mode = CozyLogModeType.private;
                                              Navigator.pop(context);
                                            },
                                          );
                                        },
                                      );
                                    },
                                    child: Image(
                                      image: AssetImage(
                                        mode == CozyLogModeType.private ? 'assets/images/icons/cozylog_private.png' : 'assets/images/icons/cozylog_public.png'
                                        ),
                                    width: 36,
                                      height: 36,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      )),
                  Positioned(
                    top: 755,
                    left: 20,
                    child: InkWell(
                      onTap: () {
                        final cozyLogId = CozyLogApiService()
                            .updateCozyLog(
                              cozyLog.cozyLogId!,
                              titleController.text,
                              contentController.text,
                              [],
                              mode,
                            )
                            .then(
                              (value) => {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CozyLogDetailScreen(
                                      id: value,
                                    ),
                                  ),
                                )
                              },
                            );
                      },
                      child: Container(
                        width: screenWidth - 40,
                        height: 56,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: isRegisterButtonEnabled()
                                ? primaryColor
                                : const Color(0xffC9DFF9),
                            borderRadius: BorderRadius.circular(12)),
                        child: const Text(
                          "작성 완료",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          } else {
            return const Text("없는 게시물입니다"); // TODO 핸들링
          }
        },
      ),
    );
  }
}
