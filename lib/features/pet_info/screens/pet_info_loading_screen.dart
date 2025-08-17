import 'package:flutter/material.dart';
import 'package:daenglog_fe/features/pet_info/screens/pet_info_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:daenglog_fe/shared/services/dio_client.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'dart:convert';

// 반려동물 정보 저장 화면
class PetInfoLoadingScreen extends StatefulWidget {
  const PetInfoLoadingScreen({super.key});

  @override
  State<PetInfoLoadingScreen> createState() => _PetInfoLoadingScreenState();
}

class _PetInfoLoadingScreenState extends State<PetInfoLoadingScreen> {
  // 토큰 가져오기
  
  // 반려동물 정보 변수
  String? petKind;
  String? petName;
  DateTime? petBirthday;
  List<String>? petCharacters;
  XFile? petProfileImage;
  String? petGender;
  // 로딩 상태 변수
  bool isLoading = true;
  String? errorMessage;

  bool _initialized = false;

  // 초기화 함수
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _loadArguments();
      _sendPetInfo();
      _initialized = true;
    }
  }

  // 인자 로드 함수
  void _loadArguments() {
    final arguments = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (arguments != null) {
      petKind = arguments['petKind'];
      petName = arguments['petName'];
      petBirthday = arguments['petBirthday'];
      petCharacters = arguments['petCharacters'];
      petProfileImage = arguments['petProfileImage'];
      petGender = arguments['petGender'];
      print('=== LoadingScreen Received Data ===');
      print('petKind: $petKind');
      print('petName: $petName');
      print('petBirthday: $petBirthday');
      print('petCharacters: $petCharacters');
      print('petProfileImage: $petProfileImage');
      print('petGender: $petGender');
      print('==================================');
    }
  }

  // 반려동물 정보 저장 함수
  Future<void> _sendPetInfo() async {
    final dio = getDioWithAuth('api/v1/pet');

    print('petName: $petName');
    print('petBirthday: $petBirthday');
    print('petGender: $petGender');
    print('petKind: $petKind');
    print('petCharacters: $petCharacters');
    print('petProfileImage: $petProfileImage');

    try {
      final dto = {
        'name': petName,
        'birthday': DateFormat('yyyy-MM-dd').format(petBirthday!),
        'gender': petGender == '암컷' ? 'F':'M',
        'species': petKind,
        'personalities': petCharacters,
      };

      final formData = FormData.fromMap({
        'request': jsonEncode(dto),
        if (petProfileImage != null)
          'profileImage': await MultipartFile.fromFile(petProfileImage!.path),
      });

      final res = await dio.post(
        '',
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );

      print('API Response: ${res.data}');

      // 성공 시 다음 화면으로 이동
      if (res.statusCode == 200 || res.statusCode == 201) {
        // TODO: 성공 시 다음 화면으로 이동
        Navigator.pushReplacementNamed(context, '/home_main');
        print('Pet info saved successfully!');
      }

    } catch (e) {
      print('Error sending pet info: $e');
      setState(() {
        errorMessage = '정보 저장 중 오류가 발생했습니다: $e';
        isLoading = false;
      });
    }
  }

  // 빌드 함수
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading) ...[
              const CircularProgressIndicator(
                color: Color(0xFFFF5F01),
              ),
              const SizedBox(height: 20),
              const Text(
                '반려동물 정보를 저장하고 있습니다...',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ] else if (errorMessage != null) ...[
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 48,
              ),
              const SizedBox(height: 20),
              Text(
                errorMessage!,
                style: const TextStyle(
                  fontSize: 16,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w500,
                  color: Colors.red,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    isLoading = true;
                    errorMessage = null;
                  });
                  _sendPetInfo();
                },
                child: const Text('다시 시도'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}