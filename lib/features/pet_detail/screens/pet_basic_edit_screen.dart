import 'package:flutter/material.dart';
import 'package:daenglog_fe/api/mypage/post/pet_update_api.dart';

class PetBasicEditScreen extends StatefulWidget {
  const PetBasicEditScreen({super.key});

  @override
  State<PetBasicEditScreen> createState() => _PetBasicEditScreenState();
}

class _PetBasicEditScreenState extends State<PetBasicEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _birthdayController; // yyyy-MM-dd
  String _gender = '';

  int? _petId;
  String _species = '';
  List<String> _personalities = const [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    _petId = args?['id'] as int?;
    _nameController = TextEditingController(text: args?['name'] as String? ?? '');
    _birthdayController = TextEditingController(text: args?['birthday'] as String? ?? '');
    _gender = (args?['gender'] as String? ?? '');
    _species = (args?['species'] as String? ?? '');
    _personalities = ((args?['personalities'] as List?)?.cast<String>()) ?? const [];
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate() || _petId == null) return;
    await PetUpdateApi().updatePet(
      petId: _petId!,
      name: _nameController.text.trim(),
      birthday: _birthdayController.text.trim(),
      gender: _gender,
      species: _species.isEmpty ? 'DOG' : _species,
      personalities: _personalities,
    );
    if (mounted) Navigator.pop(context, true);
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final initial = DateTime.tryParse(_birthdayController.text) ?? DateTime(now.year - 3, now.month, now.day);
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1990),
      lastDate: DateTime(now.year + 1),
    );
    if (picked != null) {
      final s = '${picked.year.toString().padLeft(4, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
      setState(() { _birthdayController.text = s; });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF5F01),
        title: const Text('반려동물 정보 수정'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08, vertical: screenHeight * 0.02),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenHeight * 0.02),
              Text('이름', style: TextStyle(fontSize: screenWidth * 0.04, fontWeight: FontWeight.w600, color: const Color(0xFF5C5C5C))),
              SizedBox(height: screenHeight * 0.008),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(border: OutlineInputBorder()),
                validator: (v) => (v == null || v.trim().isEmpty) ? '이름을 입력해 주세요' : null,
              ),

              SizedBox(height: screenHeight * 0.02),
              Text('생년월일', style: TextStyle(fontSize: screenWidth * 0.04, fontWeight: FontWeight.w600, color: const Color(0xFF5C5C5C))),
              SizedBox(height: screenHeight * 0.008),
              GestureDetector(
                onTap: _pickDate,
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: _birthdayController,
                    decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'YYYY-MM-DD'),
                    validator: (v) => (v == null || v.trim().isEmpty) ? '생년월일을 선택해 주세요' : null,
                  ),
                ),
              ),

              SizedBox(height: screenHeight * 0.02),
              Text('성별', style: TextStyle(fontSize: screenWidth * 0.04, fontWeight: FontWeight.w600, color: const Color(0xFF5C5C5C))),
              SizedBox(height: screenHeight * 0.008),
              Row(
                children: [
                  ChoiceChip(
                    label: const Text('수컷'),
                    selected: _gender == 'M',
                    onSelected: (_) => setState(() { _gender = 'M'; }),
                  ),
                  SizedBox(width: screenWidth * 0.02),
                  ChoiceChip(
                    label: const Text('암컷'),
                    selected: _gender == 'F',
                    onSelected: (_) => setState(() { _gender = 'F'; }),
                  ),
                ],
              ),

              SizedBox(height: screenHeight * 0.04),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('취소'),
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.03),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF5F01)),
                      onPressed: _save,
                      child: const Text('저장'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}


