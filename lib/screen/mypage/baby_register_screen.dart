import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/service/image_api.dart';
import 'package:cozy_for_mom_frontend/service/user_api.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class BabyRegisterScreen extends StatefulWidget {
  const BabyRegisterScreen({super.key});

  @override
  State<BabyRegisterScreen> createState() => _BabyRegisterScreenState();
}

const labelTextColor = Color(0xff858998);

class _BabyRegisterScreenState extends State<BabyRegisterScreen> {
  String gender = "아직 모르겠어요";
  XFile? image;
  String? imageUrl;
  var dueDate = '';
  final List<BabyForRegister> babies = [];
  final List<Widget> _babyFields = [];

  @override
  void initState() {
    super.initState();
    _addBabyField(); // 초기 하나의 태아 입력 폼 추가
  }

  void _addBabyField() {
    setState(() {
      babies.add(BabyForRegister(name: '', gender: '아직 모르겠어요'));
      _babyFields.add(_buildBabyField());
    });
  }

  Widget _buildBabyField() {
    int index = _babyFields.length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (babies.length > 1)
          const Divider(
            height: 30,
            thickness: 1,
            color: Color(0xffE1E1E7),
          ) else  SizedBox(height: 30),
        const Text(
          "태명",
          style: TextStyle(
            color: labelTextColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            child: TextFormField(
              cursorColor: primaryColor,
              decoration: const InputDecoration(
                fillColor: Colors.white,
                hintText: "태명을 입력해주세요",
                hintStyle: TextStyle(
                  color: Color(0xffE1E1E7),
                ),
                hoverColor: Colors.white,
                border: InputBorder.none,
              ),
              onChanged: (value) {
                babies[index].name = value;
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
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            child: DropdownButton<String>(
              alignment: AlignmentDirectional.bottomEnd,
              icon: const Icon(
                Icons.keyboard_arrow_down,
                color: Color(0xff858998),
              ),
              isExpanded: true,
              focusColor: Colors.white,
              value: babies[index].gender,
              onChanged: (value) {
                setState(() {
                  babies[index].gender = value!;
                });
              },
              style: const TextStyle(color: Colors.white),
              underline: const SizedBox(),
              items: <String>[
                '남아',
                '여아',
                '아직 모르겠어요',
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: const TextStyle(color: labelTextColor),
                  ),
                );
              }).toList(),
              hint: const Text(
                "아직 모르겠어요.",
                style: TextStyle(
                  color: labelTextColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
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
      body: SingleChildScrollView(
        child: Padding(
          padding:
              const EdgeInsets.only(left: 20, right: 20, bottom: 40, top: 25),
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
                            image?.path ?? 'assets/images/icons/babyProfile.png',
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
                            fit: BoxFit.contain,
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
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                      child: TextFormField(
                        cursorColor: primaryColor,
                        decoration: const InputDecoration(
                          fillColor: Colors.white,
                          hintText: "YYYY-MM-DD",
                          hintStyle: TextStyle(
                            color: Color(0xffE1E1E7),
                          ),
                          hoverColor: Colors.white,
                          border: InputBorder.none,
                        ),
                        onChanged: (value) {
                          setState(() {
                            String parsedDate;
                            if (value.length == 8) {
                              parsedDate = DateFormat('yyyy-MM-dd')
                                  .format(DateTime.parse(value));
                            } else {
                              parsedDate = value;
                            }
                            dueDate = parsedDate;
                          });
                        },
                      ),
                    ),
                  ),
                  Column(
                    children: _babyFields,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 60),
                    child: InkWell(
                      onTap: _addBabyField,
                      child: const Center(
                        child: Text(
                          '+ 태아 추가하기',
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
              InkWell(
                onTap: () {
                  UserApiService().addBabies(dueDate, imageUrl, babies);
                },
                child: Container(
                  width: 350,
                  height: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: primaryColor,
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
        ),
      ),
    );
  }
}

class BabyForRegister {
  String name;
  String gender;

  BabyForRegister(
      {
      required this.name,
      required this.gender,
      });

    Map<String, dynamic> toJson() => {
    'name': name,
    'gender': gender,
  };
}