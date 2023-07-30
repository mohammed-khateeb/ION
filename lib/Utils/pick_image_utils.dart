import 'package:image_picker/image_picker.dart';

class PickImageUtils{
  static ImagePicker picker = ImagePicker();

  static Future<XFile?> pickImage() async {
    return await picker.pickImage(source: ImageSource.gallery);
  }
}