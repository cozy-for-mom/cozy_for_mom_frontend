import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/screen/mypage/baby_register_screen.dart';
import 'package:cozy_for_mom_frontend/utils/app_utils.dart';
import 'package:flutter/material.dart';

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
        padding:
            EdgeInsets.symmetric(horizontal: AppUtils.scaleSize(context, 12)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Stack(
              alignment: Alignment.center, // 모든 자식을 중앙에 배치
              children: <Widget>[
                ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    widget.isEditMode && !widget.isSelected
                        ? Colors.black.withOpacity(0.5)
                        : Colors.transparent,
                    BlendMode.srcATop,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: widget.isSelected
                          ? Border.all(width: 2, color: primaryColor)
                          : null,
                      color: widget.isSelected
                          ? profileColor
                          : widget.offBackColor,
                    ),
                    child: widget.imagePath == ''
                        ? Padding(
                            padding:
                                EdgeInsets.all(AppUtils.scaleSize(context, 16)),
                            child: Image.asset(
                              'assets/images/icons/babyProfileOn.png',
                              width: AppUtils.scaleSize(context, 45),
                              height: AppUtils.scaleSize(context, 45),
                            ),
                          )
                        : ClipOval(
                            child: Image.network(
                              widget.imagePath,
                              fit: BoxFit.cover,
                              width: AppUtils.scaleSize(context, 82),
                              height: AppUtils.scaleSize(context, 82),
                            ),
                          ),
                  ),
                ),
                // `ColorFiltered`의 영향을 받지 않는 이미지 추가
                widget.isEditMode && !widget.isSelected
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
                            'assets/images/icons/babyprofile_modify_pen.png', // TODO 클릭했을떄 편집 화면으로..
                            width: AppUtils.scaleSize(context, 20),
                            height: AppUtils.scaleSize(context, 20),
                          ),
                        ),
                      )
                    : Container(),
              ],
            ),
            SizedBox(height: AppUtils.scaleSize(context, 6)),
            SizedBox(
              width: AppUtils.scaleSize(context, 70),
              child: Text(
                widget.text,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                maxLines: 1,
                style: TextStyle(
                    color:
                        widget.isSelected ? primaryColor : offButtonTextColor,
                    fontWeight: FontWeight.w600,
                    fontSize: AppUtils.scaleSize(context, 14)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
