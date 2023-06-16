import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:meal_tracker_app/Models/Colors.dart';

class ImagePickerScreen extends StatefulWidget {
  const ImagePickerScreen({Key? key}) : super(key: key);

  @override
  State<ImagePickerScreen> createState() => _ImagePickerScreenState();
}

class _ImagePickerScreenState extends State<ImagePickerScreen> {
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
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
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
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Theme.of(context).brightness == Brightness.light ? MyColors.darkGreen : Colors.black),
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
                          primary: Theme.of(context).brightness == Brightness.light ? Colors.green.shade200 : Colors.black26, // Background color
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
                          primary: Theme.of(context).brightness == Brightness.light ? Colors.green.shade200 : Colors.black26, // Background color
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
      if (photo == null)
        return;
      final tempImage = File(photo.path);
      setState(() {
        pickedImage = tempImage;
      });

      Get.back();
    } catch (error) {
      debugPrint(error.toString());
    }
  }
  @override
  Widget build(BuildContext context) {
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(
          height: 30,
        ),
        Align(
          alignment: Alignment.center,
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).brightness == Brightness.light ? MyColors.darkGreen : Colors.black26, width: 5),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(80),
                  ),
                ),
                child: ClipOval(
                  child: pickedImage != null
                      ? Image.file(
                    pickedImage!,
                    width: 130,
                    height: 130,
                    fit: BoxFit.cover,
                  )
                      : Image.asset(
                    "assets/food profile.jpg",
                    width: 130,
                    height: 130,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                top: 0,
                right: 1,
                child: IconButton(
                  onPressed: () {
                    _showBottomSheet(context);
                  },
                  icon: const Icon(
                    Icons.add_a_photo_outlined,
                    color: MyColors.green,
                    size: 30,
                  ),
                ),
              )
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton.icon(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).brightness == Brightness.light ? Colors.green : Colors.black26,),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)
              ))
            ),
              onPressed: () async{
                _showBottomSheet(context);
              },
              icon: const Icon(Icons.add_a_photo_sharp),
              label: const Text('UPLOAD IMAGE')),
        ),
      ],
    );
  }
}
