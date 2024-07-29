import 'package:cozy_for_mom_frontend/screen/tab/cozylog/cozylog_model.dart';
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

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
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
                  child: Image.network(widget.image.imageUrl, fit: BoxFit.fill),
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
                        onTap: widget.onMoveUp,
                        child: const Image(
                          width: 10,
                          height: 10,
                          image: AssetImage('assets/images/icons/image_up.png'),
                        ),
                      ),
                      InkWell(
                        onTap: widget.onMoveDown,
                        child: const Image(
                          width: 10,
                          height: 10,
                          image:
                              AssetImage('assets/images/icons/image_down.png'),
                        ),
                      ),
                      InkWell(
                        onTap: widget.onDelete,
                        child: const Image(
                          width: 10,
                          height: 10,
                          image: AssetImage(
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
            padding: const EdgeInsets.only(left: 15),
            width: screenWidth - 80 - 70 - 15,
            height: 60,
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
