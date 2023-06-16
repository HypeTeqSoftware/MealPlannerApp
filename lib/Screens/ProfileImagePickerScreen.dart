import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meal_tracker_app/Models/Colors.dart';

class ProfileImagePickerScreen extends StatefulWidget {
  const ProfileImagePickerScreen({Key? key}) : super(key: key);

  @override
  State<ProfileImagePickerScreen> createState() => _ProfileImagePickerScreenState();
}

class _ProfileImagePickerScreenState extends State<ProfileImagePickerScreen> {
  File? pickedImage;
  void _showBottomSheet(context){
    showModalBottomSheet(context: context, builder: (BuildContext context){
      return SingleChildScrollView(
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(50.0),
            topRight: Radius.circular(50.0),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.light ? Colors.green.shade50: Colors.black,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(50.0),
                topRight: Radius.circular(50.0),

              ),
            ),

            // height: 200,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Pic Image From",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Theme.of(context).brightness == Brightness.light ? MyColors.darkGreen : Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          primary: Theme.of(context).brightness == Brightness.light ? Colors.green.shade200 : Colors.white60, // Background color
                          onPrimary: Colors.white, // Text color
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10), // Button padding
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10), // Button border radius
                          ),
                        ),
                        onPressed: () {
                          pickImageFun(ImageSource.camera);
                        },
                        icon: const Icon(Icons.camera),
                        label: const Text("CAMERA"),
                      ),
                      ElevatedButton.icon(

                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          primary: Theme.of(context).brightness == Brightness.light ? Colors.green.shade200 :  Colors.white60, // Background color
                          onPrimary: Colors.white, // Text color
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10), // Button padding
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10), // Button border radius
                          ),
                        ),
                        onPressed: () {
                          pickImageFun(ImageSource.gallery);
                        },
                        icon: const Icon(Icons.image),
                        label: const Text("GALLERY"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12,)
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
  pickImageFun(ImageSource imageType) async {
    try {
      final photo = await ImagePicker().pickImage(source: imageType);
      if (photo == null) {
        Navigator.pop(context);
        return;
      }
      final tempImage = File(photo.path);
      setState(() {
        pickedImage = tempImage;
      });
      Get.back();
      Navigator.pop(context);
    } catch (error) {
      debugPrint(error.toString());
    }
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(
          height: 30,
        ),
        Align(
          alignment: Alignment.center,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(30),
                  ),
                ),
                child: pickedImage != null
                    ? ClipRRect(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(30),
                  ),
                      child: Image.file(
                  pickedImage!,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
                    )
                    : ClipRRect(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(30),
                  ),
                      child: Image.asset(
                  "assets/pretty.jpg",
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
                    ),
              ),
              Positioned(
                top: -5,
                right: -10,
                child: InkWell(
                  onTap: (){
                    _showBottomSheet(context);
                  },
                  child: Image.asset(
                    "assets/plusicon.png",
                    width: 25,
                    height: 25,
                    fit: BoxFit.cover,
                  ),
                ),
              )
            ],
          ),
        ),

      ],
    );
  }
}
