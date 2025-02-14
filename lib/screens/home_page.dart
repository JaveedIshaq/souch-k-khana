import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile/constants/constants.dart';
import 'package:mobile/service/gemini_service.dart';
import 'package:mobile/widgets/button_widget.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? _selectedImage;
  String foodInfoResult = "";
  bool isLoading = false;

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile =
        await ImagePicker().pickImage(source: source, imageQuality: 50);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        foodInfoResult = "";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeColor,
      appBar: AppBar(
        title: Text(
          "Souch K Khana",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: themeColor,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // This is the Header Section
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              height: 100,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ButtonWidget(
                    title: "START CAMERA",
                    icon: Icons.camera,
                    onPressed: () {
                      _pickImage(ImageSource.camera);
                    },
                  ),
                  ButtonWidget(
                    title: "OPEN GALLERY",
                    icon: Icons.image,
                    onPressed: () {
                      _pickImage(ImageSource.gallery);
                    },
                  ),
                ],
              ),
            ),

            ///============ BODY Section
            if (_selectedImage == null)
              Image.asset("assets/images/ai-se-pouch-k-souch-k-khana.png")
            else
              Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(
                      _selectedImage!,
                      height: 300,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ButtonWidget(
                    title: "GET FOOD INFO",
                    icon: Icons.info,
                    onPressed: () async {
                      setState(() {
                        isLoading = true;
                      });
                      final foodInfo =
                          await GeminiService().identifyFood(_selectedImage!);

                      setState(() {
                        foodInfoResult = foodInfo;
                        isLoading = false;
                      });
                    },
                  ),
                  if (isLoading)
                    Padding(
                      padding: const EdgeInsets.only(top: 18.0),
                      child: CircularProgressIndicator(),
                    ),
                  if (foodInfoResult != "")
                    Container(
                      margin: const EdgeInsets.all(16.0),
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(100),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: AnimatedTextKit(
                        isRepeatingAnimation: false,
                        repeatForever: false,
                        displayFullTextOnTap: true,
                        totalRepeatCount: 1,
                        animatedTexts: [
                          TyperAnimatedText(
                            foodInfoResult.trim(),
                          ),
                        ],
                      ),
                    ),
                ],
              )
          ],
        ),
      ),
    );
  }
}
