import 'package:flutter/material.dart';
import 'package:daenglog_fe/api/mypage/post/pet_update_api.dart';

class PetPersonalityEditScreen extends StatefulWidget {
  const PetPersonalityEditScreen({super.key});

  @override
  State<PetPersonalityEditScreen> createState() => _PetPersonalityEditScreenState();
}

class _PetPersonalityEditScreenState extends State<PetPersonalityEditScreen> {
  final List<String> allTags = const [
    '활동적', '유쾌함', '조용함',
    '애교쟁이', '겁쟁이', '호기심왕',
    '느긋함', '의젓함', '예민함',
    '사람좋아', '독립적', '다정다감',
  ];
  late Set<String> selectedTags;
  int? _petId;
  String _name = '';
  String _birthday = '';
  String _gender = '';
  String _species = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    _petId = args?['id'] as int?;
    _name = (args?['name'] as String?) ?? '';
    _birthday = (args?['birthday'] as String?) ?? '';
    _gender = (args?['gender'] as String?) ?? '';
    _species = (args?['species'] as String?) ?? '';
    selectedTags = Set<String>.from(((args?['personalities'] as List?)?.cast<String>()) ?? const <String>[]);
  }

  Future<void> _save() async {
    if (_petId == null) return;
    await PetUpdateApi().updatePet(
      petId: _petId!,
      name: _name,
      birthday: _birthday,
      gender: _gender,
      species: _species.isEmpty ? 'DOG' : _species,
      personalities: selectedTags.toList(),
    );
    if (mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF5F01),
        title: const Text('반려동물 성격 수정'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08, vertical: screenHeight * 0.02),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: screenHeight * 0.01),
            Text(
              _name.isNotEmpty ? '${_name}의 성격을 선택해 주세요' : '성격을 선택해 주세요',
              style: TextStyle(fontSize: screenWidth * 0.05, fontWeight: FontWeight.w700, color: const Color(0xFF484848)),
            ),
            SizedBox(height: screenHeight * 0.006),
            Text('최대 5개까지 선택 가능해요.', style: TextStyle(fontSize: screenWidth * 0.032, color: const Color(0xFF9A9A9A))),
            SizedBox(height: screenHeight * 0.02),
            Wrap(
              spacing: screenWidth * 0.02,
              runSpacing: screenHeight * 0.012,
              children: allTags.map((tag) {
                final selected = selectedTags.contains(tag);
                return ChoiceChip(
                  label: Text(tag),
                  selected: selected,
                  onSelected: (_) {
                    setState(() {
                      if (selected) {
                        selectedTags.remove(tag);
                      } else {
                        if (selectedTags.length < 5) selectedTags.add(tag);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => setState(() { selectedTags.clear(); }),
                    child: const Text('초기화'),
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
    );
  }
}


