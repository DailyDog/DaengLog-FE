import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class RecordProvider extends ChangeNotifier {
  bool _isModalVisible = false;
  XFile? _selectedImage;
  String? _selectedImageSource; // 'gallery', 'camera'

  // Getters
  bool get isModalVisible => _isModalVisible;
  XFile? get selectedImage => _selectedImage;
  String? get selectedImageSource => _selectedImageSource;

  // Modal visibility methods
  void showModal() {
    _isModalVisible = true;
    notifyListeners();
  }

  void hideModal() {
    _isModalVisible = false;
    notifyListeners();
  }

  // Image selection methods
  Future<void> pickImageFromGallery(BuildContext context) async {
    try {
      final picker = ImagePicker();
      final XFile? picked = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );
      
      if (picked != null) {
        _selectedImage = picked;
        _selectedImageSource = 'gallery';
        hideModal();
        notifyListeners();
        
        // Navigate to image upload screen
        Navigator.pushNamed(context, '/image_upload');
      }
    } catch (e) {
      debugPrint('Gallery pick error: $e');
    }
  }

  Future<void> takePhotoWithCamera(BuildContext context) async {
    try {
      final picker = ImagePicker();
      final XFile? picked = await picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );
      
      if (picked != null) {
        _selectedImage = picked;
        _selectedImageSource = 'camera';
        hideModal();
        notifyListeners();
        
        // Navigate to image upload screen
        Navigator.pushNamed(context, '/image_upload');
      }
    } catch (e) {
      debugPrint('Camera pick error: $e');
    }
  }

  // Clear selections
  void clearSelections() {
    _selectedImage = null;
    _selectedImageSource = null;
    notifyListeners();
  }

  // Check if any media is selected
  bool get hasSelectedMedia => _selectedImage != null;
}
