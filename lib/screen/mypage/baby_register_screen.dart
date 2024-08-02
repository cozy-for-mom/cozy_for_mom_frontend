import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/screen/join/join_input_data.dart';
import 'package:cozy_for_mom_frontend/service/image_api.dart';
import 'package:cozy_for_mom_frontend/service/user_api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class BabyRegisterScreen extends StatefulWidget {
  const BabyRegisterScreen({super.key});

  @override
  State<BabyRegisterScreen> createState() => _BabyRegisterScreenState();
}

const labelTextColor = Color(0xff858998);

class _BabyRegisterScreenState extends State<BabyRegisterScreen> {
  final List<String> genderItems = ['남아', '여아', '아직 모르겠어요'];
  TextEditingController dueDateController = TextEditingController();

  List<TextEditingController> birthNameControllers = [];
  List<TextEditingController> genderControllers = [];
  XFile? image;
  String? imageUrl;
  var dueDate = '';
  final List<BabyForRegister> babies = [];

  bool isGenderModal = false;
  int babyCount = 1;
  List<bool> isOpenGenderModal = [false];

  @override
  void initState() {
    super.initState();
    addBaby();
  }

  void addBaby() {
    setState(() {
      birthNameControllers.add(TextEditingController());
      genderControllers.add(TextEditingController());
    });
  }

  bool _validateFields() {
    bool allFieldsValid = true;
    for (int i = 0; i < birthNameControllers.length; i++) {
      if (birthNameControllers[i].text.isEmpty ||
          genderControllers[i].text.isEmpty) {
        allFieldsValid = false;
        break;
      }
    }
    return allFieldsValid && dueDateController.text.isNotEmpty;
  }

  @override
  void dispose() {
    birthNameControllers.forEach((controller) {
      controller.dispose();
    });
    genderControllers.forEach((controller) {
      controller.dispose();
    });
    super.dispose();
  }

