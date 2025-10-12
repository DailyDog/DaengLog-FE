import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:daenglog_fe/api/mypage/get/pet_simple_list_api.dart';
import 'package:daenglog_fe/api/mypage/models/pet_simple_item.dart';
import 'package:daenglog_fe/api/diary/get/diary_first_date_api.dart';

class RecordProvider extends ChangeNotifier {
  bool _isModalVisible = false;
  XFile? _selectedImage;
  String? _selectedImageSource; // 'gallery', 'camera'

  // 반려동물 관련 상태
  List<PetSimpleItem> _petList = [];
  PetSimpleItem? _selectedPet;
  bool _isLoadingPets = false;
  int _daysSinceFirstDiary = 0;

  // 미디어 선택 모달 상태
  bool _isMediaSelectionModalVisible = false;

  // Getters
  bool get isModalVisible => _isModalVisible;
  XFile? get selectedImage => _selectedImage;
  String? get selectedImageSource => _selectedImageSource;
  List<PetSimpleItem> get petList => _petList;
  PetSimpleItem? get selectedPet => _selectedPet;
  bool get isLoadingPets => _isLoadingPets;
  int get daysSinceFirstDiary => _daysSinceFirstDiary;
  bool get isMediaSelectionModalVisible => _isMediaSelectionModalVisible;

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
        context.go('/image_upload');
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
        context.go('/image_upload');
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

  // 반려동물 관련 메서드
  Future<void> loadPetList() async {
    _isLoadingPets = true;
    notifyListeners();

    try {
      _petList = await PetSimpleListApi().getMySimpleList();

      // 기본 반려동물을 찾아서 선택
      final defaultPet = _petList.where((pet) => pet.isDefault).firstOrNull;
      _selectedPet =
          defaultPet ?? (_petList.isNotEmpty ? _petList.first : null);

      // 선택된 반려동물의 D-day 계산
      if (_selectedPet != null) {
        await _calculateDaysSinceFirstDiary();
      }
    } catch (e) {
      debugPrint('반려동물 목록 로드 실패: $e');
    } finally {
      _isLoadingPets = false;
      notifyListeners();
    }
  }

  void selectPet(PetSimpleItem pet) {
    _selectedPet = pet;
    _calculateDaysSinceFirstDiary();
    notifyListeners();
  }

  Future<void> _calculateDaysSinceFirstDiary() async {
    if (_selectedPet == null) {
      _daysSinceFirstDiary = 0;
      return;
    }

    try {
      final firstDate =
          await DiaryFirstDateApi().getFirstDiaryDate(petId: _selectedPet!.id);
      if (firstDate != null) {
        final now = DateTime.now();
        final difference = now.difference(firstDate);
        _daysSinceFirstDiary = difference.inDays + 1; // 첫 날도 포함
      } else {
        _daysSinceFirstDiary = 0;
      }
    } catch (e) {
      debugPrint('D-day 계산 실패: $e');
      _daysSinceFirstDiary = 0;
    }
  }

  // 미디어 선택 모달 관련 메서드
  void showMediaSelectionModal() {
    _isMediaSelectionModalVisible = true;
    notifyListeners();
  }

  void hideMediaSelectionModal() {
    _isMediaSelectionModalVisible = false;
    notifyListeners();
  }

  // 미디어 선택 처리 메서드들
  Future<void> selectFromGallery(BuildContext context) async {
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
        hideMediaSelectionModal();
        notifyListeners();

        // TODO: 여기서 업로드 API 호출
        // await uploadImage(picked);
      }
    } catch (e) {
      debugPrint('갤러리 선택 오류: $e');
    }
  }

  Future<void> selectFromCamera(BuildContext context) async {
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
        hideMediaSelectionModal();
        notifyListeners();

        // TODO: 여기서 업로드 API 호출
        // await uploadImage(picked);
      }
    } catch (e) {
      debugPrint('카메라 선택 오류: $e');
    }
  }

  Future<void> selectFromFiles(BuildContext context) async {
    // TODO: 파일 선택 기능 구현
    // file_picker 패키지를 사용하여 구현 가능
    debugPrint('파일 선택 기능은 추후 구현 예정');
    hideMediaSelectionModal();
  }
}
