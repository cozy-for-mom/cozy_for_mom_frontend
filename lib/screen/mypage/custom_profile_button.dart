import 'dart:math';

import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/screen/mypage/baby_register_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomProfileButton extends StatefulWidget {
  final String text;
  final String imagePath;
  final Color offBackColor;
  final void Function() onPressed;
  final bool isSelected;
  final bool isEditMode;
  final int babyProfileId;
  final Function()? onProfileUpdated;

  CustomProfileButton(
      {required this.text,
      required this.imagePath,
      required this.offBackColor,
      required this.onPressed,
      required this.isSelected,
      this.isEditMode = false,
      this.babyProfileId = -1,
      this.onProfileUpdated});
  @override
  _CustomProfileButtonState createState() => _CustomProfileButtonState();
}

class _CustomProfileButtonState extends State<CustomProfileButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onPressed,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Stack(
              alignment: Alignment.center, // 모든 자식을 중앙에 배치
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50.w),
                    border: widget.isSelected
                        ? Border.all(width: 2.w, color: primaryColor)
                        : widget.isEditMode
                            ? Border.all(
                                width: 2.w, color: const Color(0xffC0C0C0))
                            : null,
                  ),
                  child: ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      widget.isEditMode
                          ? Colors.black.withOpacity(0.5)
                          : Colors.transparent,
                      BlendMode.srcATop,
                    ),
                    child: ClipOval(
                      child: widget.imagePath == ''
                          ? Container(
                              color: widget.isSelected
                                  ? profileColor
                                  : widget.offBackColor,
                              padding: EdgeInsets.symmetric(
                                  horizontal: min(20.w, 30), vertical: min(23.w, 33)),
                              child: Image.asset(
                                widget.isSelected
                                    ? 'assets/images/icons/babyProfileOn.png'
                                    : 'assets/images/icons/babyProfileOff.png',
                                width: min(40.w, 80),
                                height: min(35.w, 70),
                              ),
                            )
                          : Image.network(
                              widget.imagePath,
                              fit: BoxFit.fill,
                              width: min(80.w, 130),
                              height: min(80.w, 130),
                            ),
                    ),
                  ),
                ),
                // `ColorFiltered`의 영향을 받지 않는 이미지 추가
                widget.isEditMode
                    ? Positioned(
                        child: InkWell(
                          onTap: () async {
                            final res = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BabyRegisterScreen(
                                  babyProfileId: widget.babyProfileId > -1
                                      ? widget.babyProfileId
                                      : null,
                                ),
                              ),
                            );
                            if (res == true) {
                              if (widget.onProfileUpdated != null) {
                                widget.onProfileUpdated!();
                              }
                            }
                          },
                          child: Image.asset(
                              'assets/images/icons/babyprofile_modify_pen.png',
                              width: min(20.w, 30),
                              height: min(20.w, 30)),
                        ),
                      )
                    : Container(),
              ],
            ),
            SizedBox(height: 6.w),
            SizedBox(
              width: 70.w,
              child: Text(
                widget.text,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                maxLines: 1,
                style: TextStyle(
                    color:
                        widget.isSelected ? primaryColor : offButtonTextColor,
                    fontWeight: FontWeight.w600,
                    fontSize: min(14.sp, 24)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
