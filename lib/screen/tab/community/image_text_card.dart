import 'package:cozy_for_mom_frontend/screen/tab/cozylog/cozylog_model.dart';
import 'package:cozy_for_mom_frontend/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:cozy_for_mom_frontend/common/custom_color.dart';

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
    return Container(
      width: screenWidth - AppUtils.scaleSize(context, 80),
      decoration: const BoxDecoration(
        color: contentBoxTwoColor,
      ),
      child: Row(
        children: [
          Stack(
            children: [
              SizedBox(
                width: AppUtils.scaleSize(context, 69),
                height: AppUtils.scaleSize(context, 69),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(widget.image.imageUrl, fit: BoxFit.fill),
                ),
              ),
              Positioned(
                top: AppUtils.scaleSize(context, 52),
                left: AppUtils.scaleSize(context, 5),
                child: SizedBox(
                  width: AppUtils.scaleSize(context, 60),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: widget.onMoveUp,
                        child: Image(
                          width: AppUtils.scaleSize(context, 10),
                          height: AppUtils.scaleSize(context, 10),
                          image: const AssetImage(
                              'assets/images/icons/image_up.png'),
                        ),
                      ),
                      InkWell(
                        onTap: widget.onMoveDown,
                        child: Image(
                          width: AppUtils.scaleSize(context, 10),
                          height: AppUtils.scaleSize(context, 10),
                          image: const AssetImage(
                              'assets/images/icons/image_down.png'),
                        ),
                      ),
                      InkWell(
                        onTap: widget.onDelete,
                        child: Image(
                          width: AppUtils.scaleSize(context, 10),
                          height: AppUtils.scaleSize(context, 10),
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
            padding: EdgeInsets.only(left: AppUtils.scaleSize(context, 15)),
            width: screenWidth - AppUtils.scaleSize(context, 165),
            height: AppUtils.scaleSize(context, 60),
            child: TextFormField(
              controller: _descriptionController,
              // initialValue: widget.image.description,
              // onChanged: widget.onDescriptionChanged,
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
