import 'package:flutter/material.dart';
import 'package:daenglog_fe/features/pet_info/widgets/pet_info_appbar_navbar.dart';

class PetInformationKindScreen extends StatefulWidget {
  final void Function(String kind) onNext;
  
  const PetInformationKindScreen({super.key, required this.onNext});

  @override
  State<PetInformationKindScreen> createState() => _PetInformationKindScreenState();
}

class _PetInformationKindScreenState extends State<PetInformationKindScreen> {
  String? selectedKind;

  final List<String> petKinds = ['강아지', '고양이'];

  @override
  Widget build(BuildContext context) {
    return buildPetInfoScreen(
      context: context,
      currentStep: 0,
      subject: '반려동물의 ',
      title: '종류를',
      titleSub: ' 선택해 주세요',
      subtitle: 'AI에게 전달되는 정보에요.',
      onPrevious: () {
        Navigator.pop(context,'/home_main');
      },
      isFirst: 1,
      onNext: selectedKind != null
          ? () {
              widget.onNext(selectedKind!);
            }
          : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: petKinds.map((kind) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    selectedKind = kind;
                  });
                },
                child: Container(
                  height: 56,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: selectedKind == kind 
                        ? const Color(0xFFFFEADE) 
                        : const Color(0xFFEAEAEA),
                    borderRadius: BorderRadius.circular(40),
                    border: selectedKind == kind
                        ? Border.all(color: const Color(0xFFFF5F01), width: 2)
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      kind,
                      style: TextStyle(
                        color: selectedKind == kind 
                            ? const Color(0xFFFF5F01)
                            : const Color(0xFF333333),
                        fontSize: 20,
                        fontFamily: 'Pretendard',
                        fontWeight: selectedKind == kind 
                            ? FontWeight.w700
                            : FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
