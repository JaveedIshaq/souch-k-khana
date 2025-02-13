// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mobile/constants/constants.dart';
import 'package:mobile/services/gemini_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile/widgets/button_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? _selectedImage;
  String foodInfo = '';
  String diseasePrecautions = '';
  bool detecting = false;
  bool resultLoaded = false;
  bool precautionLoading = false;

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile =
        await ImagePicker().pickImage(source: source, imageQuality: 50);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        foodInfo = '';
        diseasePrecautions = '';
        resultLoaded = false;
      });
    }
  }

  detectFoodInfo() async {
    setState(() {
      detecting = true;
    });
    try {
      foodInfo = await GeminiService().identifyFood(_selectedImage!);
    } catch (error) {
      _showErrorSnackBar(error);
    } finally {
      setState(() {
        detecting = false;
        resultLoaded = true;
      });
    }
  }

  void _showErrorSnackBar(Object error) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(error.toString()),
      backgroundColor: Colors.red,
    ));
  }

  Widget _buildDetectionWidget() {
    if (_selectedImage != null) {
      if (detecting) {
        return SpinKitWave(
          color: Colors.white,
          size: 30,
        );
      } else if (!resultLoaded) {
        return ButtonWidget(
          onPressed: detectFoodInfo,
          icon: Icons.info_outline,
          title: 'Get Food Info',
        );
      } else {
        return const SizedBox.shrink();
      }
    }
    return const SizedBox.shrink(); // Default fallback
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeColor,
      appBar: AppBar(
        backgroundColor: themeColor,
        elevation: 0,
        centerTitle: true,
        title: const Text('Souch K Khana',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            )),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * 0.15,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(50.0),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ButtonWidget(
                    onPressed: () {
                      _pickImage(ImageSource.camera);
                    },
                    icon: Icons.camera_alt,
                    title: 'START CAMERA',
                  ),
                  ButtonWidget(
                    onPressed: () {
                      _pickImage(ImageSource.gallery);
                    },
                    icon: Icons.image,
                    title: 'OPEN GALLERY',
                  ),
                ],
              ),
            ),
            _selectedImage == null
                ? SizedBox(
                    height: MediaQuery.of(context).size.height - 300,
                    child: Center(
                      child: Image.asset(
                        'assets/images/ai-se-pouch-k-souch-k-khana.png',
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.file(
                        _selectedImage!,
                        fit: BoxFit.cover,
                        height: 200,
                      ),
                    ),
                  ),
            _buildDetectionWidget(),
            if (foodInfo.isNotEmpty)
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Calorie Info",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 17,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.all(15.0),
                    margin: const EdgeInsets.all(15.0),
                    child: AnimatedTextKit(
                      isRepeatingAnimation: false,
                      repeatForever: false,
                      displayFullTextOnTap: true,
                      totalRepeatCount: 1,
                      animatedTexts: [
                        TyperAnimatedText(
                          foodInfo.trim(),
                        ),
                      ],
                    ),
                  )
                ],
              ),
          ],
        ),
      ),
    );
  }
}
