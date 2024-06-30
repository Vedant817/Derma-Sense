import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';

class ImageProviderCustom extends ChangeNotifier {
  XFile? imageFile;

  void saveImage(XFile _imageFile) {
    imageFile = _imageFile;
    notifyListeners();
  }

  void removeImage() {
    imageFile = null;
    notifyListeners();
  }
}
