import 'dart:io';
import 'package:image_picker/image_picker.dart';

ImagePicker _picker = ImagePicker();

Future<File?> pickImageFromGallery() async {
  final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

  if (image == null) return null;

  return File(image.path);
}
