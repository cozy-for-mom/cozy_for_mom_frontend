import 'package:flutter/material.dart';
import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'dart:io';

class ImageTextCard extends StatefulWidget {
  final File? image;
  const ImageTextCard({super.key, required this.image});

  @override
  State<ImageTextCard> createState() => _ImageTextCardState();
}

class _ImageTextCardState extends State<ImageTextCard> {
  bool imageDelete = false;
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return imageDelete
        ? Container()
        : Container(
            width: screenWidth - 80,
            decoration: const BoxDecoration(
              color: contentBoxTwoColor,
            ),
            child: Row(
              children: [
                Stack(
                  children: [
                    SizedBox(
                      width: 69,
                      height: 69,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(widget.image!, fit: BoxFit.fill),
                      ),
                    ),
                    Positioned(
                      top: 52,
                      left: 5,
                      child: SizedBox(
                          width: 60,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () {
                                  print('up 버튼 클릭'); // TODO 위로가기 버튼 실핸문 구현
                                },
                                child: const Image(
                                    width: 10,
                                    height: 10,
                                    image: AssetImage(
                                        'assets/images/icons/image_up.png')),
                              ),
                              InkWell(
                                onTap: () {
                                  print('down 버튼 클릭'); // TODO 아래로가기 버튼 실핸문 구현
                                },
                                child: const Image(
                                    width: 10,
                                    height: 10,
                                    image: AssetImage(
                                        'assets/images/icons/image_down.png')),
                              ),
                              InkWell(
                                onTap: () {
                                  print('삭제 버튼 클릭'); // TODO 삭제 버튼 실핸문 구현
                                  setState(() {
                                    imageDelete = true;
                                  });
                                },
                                child: const Image(
                                    width: 10,
                                    height: 10,
                                    image: AssetImage(
                                        'assets/images/icons/image_delete.png')),
                              ),
                            ],
                          )),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.only(left: 15),
                  width: screenWidth - 80 - 70 - 15,
                  height: 60,
                  child: TextFormField(
                    textAlignVertical: TextAlignVertical.top,
                    textAlign: TextAlign.start,
                    maxLines: 3,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                      height: 1.5,
                    ),
                    cursorColor: primaryColor,
                    cursorHeight: 13,
                    cursorWidth: 1.5,
                    decoration: const InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                      border: InputBorder.none,
                      hintText: "설명을 추가할 수 있어요.",
                      hintStyle: TextStyle(
                        color: offButtonTextColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
