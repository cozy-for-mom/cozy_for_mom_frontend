// TODO 파일 제거하기

// import 'dart:async';
// import 'dart:math';

// import 'package:cozy_for_mom_frontend/screen/join/join_input_data.dart';
// import 'package:cozy_for_mom_frontend/service/user/join_api_service.dart';
// import 'package:cozy_for_mom_frontend/utils/app_utils.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:cozy_for_mom_frontend/common/custom_color.dart';

// class MomEmailInputScreen extends StatefulWidget {
//   final Function(bool) updateValidity;
//   const MomEmailInputScreen({super.key, required this.updateValidity});

//   @override
//   State<MomEmailInputScreen> createState() => _MomEmailInputScreenState();
// }

// class _MomEmailInputScreenState extends State<MomEmailInputScreen> {
//   TextEditingController textController = TextEditingController();
//   bool _isEmailValid = false;
//   bool _isInputValid = false;
//   bool? _isEmailNotDuplicated = false;
//   Timer? _debounce;

//   @override
//   void initState() {
//     super.initState();
//     final joinInputData = Provider.of<JoinInputData>(context, listen: false);
//     // 이메일 가리기 안한 경우에만 초기화
//     if (!joinInputData.email.endsWith('@privaterelay.appleid.com')) {
//       textController.text = joinInputData.email;
//     }
//     // 소셜로그인에서 받아온 이메일이 있을 경우
//     if (textController.text.isNotEmpty) {
//       initEmail(textController.text);
//     }
//   }

//   @override
//   void dispose() {
//     _debounce?.cancel();
//     textController.dispose();
//     super.dispose();
//   }

//   void initEmail(String text) async {
//     _isEmailValid = _validateEmail(text);
//     _isEmailNotDuplicated =
//         await JoinApiService().emailDuplicateCheck(context, text);
//     if (mounted) {
//       setState(() {
//         _isInputValid = text.isNotEmpty;
//         widget.updateValidity(
//             _isEmailValid && _isEmailNotDuplicated! && _isInputValid);
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final paddingValue = screenWidth > 600 ? 30.w : 20.w;
//     final joinInputData = Provider.of<JoinInputData>(context);

