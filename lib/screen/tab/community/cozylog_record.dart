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

class CozylogRecordPage extends StatefulWidget {
  const CozylogRecordPage({super.key});

  @override
  State<CozylogRecordPage> createState() => _CozylogRecordPageState();
}

class _CozylogRecordPageState extends State<CozylogRecordPage> {
  CozyLogApiService cozyLogApiService = CozyLogApiService();
  Color bottomLineColor = mainLineColor;
  TextEditingController titleController = TextEditingController();
  ScrollController scrollController = ScrollController();
  TextEditingController contentController = TextEditingController();
  ImageApiService imageApiService = ImageApiService();
  FocusNode focusNode = FocusNode();

  bool isRegisterButtonEnabled() {
    return titleController.text.isNotEmpty && contentController.text.isNotEmpty;
  }

  CozyLogModeType mode = CozyLogModeType.public;
  File? selectedImage;
  List<CozyLogImage> selectedImages = [];

  void _scrollToBottom() {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (mounted) {
      Navigator.of(context).pop();
    }

    if (pickedFile != null) {
      imageApiService.uploadImage(pickedFile).then((value) => {
            setState(() {
              selectedImages.add(CozyLogImage(
                imageId:
                    null, // Set appropriate ID if needed # TODO id를 어떻게 설정할지?
                imageUrl: value!, // Use path as URL for simplicity
                description: "",
              ));
            })
          });
    }
  }

  void _updateDescription(int index, String description) {
    setState(() {
      selectedImages[index].description = description;
    });
  }

  void _moveUp(int index) {
    if (index > 0) {
      final tempImages = selectedImages;
      final temp = selectedImages[index - 1];
      tempImages[index - 1] = tempImages[index];
      tempImages[index] = temp;

      setState(() {
        selectedImages = tempImages
            .map((e) => CozyLogImage(
                imageId: e.imageId,
                imageUrl: e.imageUrl,
                description: e.description))
            .toList();
      });
    }
  }

  void _moveDown(int index) {
    if (index < selectedImages.length - 1) {
      final tempImages = selectedImages;
      final temp = selectedImages[index + 1];
      tempImages[index + 1] = tempImages[index];
      tempImages[index] = temp;

      setState(() {
        selectedImages = tempImages
            .map((e) => CozyLogImage(
                imageId: e.imageId,
                imageUrl: e.imageUrl,
                description: e.description))
            .toList();
      });
    }
  }

  void _deleteImage(int index) {
    setState(() {
      selectedImages.removeAt(index);
    });
  }

  @override
  void initState() {
    super.initState();
    contentController.addListener(_scrollToBottom);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: backgroundColor,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SizedBox(
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
                      keyboardType: TextInputType.text,
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
                                      padding:
                                          const EdgeInsets.only(bottom: 20),
                                      width: screenWidth - 80,
                                      child: TextFormField(
                                        focusNode: focusNode,
                                        keyboardType: TextInputType.multiline,
                                        controller: contentController,
                                        textAlignVertical:
                                            TextAlignVertical.top,
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
                                            onMoveDown: () => _moveDown(index),
                                            onDelete: () => _deleteImage(index),
                                            onDescriptionChanged:
                                                (description) =>
                                                    _updateDescription(
                                                        index, description),
                                          ),
                                          const SizedBox(height: 10),
                                        ],
                                      );
                                    }).toList(),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 85,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () {
                                    showModalBottomSheet(
                                      context: context,
                                      backgroundColor: Colors.transparent,
                                      builder: (BuildContext context) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 18.0),
                                          child: SelectBottomModal(
                                              selec1: '직접 찍기',
                                              selec2: '앨범에서 선택',
                                              tap1: () {
                                                _pickImage(ImageSource.camera);
                                              },
                                              tap2: () {
                                                _pickImage(ImageSource.gallery);
                                              }),
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
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 18.0),
                                          child: SelectBottomModal(
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
                                                mode = CozyLogModeType.private;
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
                                      width: 36,
                                      height: 36),
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
                      cozyLogApiService
                          .createCozyLog(titleController.text,
                              contentController.text, selectedImages, mode)
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
                      child: const Text("작성 완료",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 16)),
                    ),
                  ),
                )
              ],
            )),
      ),
    );
  }
}