  Widget _buildBabyField(int index) {
    if (index >= birthNameControllers.length) {
      birthNameControllers.add(TextEditingController());
    }
    if (index >= genderControllers.length) {
      genderControllers.add(TextEditingController());
    }
    if (index >= isOpenGenderModal.length) {
      isOpenGenderModal.add(false);
    }
    if (index >= babies.length) {
      babies.add(BabyForRegister(name: '', gender: ''));
    }
    final screenWidth = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 30),
        const Text(
          "태명",
          style: TextStyle(
              color: labelTextColor, fontWeight: FontWeight.w600, fontSize: 14),
        ),
        const SizedBox(
          height: 14,
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: TextFormField(
              cursorColor: primaryColor,
              cursorHeight: 17,
              cursorWidth: 1.5,
              maxLength: 8,
              controller: birthNameControllers[index],
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                counterText: '',
                fillColor: Colors.white,
                hintText: "태명을 입력해주세요",
                hintStyle: TextStyle(
                    color: Color(0xffE1E1E7),
                    fontWeight: FontWeight.w500,
                    fontSize: 16),
                hoverColor: Colors.white,
                border: InputBorder.none,
              ),
              onChanged: (value) {
                if (mounted) {
                  setState(() {
                    babies[index].name = value;
                    _validateFields();
                  });
                }
              },
            ),
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        const Text(
          "성별",
          style: TextStyle(
            color: labelTextColor,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        const SizedBox(
          height: 14,
        ),
        InkWell(
          onTap: () {
            if (mounted) {
              setState(() {
                isOpenGenderModal[index] = !isOpenGenderModal[index];
              });
            }
          },
          child: Container(
            width: screenWidth - 40,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(30)),
            padding: const EdgeInsets.only(left: 20),
            child: IgnorePointer(
              child: TextFormField(
                controller: genderControllers[index],
                readOnly: true,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(top: 16),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  hintText: '아직 모르겠어요',
                  hintStyle: const TextStyle(
                      color: beforeInputColor,
                      fontWeight: FontWeight.w400,
                      fontSize: 16),
                  suffixIcon: const Icon(CupertinoIcons.chevron_down,
                      size: 16, color: mainTextColor),
                ),
                style: const TextStyle(
                    color: mainTextColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 16),
              ),
            ),
          ),
        ),
        isOpenGenderModal[index]
            ? Container(
                height: 188,
                width: screenWidth - 40,
                margin: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: contentBoxTwoColor,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: genderItems.map<Widget>((String item) {
                    return InkWell(
                      onTap: () {
                        if (mounted) {
                          setState(() {
                            genderControllers[index] =
                                (TextEditingController(text: item));
                            babies[index].gender = item;
                            _validateFields();
                            isOpenGenderModal[index] =
                                !isOpenGenderModal[index];
                          });
                        }
                      },
                      child: Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            item,
                            style: const TextStyle(
                              color: offButtonTextColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              )
            : Container(),
        babyCount > 1 && index < babyCount - 1
            ? Container(
                margin: const EdgeInsets.only(top: 20),
                width: screenWidth - 40,
                height: 1,
                color: mainLineColor)
            : Container(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final joinInputData = Provider.of<JoinInputData>(context, listen: false);
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
          backgroundColor: backgroundColor,
          elevation: 0,
          leading: Container(),
          actions: [
            IconButton(
                color: Colors.black,
                icon: const Icon(
                  Icons.close,
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
          ]),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, bottom: 40, top: 25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            Center(
                              child: ClipOval(
                                child: Image.asset(
                                  image?.path ??
                                      'assets/images/icons/babyProfile.png',
                                  fit: BoxFit.cover,
                                  width: 100,
                                  height: 100,
                                  alignment: Alignment.center,
                                ),
                              ),
                            ),
                            Positioned(
                              left: 206,
                              top: 72,
                              child: GestureDetector(
                                onTap: () async {
                                  final selectedImage = await ImagePicker()
                                      .pickImage(source: ImageSource.gallery);
                                  setState(() async {
                                    if (selectedImage != null) {
                                      imageUrl = await ImageApiService()
                                          .uploadImage(selectedImage);
                                      setState(() {});
                                    } else {
                                      print('No image selected.');
                                    }
                                  });
                                },
                                child: Container(
                                  width: 24,
                                  height: 24,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xffA9ABB7),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              left: 210,
                              top: 76,
                              child: GestureDetector(
                                onTap: () async {
                                  final selectedImage = await ImagePicker()
                                      .pickImage(source: ImageSource.gallery);
                                  setState(() {
                                    image = selectedImage;
                                  });
                                },
                                child: Image.asset(
                                  'assets/images/icons/pen.png',
                                  fit: BoxFit.contain, // 이미지를 화면에 맞게 조절
                                  width: 14,
                                  height: 14,
                                  color: Colors.white,
                                  alignment: Alignment.center,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        const Text(
                          "출산예정일",
                          style: TextStyle(
                              color: labelTextColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 14),
                        ),
                        const SizedBox(
                          height: 14,
                        ),
                        Container(
                            width: screenWidth - 40,
                            height: 48,
                            padding: const EdgeInsets.only(
                                top: 10, bottom: 10, left: 20, right: 20),
                            decoration: BoxDecoration(
                                color: contentBoxTwoColor,
                                borderRadius: BorderRadius.circular(30)),
                            child: TextFormField(
                              controller: dueDateController,
                              keyboardType: TextInputType.datetime,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              textAlign: TextAlign.start,
                              textAlignVertical: TextAlignVertical.center,
                              maxLength: 10,
                              cursorColor: primaryColor,
                              cursorHeight: 14,
                              cursorWidth: 1.2,
                              style: const TextStyle(
                                  color: mainTextColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16),
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.only(bottom: 10),
                                border: InputBorder.none,
                                hintText: 'YYYY.MM.DD',
                                hintStyle: TextStyle(
                                    color: beforeInputColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16),
                                counterText: '',
                              ),
                              onChanged: (value) {
                                if (mounted) {
                                  setState(() {
                                    // TODO 자동완성 후, 지웠다가 다시 입력할때 자동완성 안됨
                                    String parsedDate;
                                    if (value.length == 8 &&
                                        _isNumeric(value)) {
                                      parsedDate = DateFormat('yyyy.MM.dd')
                                          .format(DateTime.parse(value));
                                    } else {
                                      parsedDate = value;
                                    }
                                    dueDateController.text = parsedDate;
                                    dueDate = parsedDate;
                                  });
                                }
                              },
                            )),
                        Column(
                            children: List.generate(babyCount, (index) {
                          return _buildBabyField(index);
                        })),
                        Padding(
                          padding: const EdgeInsets.only(top: 20, bottom: 60),
                          child: InkWell(
                            onTap: () {
                              if (mounted) {
                                setState(() {
                                  babyCount += 1;
                                  isOpenGenderModal.add(false);
                                });
                              }
                            },
                            child: const Center(
                              child: Text(
                                '+ 다태아 추가하기',
                                style: TextStyle(
                                    color: primaryColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              if (_validateFields()) {
                UserApiService()
                    .addBabies(dueDate.replaceAll('.', '-'), imageUrl, babies);
                Navigator.pop(context);
              }
            },
            child: Container(
              width: screenWidth - 40,
              height: 56,
              margin: const EdgeInsets.only(bottom: 30),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color:
                    _validateFields() ? primaryColor : const Color(0xffC9DFF9),
              ),
              child: const Center(
                child: Text(
                  "등록하기",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BabyForRegister {
  String name;
  String gender;

  BabyForRegister({
    required this.name,
    required this.gender,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'gender': gender,
      };
}

bool _isNumeric(String value) {
  final numericRegex = RegExp(r'^[0-9]+$');
  return numericRegex.hasMatch(value);
}
