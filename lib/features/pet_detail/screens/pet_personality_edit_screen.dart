import 'package:flutter/material.dart';
import 'package:daenglog_fe/api/mypage/post/pet_update_api.dart';

class PetPersonalityEditScreen extends StatefulWidget {
  const PetPersonalityEditScreen({super.key});

  @override
  State<PetPersonalityEditScreen> createState() =>
      _PetPersonalityEditScreenState();
}

class _PetPersonalityEditScreenState extends State<PetPersonalityEditScreen> {
  final List<String> allTags = const [
    '활동적',
    '유쾌함',
    '조용함',
    '애교쟁이',
    '겁쟁이',
    '호기심왕',
    '느긋함',
    '의젓함',
    '예민함',
    '사람좋아',
    '독립적',
    '다정다감',
  ];

  Set<String> selectedTags = {};
  int? _petId;
  String _name = '';
  String _birthday = '';
  String _gender = '';
  String _species = '';
  bool _isInitialized = false;
  bool _isSaving = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isInitialized) {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null) {
        _petId = args['id'] as int?;
        _name = (args['name'] as String?) ?? '';
        _birthday = (args['birthday'] as String?) ?? '';
        _gender = (args['gender'] as String?) ?? '';
        _species = (args['species'] as String?) ?? '';

        final personalities = (args['personalities'] as List?) ?? [];
        selectedTags = Set<String>.from(personalities.cast<String>());

        _isInitialized = true;
        setState(() {});
      }
    }
  }

  Future<void> _save() async {
    if (_petId == null || _isSaving) return;

    setState(() {
      _isSaving = true;
    });

    try {
      await PetUpdateApi().updatePet(
        petId: _petId!,
        name: _name,
        birthday: _birthday,
        gender: _gender,
        species: _species.isEmpty ? 'DOG' : _species,
        personalities: selectedTags.toList(),
      );

      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('저장 실패: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  void _toggleTag(String tag) {
    setState(() {
      if (selectedTags.contains(tag)) {
        selectedTags.remove(tag);
      } else {
        if (selectedTags.length < 5) {
          selectedTags.add(tag);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('최대 5개까지만 선택 가능합니다'),
              duration: Duration(seconds: 1),
              backgroundColor: Color(0xFFFF5F01),
            ),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
          '반려동물 성격 수정',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Pretendard',
            fontSize: screenWidth * 0.045,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.08, vertical: screenHeight * 0.02),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: screenHeight * 0.02),
            RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: screenWidth * 0.05,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF484848),
                  fontFamily: 'Pretendard',
                ),
                children: [
                  TextSpan(text: _name.isNotEmpty ? '${_name}의 ' : '반려동물의 '),
                  TextSpan(
                    text: '성격',
                    style: TextStyle(color: const Color(0xFFFF5F01)),
                  ),
                  const TextSpan(text: '를 선택해 주세요!'),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
            Row(
              children: [
                Text(
                  '최대 5개까지 선택 가능해요.',
                  style: TextStyle(
                    fontSize: screenWidth * 0.035,
                    color: const Color(0xFF9A9A9A),
                    fontFamily: 'Pretendard',
                  ),
                ),
                SizedBox(width: 8),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: selectedTags.length >= 5
                        ? Colors.red[100]
                        : Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${selectedTags.length}/5',
                    style: TextStyle(
                      fontSize: screenWidth * 0.03,
                      color: selectedTags.length >= 5
                          ? Colors.red
                          : Colors.grey[600],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.03),

            // 성격 태그 그리드
            Expanded(
              child: Column(
                children: List.generate(4, (rowIndex) {
                  final startIndex = rowIndex * 3;
                  final endIndex = (startIndex + 3).clamp(0, allTags.length);
                  final rowTags = allTags.sublist(startIndex, endIndex);

                  // 각 줄마다 패딩값을 번갈아가며 적용
                  final EdgeInsets rowPadding = rowIndex % 2 == 0
                      ? const EdgeInsets.only(left: 37, right: 56)
                      : const EdgeInsets.only(left: 56, right: 37);

                  return Padding(
                    padding: rowPadding.copyWith(top: 6, bottom: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: rowTags.map((tag) {
                        final selected = selectedTags.contains(tag);
                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: GestureDetector(
                              onTap: () => _toggleTag(tag),
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 200),
                                height: 40,
                                decoration: BoxDecoration(
                                  color: selected
                                      ? const Color(0xFFFF5F01)
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: selected
                                        ? const Color(0xFFFF5F01)
                                        : const Color(0xFFEAEAEA),
                                    width: selected ? 2 : 1,
                                  ),
                                  boxShadow: selected
                                      ? [
                                          BoxShadow(
                                            color: Color(0xFFFF5F01)
                                                .withOpacity(0.3),
                                            blurRadius: 8,
                                            offset: Offset(0, 2),
                                          )
                                        ]
                                      : [],
                                ),
                                child: Center(
                                  child: Text(
                                    tag,
                                    style: TextStyle(
                                      color: selected
                                          ? Colors.white
                                          : const Color(0xFF333333),
                                      fontSize: 14,
                                      fontFamily: 'Pretendard-Medium',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  );
                }),
              ),
            ),

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
                      onPressed: _isSaving
                          ? null
                          : () {
                              setState(() {
                                selectedTags.clear();
                              });
                            },
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
                      onPressed: _isSaving ? null : _save,
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isSaving
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
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
    );
  }
}
