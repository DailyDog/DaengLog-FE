import 'package:flutter/material.dart';
import 'package:daenglog_fe/api/mypage/get/pet_detail_api.dart';
import 'package:daenglog_fe/api/mypage/get/pet_simple_list_api.dart';

class PetProfileProvider extends ChangeNotifier {
  final Map<int, PetData> _petsCache = {};
  int? _defaultPetId;
  int? _currentPetId;
  bool _loading = false;

  bool get loading => _loading;
  PetData? get currentPet => _currentPetId != null ? _petsCache[_currentPetId!] : null;
  PetData? get defaultPet => _defaultPetId != null ? _petsCache[_defaultPetId!] : null;
  List<PetData> get allPets => _petsCache.values.toList();
  PetData? getPet(int petId) => _petsCache[petId];
  String? getPetImage(int petId) => _petsCache[petId]?.profileImageUrl;

  Future<void> loadPets() async {
    _loading = true;
    notifyListeners();
    try {
      final pets = await PetSimpleListApi().getMySimpleList();
      _petsCache.clear();

      for (final pet in pets) {
        _petsCache[pet.id] = PetData(
          id: pet.id,
          name: pet.name,
          profileImageUrl: _sanitizeUrl(pet.profileImageUrl),
          age: pet.age,
          isDefault: pet.isDefault,
          isFamilyPet: pet.isFamilyPet,
        );
        if (pet.isDefault) {
          _defaultPetId = pet.id;
          _currentPetId ??= pet.id;
        }
      }
    } catch (e) {
      debugPrint('Failed to load pets: $e');
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>?> loadPetDetail(int petId) async {
    try {
      final detail = await PetDetailApi().getPetDetail(petId);
      if (_petsCache.containsKey(petId)) {
        _petsCache[petId] = _petsCache[petId]!.copyWith(
          name: detail['name'] as String?,
          profileImageUrl: _sanitizeUrl(detail['profileImageUrl'] as String?),
          birthday: detail['birthday'] as String?,
          gender: detail['gender'] as String?,
          species: detail['species'] as String?,
          personalities: List<String>.from(detail['personalities'] ?? []),
        );
        notifyListeners();
      }
      return detail;
    } catch (e) {
      debugPrint('Failed to load pet detail: $e');
      return null;
    }
  }

  void updatePet(int petId, {
    String? name,
    String? profileImageUrl,
    String? birthday,
    String? gender,
    String? species,
    List<String>? personalities,
  }) {
    if (_petsCache.containsKey(petId)) {
      _petsCache[petId] = _petsCache[petId]!.copyWith(
        name: name,
        profileImageUrl: profileImageUrl != null ? _sanitizeUrl(profileImageUrl) : null,
        birthday: birthday,
        gender: gender,
        species: species,
        personalities: personalities,
      );
      notifyListeners();
    }
  }

  void setDefaultPet(int petId) {
    _defaultPetId = petId;
    _currentPetId = petId;
    _petsCache.forEach((id, pet) {
      _petsCache[id] = pet.copyWith(isDefault: id == petId);
    });
    notifyListeners();
  }

  void setCurrentPet(int petId) {
    _currentPetId = petId;
    notifyListeners();
  }

  void removePet(int petId) {
    _petsCache.remove(petId);
    if (_defaultPetId == petId) _defaultPetId = _petsCache.keys.firstOrNull;
    if (_currentPetId == petId) _currentPetId = _defaultPetId;
    notifyListeners();
  }

  String? _sanitizeUrl(String? url) {
    if (url == null || url.isEmpty) return null;
    try {
      final encodedMarker = '%3F';
      final idxEncoded = url.indexOf(encodedMarker);
      final idxQuery = url.lastIndexOf('?');
      if (idxEncoded != -1 && idxQuery != -1 && idxQuery > idxEncoded) {
        return url.substring(0, idxEncoded) + url.substring(idxQuery);
      }
      return url;
    } catch (_) {
      return url;
    }
  }

  void clear() {
    _petsCache.clear();
    _defaultPetId = null;
    _currentPetId = null;
    notifyListeners();
  }
}

class PetData {
  final int id;
  final String name;
  final String? profileImageUrl;
  final int age;
  final bool isDefault;
  final bool isFamilyPet;
  final String? birthday;
  final String? gender;
  final String? species;
  final List<String>? personalities;

  PetData({
    required this.id,
    required this.name,
    this.profileImageUrl,
    required this.age,
    required this.isDefault,
    required this.isFamilyPet,
    this.birthday,
    this.gender,
    this.species,
    this.personalities,
  });

  PetData copyWith({
    String? name,
    String? profileImageUrl,
    int? age,
    bool? isDefault,
    bool? isFamilyPet,
    String? birthday,
    String? gender,
    String? species,
    List<String>? personalities,
  }) {
    return PetData(
      id: id,
      name: name ?? this.name,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      age: age ?? this.age,
      isDefault: isDefault ?? this.isDefault,
      isFamilyPet: isFamilyPet ?? this.isFamilyPet,
      birthday: birthday ?? this.birthday,
      gender: gender ?? this.gender,
      species: species ?? this.species,
      personalities: personalities ?? this.personalities,
    );
  }
}