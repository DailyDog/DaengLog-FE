import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:daenglog_fe/features/pet_info/widgets/pet_info_appbar_navbar.dart';
import 'package:daenglog_fe/features/pet_info/providers/pet_info_provider.dart';
import 'package:provider/provider.dart';

class PetInformationKindScreen extends StatefulWidget {
  const PetInformationKindScreen({super.key});

  @override
  State<PetInformationKindScreen> createState() =>
      _PetInformationKindScreenState();
}

class _PetInformationKindScreenState extends State<PetInformationKindScreen> {
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
        if (context.canPop()) {
          context.pop();
        } else {
          context.go('/home');
        }
      },
      isFirst: 1,
      onNext: context.read<PetInfoProvider>().getPetKind() != null
          ? () async {
              final petInfo = context.read<PetInfoProvider>();
              petInfo.setPetKind(petInfo.getPetKind()!);
              context.go('/pet_information_name');
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
                  final petInfo = context.read<PetInfoProvider>();
                  petInfo.setState(() {
                    petInfo.currentStep = 0;
                    petInfo.setPetKind(kind);
                  });
                },
                child: Container(
                  height: 56,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: context.watch<PetInfoProvider>().getPetKind() == kind
                        ? const Color(0xFFFFEADE)
                        : const Color(0xFFEAEAEA),
                    borderRadius: BorderRadius.circular(40),
                    border: context.watch<PetInfoProvider>().getPetKind() ==
                            kind
                        ? Border.all(color: const Color(0xFFFF5F01), width: 2)
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      kind,
                      style: TextStyle(
                        color: context.watch<PetInfoProvider>().getPetKind() ==
                                kind
                            ? const Color(0xFFFF5F01)
                            : const Color(0xFF333333),
                        fontSize: 20,
                        fontFamily: 'Pretendard',
                        fontWeight:
                            context.watch<PetInfoProvider>().getPetKind() ==
                                    kind
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
