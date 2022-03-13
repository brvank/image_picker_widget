import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerWidget extends StatefulWidget {
  const ImagePickerWidget({Key? key}) : super(key: key);

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  late List<CustomImage> images;
  late double size;
  late ImagePicker imagePicker;
  late int idGenerator;

  @override
  void initState() {
    images = [];
    size = 100;
    idGenerator = 0;
    imagePicker = ImagePicker();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ElevatedButton(
            onPressed: () {
              pickImage();
            },
            child: Text('Pick Image')),
        Wrap(
            children: images.map((image) {
          return Stack(children: [
            SizedBox(
                height: size,
                width: size,
                child: ClipRRect(
                    child: Image.memory(
                  image.imageData,
                  fit: BoxFit.fill,
                ))),
            Positioned(
                right: 4,
                top: 4,
                child: InkWell(
                    onTap: () {
                      //delete image
                      images.removeWhere(
                          (element) => element.imageData == image.imageData);
                      setState(() {});
                    },
                    child: Container(
                        color: Colors.white, child: Icon(Icons.clear))))
          ]);
        }).toList())
      ],
    );
  }

  Future<void> pickImage() async {
    // XFile? image = await imagePicker.pickImage(source: ImageSource.camera);
    XFile? image = await imagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      Uint8List imageData = await image.readAsBytes();
      int id = idGenerator++;
      images.add(CustomImage(imageData: imageData, id: id));
      setState(() {});
    }
  }
}

class CustomImage {
  Uint8List imageData;
  int id;

  CustomImage({required this.imageData, required this.id});
}
