import 'dart:math';

import 'package:cozy_for_mom_frontend/screen/tab/cozylog/cozylog_model.dart';
import 'package:cozy_for_mom_frontend/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ImageTextCard extends StatefulWidget {
  final CozyLogImage image;
  final VoidCallback onMoveUp;
  final VoidCallback onMoveDown;
  final VoidCallback onDelete;
  final ValueChanged<String> onDescriptionChanged;

  const ImageTextCard({
    super.key,
    required this.image,
    required this.onMoveUp,
    required this.onMoveDown,
    required this.onDelete,
    required this.onDescriptionChanged,
  });

  @override
  State<ImageTextCard> createState() => _ImageTextCardState();
}

class _ImageTextCardState extends State<ImageTextCard> {
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _descriptionController =
        TextEditingController(text: widget.image.description);
    _descriptionController.addListener(_onDescriptionChanged);
  }

  @override
  void dispose() {
    _descriptionController.removeListener(_onDescriptionChanged);
    _descriptionController.dispose();
    super.dispose();
  }

  void _onDescriptionChanged() {
    widget.onDescriptionChanged(_descriptionController.text);
  }

  // 이미지 description도 이미지따라 함께 이동하도록 실행하는 메서드
  @override
  void didUpdateWidget(covariant ImageTextCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.image.description != oldWidget.image.description) {
      _descriptionController.text = widget.image.description;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final paddingValue = isTablet ? 30.w : 20.w;
    return Container(
      width: screenWidth - (40.w + 2 * paddingValue),
      decoration: const BoxDecoration(
        color: contentBoxTwoColor,
      ),
      child: Row(
        children: [
          Stack(
            children: [
              SizedBox(
                width: min(69.w, 109),
                height: min(69.w, 109),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.w),
                  child: Image.network(widget.image.imageUrl, fit: BoxFit.fill),
                ),
              ),
              Positioned(
                top: 52.h,
                left: 0.w,
                right: 0.w,
                child: SizedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                        onTap: widget.onMoveUp,
                        child: Image(
                          width: min(10.w, 18),
                          height: min(10.w, 18),
                          image: const AssetImage(
                              'assets/images/icons/image_up.png'),
                        ),
                      ),
                      InkWell(
                        onTap: widget.onMoveDown,
                        child: Image(
                          width: min(10.w, 18),
                          height: min(10.w, 18),
                          image: const AssetImage(
                              'assets/images/icons/image_down.png'),
                        ),
                      ),
                      InkWell(
                        onTap: widget.onDelete,
                        child: Image(
                          width: min(10.w, 18),
                          height: min(10.w, 18),
                          image: const AssetImage(
                              'assets/images/icons/image_delete.png'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.only(left: 15.w),
            width: screenWidth - 165.w,
            height: min(60.w, 100),
            child: TextFormField(
              controller: _descriptionController,
              // initialValue: widget.image.description,
              // onChanged: widget.onDescriptionChanged,
              textAlignVertical: TextAlignVertical.center,
              textAlign: TextAlign.start,
              maxLines: 3,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: min(12.sp, 22),
                height: min(1.5.w, 1.5),
              ),
              cursorColor: primaryColor,
              cursorHeight: AppUtils.scaleSize(context, 12),
              cursorWidth: AppUtils.scaleSize(context, 1.5),
              decoration: InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.zero,
                border: InputBorder.none,
                hintText: "설명을 추가할 수 있어요.",
                hintStyle: TextStyle(
                  color: offButtonTextColor,
                  fontWeight: FontWeight.w500,
                  fontSize: min(12.sp, 22),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
