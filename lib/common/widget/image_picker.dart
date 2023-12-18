import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PostCreationPage(),
    );
  }
}

class PostCreationPage extends StatefulWidget {
  @override
  _PostCreationPageState createState() => _PostCreationPageState();
}

class _PostCreationPageState extends State<PostCreationPage> {
  File? _selectedImage;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _selectedImage = pickedFile != null ? File(pickedFile.path) : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('게시글 작성'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _selectedImage != null
              ? Image.file(_selectedImage!)
              : Text('선택된 이미지 없음'),
          ElevatedButton(
            onPressed: _pickImage,
            child: Text('갤러리에서 선택'),
          ),
          // 나머지 게시글 작성 UI 구현
        ],
      ),
    );
  }
}