//     return Stack(
//       children: [
//         Positioned(
//           top: 50.h,
//           left: paddingValue,
//           child: Text('사용할 이메일을 입력해 주세요',
//               style: TextStyle(
//                   color: mainTextColor,
//                   fontWeight: FontWeight.w700,
//                   fontSize: min(26.sp, 36))),
//         ),
//         Positioned(
//           top: 95.h,
//           left: paddingValue,
//           child: Text('안심하세요! 개인정보는 외부에 공개되지 않아요.',
//               style: TextStyle(
//                   color: offButtonTextColor,
//                   fontWeight: FontWeight.w500,
//                   fontSize: min(14.sp, 24))),
//         ),
//         Positioned(
//           top: 180.h,
//           left: paddingValue,
//           child: Container(
//               width: screenWidth - 2 * paddingValue,
//               height: min(48.w, 78),
//               padding: EdgeInsets.symmetric(horizontal: min(20.w, 30)),
//               decoration: BoxDecoration(
//                   color: contentBoxTwoColor,
//                   borderRadius: BorderRadius.circular(10.w)),
//               child: Center(
//                 child: TextFormField(
//                   textAlign: TextAlign.start,
//                   controller: textController,
//                   keyboardType: TextInputType.emailAddress,
//                   cursorColor: primaryColor,
//                   maxLength: 34,
//                   cursorHeight: min(14.sp, 24),
//                   cursorWidth: 1.2.w,
//                   style: TextStyle(
//                       color: mainTextColor,
//                       fontWeight: FontWeight.w400,
//                       fontSize: min(14.sp, 24)),
//                   decoration: InputDecoration(
//                     contentPadding:
//                         EdgeInsets.symmetric(vertical: 8.w),
//                     border: InputBorder.none,
//                     hintText: 'cozy@cozy.com',
//                     hintStyle: TextStyle(
//                         color: beforeInputColor,
//                         fontWeight: FontWeight.w400,
//                         fontSize: min(14.sp, 24)),
//                     counterText: '',
//                     suffixIcon: _isInputValid
//                         ? SizedBox(
//                             width: 42.w,
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceAround,
//                               children: [
//                                 InkWell(
//                                   onTap: () {
//                                     if (mounted) {
//                                       setState(() {
//                                         joinInputData.setEmail('');
//                                         textController.clear();
//                                         _isInputValid = !_isInputValid;
//                                         widget.updateValidity(_isInputValid);
//                                       });
//                                     }
//                                   },
//                                   child: Image(
//                                     image: const AssetImage(
//                                         'assets/images/icons/text_delete.png'),
//                                     width: min(16.w, 26),
//                                     height: min(16.w, 26),
//                                   ),
//                                 ),
//                                 Image(
//                                   image: AssetImage(
//                                       _isEmailValid && _isEmailNotDuplicated!
//                                           ? 'assets/images/icons/pass.png'
//                                           : 'assets/images/icons/unpass.png'),
//                                   width: min(18.w, 28),
//                                   height: min(18.w, 28),
//                                 ),
//                               ],
//                             ),
//                           )
//                         : SizedBox(width: 42.w),
//                     suffixIconConstraints: BoxConstraints(
//                       minWidth: min(24.w, 34), // 아이콘 크기와 위치 조정
//                       minHeight: min(24.w, 34),
//                     ),
//                   ),
//                   onChanged: (value) {
//                     if (mounted) {
//                       setState(() {
//                         joinInputData.setEmail(value);
//                         if (textController.text.isEmpty) {
//                           setState(() {
//                             _isInputValid = false;
//                             widget.updateValidity(false);
//                           });
//                         } else {
//                           if (_debounce?.isActive ?? false) _debounce?.cancel();

//                           _debounce = Timer(const Duration(milliseconds: 400),
//                               () async {
//                             final atIndex = value.indexOf('@');
//                             final dotCount = value.split('').where((char) => char == '.').length;
//                             if (atIndex != -1) {
//                               final dotIndex = value.indexOf('.', atIndex);
//                               if (dotIndex != -1 &&
//                                   dotIndex + 3 <= value.length && dotCount <= 1) {  // '.' 하나 이상 입력하면 API 요청 보내지 않는다.
//                                 _isEmailNotDuplicated = await JoinApiService()
//                                     .emailDuplicateCheck(context, value);
//                               }
//                             }
//                             setState(() {
//                               _isEmailValid = _validateEmail(value);
//                               _isInputValid = true;
//                               widget.updateValidity(_isEmailValid &
//                                   _isEmailNotDuplicated! &
//                                   _isInputValid);
//                             });
//                           });
//                         }
//                       });
//                     }
//                   },
//                 ),
//               )),
//         ),
//         _isInputValid
//             ? Positioned(
//                 top: 245.h,
//                 left: paddingValue + 10.w,
//                 child: Text(
//                   _isEmailValid
//                       ? _isEmailNotDuplicated!
//                           ? '사용 가능한 이메일입니다.'
//                           : '이미 사용중인 이메일입니다.'
//                       : '사용 불가능한 형식의 이메일입니다.',
//                   style: TextStyle(
//                       color: !_isEmailNotDuplicated! || !_isEmailValid
//                           ? deleteButtonColor
//                           : primaryColor,
//                       fontWeight: FontWeight.w400,
//                       fontSize: min(14.sp, 24)),
//                 ))
//             : Container(),
//       ],
//     );
//   }
// }

// bool _validateEmail(String email) {
//   RegExp emailRegExp = RegExp(
//     r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
//   );

//   return emailRegExp.hasMatch(email);
// }
