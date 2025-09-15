import 'package:flutter/material.dart';
import 'package:daenglog_fe/api/mypage/post/pet_update_api.dart';

class PetBasicEditScreen extends StatefulWidget {
  const PetBasicEditScreen({super.key});

  @override
  State<PetBasicEditScreen> createState() => _PetBasicEditScreenState();
}

class _PetBasicEditScreenState extends State<PetBasicEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _birthdayController;
  String _gender = '';

  int? _petId;
  String _species = '';
  List<String> _personalities = [];
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _birthdayController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    // 한 번만 초기화
    if (!_isInitialized) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null) {
        _petId = args['id'] as int?;
        _nameController.text = (args['name'] as String?) ?? '';
        _birthdayController.text = (args['birthday'] as String?) ?? '';
        _gender = (args['gender'] as String?) ?? '';
        _species = (args['species'] as String?) ?? '';
        _personalities = List<String>.from((args['personalities'] as List?) ?? []);
        _isInitialized = true;
        
        // 상태 업데이트
        setState(() {});
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _birthdayController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate() || _petId == null) return;
    
    try {
      await PetUpdateApi().updatePet(
        petId: _petId!,
        name: _nameController.text.trim(),
        birthday: _birthdayController.text.trim(),
        gender: _gender,
        species: _species.isEmpty ? 'DOG' : _species,
        personalities: _personalities,
      );
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('저장 실패: $e')),
        );
      }
    }
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final initial = DateTime.tryParse(_birthdayController.text) ?? 
                   DateTime(now.year - 3, now.month, now.day);
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1990),
      lastDate: DateTime(now.year + 1),
    );
    if (picked != null) {
      final s = '${picked.year.toString().padLeft(4, '0')}-'
                '${picked.month.toString().padLeft(2, '0')}-'
                '${picked.day.toString().padLeft(2, '0')}';
      setState(() { 
        _birthdayController.text = s; 
      });
    }
  }

  // 초기화 버튼 동작 수정
  void _reset() {
    setState(() {
      _nameController.clear();
      _birthdayController.clear();
      _gender = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    // 나머지 UI 코드는 동일하되, 초기화 버튼의 onPressed를 _reset()으로 변경
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          '반려동물 정보 수정',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Pretendard',
            fontSize: screenWidth * 0.045,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.08, 
          vertical: screenHeight * 0.02
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenHeight * 0.03),
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: screenWidth * 0.05,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF484848),
                    fontFamily: 'Pretendard',
                  ),
                  children: [
                    const TextSpan(text: '반려견 '),
                    TextSpan(
                      text: '정보',
                      style: TextStyle(color: const Color(0xFFFF5F01)),
                    ),
                    const TextSpan(text: '을 입력해 주세요'),
                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.01),
              Text(
                'AI에게 전달되는 정보에요.',
                style: TextStyle(
                  fontSize: screenWidth * 0.035,
                  color: const Color(0xFF9A9A9A),
                  fontFamily: 'Pretendard',
                ),
              ),
              SizedBox(height: screenHeight * 0.04),
              
              // 이름 입력
              Container(
                height: 56,
                width: double.infinity,
                margin: const EdgeInsets.symmetric(vertical: 10),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFEAEAEA),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Center(
                  child: TextFormField(
                    controller: _nameController,
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: '강아지 이름',
                      hintStyle: TextStyle(
                        color: Color(0xFF8C8B8B),
                        fontSize: 16,
                        fontFamily: 'Pretendard-Medium',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    style: const TextStyle(
                      color: Color(0xFF333333),
                      fontSize: 16,
                      fontFamily: 'Pretendard-Medium',
                      fontWeight: FontWeight.w500,
                    ),
                    validator: (v) => (v == null || v.trim().isEmpty) 
                        ? '이름을 입력해 주세요' : null,
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // 생일 선택
              GestureDetector(
                onTap: _pickDate,
                child: Container(
                  height: 56,
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAEAEA),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.calendar_month,
                          color: Color(0xFFFF5F01),
                          size: 32,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _birthdayController.text.isNotEmpty 
                              ? _birthdayController.text
                              : '생일 선택하기',
                          style: TextStyle(
                            color: _birthdayController.text.isNotEmpty 
                                ? const Color(0xFF333333)
                                : const Color(0xFF8C8B8B),
                            fontSize: 16,
                            fontFamily: 'Pretendard-Medium',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              
              // 성별 선택
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: 50,
                    width: 300,
                    child: Row(
                      children: [
                        // 암컷 버튼
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _gender = 'F';
                              });
                            },
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                color: _gender == 'F'
                                    ? Color(0xFFFF5F01)
                                    : Color(0xFFEAEAEA),
                                borderRadius: BorderRadius.circular(40),
                              ),
                              child: Center(
                                child: Text(
                                  '암컷',
                                  style: TextStyle(
                                    color: _gender == 'F'
                                        ? Colors.white
                                        : Color(0xFF8C8B8B),
                                    fontSize: 20,
                                    fontFamily: 'Pretendard-Medium',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 20),
                        // 수컷 버튼
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _gender = 'M';
                              });
                            },
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                color: _gender == 'M'
                                    ? Color(0xFFFF5F01)
                                    : Color(0xFFEAEAEA),
                                borderRadius: BorderRadius.circular(40),
                              ),
                              child: Center(
                                child: Text(
                                  '수컷',
                                  style: TextStyle(
                                    color: _gender == 'M'
                                        ? Colors.white
                                        : Color(0xFF8C8B8B),
                                    fontSize: 20,
                                    fontFamily: 'Pretendard-Medium',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: screenHeight * 0.06),
              
              // 버튼들
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextButton(
                        onPressed: _reset,
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          '초기화',
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Pretendard',
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.03),
                  Expanded(
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF5F01),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextButton(
                        onPressed: _save,
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          '저장',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Pretendard',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.02),
            ],
          ),
        ),
      ),
    );
  }
}