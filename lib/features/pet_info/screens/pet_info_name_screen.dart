import 'package:flutter/material.dart';
import 'package:daenglog_fe/features/pet_info/widgets/pet_info_appbar_navbar.dart';

class PetInformationNameScreen extends StatefulWidget {
  final void Function(String name, DateTime? birthday, String gender) onNext;
  
  const PetInformationNameScreen({super.key, required this.onNext});

  @override
    State<PetInformationNameScreen> createState() => _PetInformationNameScreenState();
}

class _PetInformationNameScreenState extends State<PetInformationNameScreen> {
  final TextEditingController _nameController = TextEditingController();
  DateTime? selectedBirthday;
  bool showCalendar = false;
  String? selectedGender;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedBirthday ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) { 
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFFF5F01),
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedBirthday) {
      setState(() {
        selectedBirthday = picked;
        showCalendar = false;
      });
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year}년 ${date.month}월 ${date.day}일';
  }

  @override
  Widget build(BuildContext context) {
    return buildPetInfoScreen(
      currentStep: 1,
      subject: '반려동물의 ',
      title: '정보',
      titleSub: '를 입력해 주세요',
      subtitle: 'AI에게 전달되는 정보에요.',
      onPrevious: () {
        Navigator.pushNamed(context, '/pet_information_kind');
      },
      onNext: _nameController.text.trim().isNotEmpty
          ? () {
              final name = _nameController.text.trim();
              widget.onNext(name, selectedBirthday, selectedGender! );
            }
          : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
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
                child: TextField(
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
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // 생일 선택
            GestureDetector(
              onTap: () {
                setState(() {
                  showCalendar = !showCalendar;
                });
                if (showCalendar) {
                  _selectDate(context);
                }
              },
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
                        selectedBirthday != null 
                            ? _formatDate(selectedBirthday!)
                            : '생일 선택하기',
                        style: TextStyle(
                          color: selectedBirthday != null 
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
                              selectedGender = '암컷';
                            });
                          },
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: selectedGender == '암컷'
                                  ? Color(0xFFFF5F01)
                                  : Color(0xFFEAEAEA),
                              borderRadius: BorderRadius.circular(40),
                            ),
                            child: Center(
                              child: Text(
                                '암컷',
                                style: TextStyle(
                                  color: selectedGender == '암컷'
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
                              selectedGender = '수컷';
                            });
                          },
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: selectedGender == '수컷'
                                  ? Color(0xFFFF5F01)
                                  : Color(0xFFEAEAEA),
                              borderRadius: BorderRadius.circular(40),
                            ),
                            child: Center(
                              child: Text(
                                '수컷',
                                style: TextStyle(
                                  color: selectedGender == '수컷'
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
          ],
        ),
      ),
    );
  }
}

