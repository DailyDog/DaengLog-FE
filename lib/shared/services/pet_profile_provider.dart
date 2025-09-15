import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:daenglog_fe/api/mypage/get/pet_detail_api.dart';
import 'package:daenglog_fe/api/mypage/get/pet_simple_list_api.dart';
import 'package:daenglog_fe/api/mypage/models/pet_simple_item.dart';
import 'package:daenglog_fe/api/pets/refresh/pet_image_refresh_api.dart';
import 'package:daenglog_fe/api/pets/delete/pet_delete_api.dart';
import 'package:daenglog_fe/api/pets/update/pet_image_update_api.dart';

class PetProfileProvider extends ChangeNotifier {
  final Map<int, PetData> _petsCache = {};
  final Map<int, DateTime> _lastRefreshAttempt = {}; // 갱신 시도 제한 추가
  int? _defaultPetId;
  int? _currentPetId;
  bool _loading = false;

  // Getters
  bool get loading => _loading;
  PetData? get currentPet => _currentPetId != null ? _petsCache[_currentPetId!] : null;
  PetData? get defaultPet => _defaultPetId != null ? _petsCache[_defaultPetId!] : null;
  List<PetData> get allPets => _petsCache.values.toList();

  PetData? getPet(int petId) => _petsCache[petId];
  String? getPetImage(int petId) => _petsCache[petId]?.profileImageUrl;

