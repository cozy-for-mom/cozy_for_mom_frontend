import 'package:cozy_for_mom_frontend/utils/app_utils.dart';
import 'package:flutter/material.dart';

class RecordIcon extends StatelessWidget {
  // TODO onTap 속성 추가
  final String recordTypeName;
  final String recordTypeKorName;
  final double imageWidth;
  final double imageHeight;
  final Color backgroundColor = const Color(0xffEDF0FA);
  const RecordIcon({
    super.key,
    required this.recordTypeName,
    required this.recordTypeKorName,
    required this.imageWidth,
    required this.imageHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: AppUtils.scaleSize(context, 76),
          width: AppUtils.scaleSize(context, 76),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: const BorderRadius.all(
              Radius.circular(9),
            ),
          ),
          child: Center(
            child: Image(
              image: AssetImage(
                "assets/images/icons/icon_$recordTypeName.png",
              ),
              width: imageWidth,
              height: imageHeight,
            ),
          ),
        ),
        SizedBox(
          height: AppUtils.scaleSize(context, 7),
        ),
        Text(
          recordTypeKorName,
        ),
      ],
    );
  }
}