  Future<void> loadPets() async {
    print("🔵 loadPets 시작 - 현재 캐시: ${_petsCache.length}개");
    _loading = true;
    notifyListeners();

    try {
      final pets = await PetSimpleListApi().getMySimpleList();
      print("🔵 API 응답: ${pets.length}개");
      
      // 기존 캐시를 보존하고 업데이트만 수행
      final newPetIds = pets.map((p) => p.id).toSet();
      
      // 삭제된 펫 제거
      _petsCache.removeWhere((id, _) => !newPetIds.contains(id));
      
      for (final pet in pets) {
        print("🔵 Pet 처리: ${pet.name} (${pet.id}) - ${pet.profileImageUrl}");
        
        if (_petsCache.containsKey(pet.id)) {
          // 기존 펫 업데이트 (이미지 URL 유지하되 새 것이 있으면 업데이트)
          _petsCache[pet.id] = _petsCache[pet.id]!.copyWith(
            name: pet.name,
            profileImageUrl: _sanitizeUrl(pet.profileImageUrl) ?? _petsCache[pet.id]!.profileImageUrl,
            age: pet.age,
            isDefault: pet.isDefault,
            isFamilyPet: pet.isFamilyPet,
          );
        } else {
          // 새로운 펫 추가
          _petsCache[pet.id] = PetData(
            id: pet.id,
            name: pet.name,
            profileImageUrl: _sanitizeUrl(pet.profileImageUrl),
            age: pet.age,
            isDefault: pet.isDefault,
            isFamilyPet: pet.isFamilyPet,
          );
        }
        
        if (pet.isDefault) {
          _defaultPetId = pet.id;
          _currentPetId ??= pet.id;
        }
      }
      
      print("🔵 로드 완료 - 총 캐시: ${_petsCache.length}개");
    } catch (e) {
      print("🔴 loadPets 실패: $e");
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  // 특정 반려동물 상세 정보 로드
  Future<Map<String, dynamic>?> loadPetDetail(int petId) async {
    print("🔵 loadPetDetail 시작: $petId");
    try {
      final detail = await PetDetailApi().getPetDetail(petId);
      print("🔵 Detail API 응답: ${detail['name']} - ${detail['profileImageUrl']}");
      
      // 캐시 업데이트
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
        print("🔵 캐시 업데이트 완료: ${_petsCache[petId]!.profileImageUrl}");
      }
      
      return detail;
    } catch (e) {
      print("🔴 loadPetDetail 실패: $e");
      return null;
    }
  }

  // 이미지 URL 갱신 (403 에러 대응) - 개선된 버전
  Future<String?> refreshPetImageUrl(int petId) async {
    // 10초 내 재시도 방지
    final lastAttempt = _lastRefreshAttempt[petId];
    if (lastAttempt != null && 
        DateTime.now().difference(lastAttempt).inSeconds < 10) {
      print("🔄 너무 빠른 재시도 무시: $petId");
      return null;
    }
    
    _lastRefreshAttempt[petId] = DateTime.now();
    
    print("🔄 refreshPetImageUrl 시작: $petId");
    try {
      final refreshedUrl = await PetImageRefreshApi().refreshPetImageUrl(petId);
      
      // URL 검증
      if (refreshedUrl == null || refreshedUrl.isEmpty) {
        print("🔴 빈 URL 응답");
        return null;
      }
      
      // URI 형식 검증
      try {
        final uri = Uri.parse(refreshedUrl);
        if (!uri.hasScheme || uri.host.isEmpty) {
          print("🔴 잘못된 URI 형식: $refreshedUrl");
          return null;
        }
      } catch (e) {
        print("🔴 URI 파싱 실패: $refreshedUrl - $e");
        return null;
      }
      
      if (_petsCache.containsKey(petId)) {
        // 캐시 업데이트
        _petsCache[petId] = _petsCache[petId]!.copyWith(
          profileImageUrl: refreshedUrl,
        );
        notifyListeners();
        
        print("🔄 Pet image URL refreshed for petId: $petId -> $refreshedUrl");
        return refreshedUrl;
      }
      
      return refreshedUrl;
    } catch (e) {
      print("🔴 refreshPetImageUrl 실패: $e");
      return null;
    }
  }

  // 반려동물 업데이트
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

  // 기본 반려동물 설정
  void setDefaultPet(int petId) {
    print("🔵 setDefaultPet: $petId");
    _defaultPetId = petId;
    _currentPetId = petId;
    
    // 모든 반려동물의 isDefault 업데이트
    _petsCache.forEach((id, pet) {
      _petsCache[id] = pet.copyWith(isDefault: id == petId);
    });
    
    notifyListeners();
  }

  // 현재 선택된 반려동물 변경
  void setCurrentPet(int petId) {
    _currentPetId = petId;
    notifyListeners();
  }

  // 반려동물 삭제
  void removePet(int petId) {
    print("🔴 removePet: $petId");
    _petsCache.remove(petId);
    _lastRefreshAttempt.remove(petId); // 갱신 기록도 제거
    if (_defaultPetId == petId) {
      _defaultPetId = _petsCache.keys.firstOrNull;
    }
    if (_currentPetId == petId) {
      _currentPetId = _defaultPetId;
    }
    notifyListeners();
  }

  // 반려동물 삭제 (API 호출 포함)
Future<bool> deletePet(int petId) async {
  try {
    final success = await PetDeleteApi().deletePet(petId);
    if (success) {
      // 로컬 캐시에서도 제거
      _petsCache.remove(petId);
      _lastRefreshAttempt.remove(petId);
      
      // 기본 반려동물이었다면 새로 설정
      if (_defaultPetId == petId) {
        _defaultPetId = _petsCache.keys.firstOrNull;
      }
      if (_currentPetId == petId) {
        _currentPetId = _defaultPetId;
      }
      
      notifyListeners();
      print("🟢 반려동물 삭제 성공: $petId");
      return true;
    }
    return false;
  } catch (e) {
    print("🔴 반려동물 삭제 실패: $e");
    return false;
  }
}

// 프로필 이미지 업데이트
Future<bool> updatePetImage(int petId, XFile imageFile) async {
  try {
    final newImageUrl = await PetImageUpdateApi().updatePetImage(petId, imageFile);
    if (newImageUrl != null && _petsCache.containsKey(petId)) {
      _petsCache[petId] = _petsCache[petId]!.copyWith(
        profileImageUrl: newImageUrl,
      );
      notifyListeners();
      print("🟢 프로필 이미지 업데이트 성공: $newImageUrl");
      return true;
    }
    return false;
  } catch (e) {
    print("🔴 프로필 이미지 업데이트 실패: $e");
    return false;
  }
}

  // URL 정리 유틸리티 - 개선된 버전
  String? _sanitizeUrl(String? url) {
    if (url == null || url.isEmpty) return null;
    
    // 기본 URL 검증
    try {
      final uri = Uri.parse(url);
      if (!uri.hasScheme || uri.host.isEmpty) {
        print("🔴 잘못된 URL 형식: $url");
        return null;
      }
    } catch (e) {
      print("🔴 URL 파싱 실패: $url");
      return null;
    }
    
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

  // 초기화 - 갱신 기록도 클리어
  void clear() {
    _petsCache.clear();
    _lastRefreshAttempt.clear(); // 추가
    _defaultPetId = null;
    _currentPetId = null;
    notifyListeners();
  }
}

// 반려동물 데이터 모델 - 기존과 동일
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