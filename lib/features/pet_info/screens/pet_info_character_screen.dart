import 'package:flutter/material.dart';
import 'package:daenglog_fe/features/pet_info/widgets/pet_info_appbar_navbar.dart';
import 'package:daenglog_fe/features/pet_info/widgets/pet_info_character_select.dart';
import 'package:daenglog_fe/features/pet_info/providers/pet_info_provider.dart';
import 'package:provider/provider.dart';

class PetInformationCharacterScreen extends StatefulWidget {
  PetInformationCharacterScreen({super.key});

  @override
  State<PetInformationCharacterScreen> createState() => _PetInformationCharacterScreenState();
}

class _PetInformationCharacterScreenState extends State<PetInformationCharacterScreen> {
  final List<String> allTags = [
    '활동적', '유쾌함', '조용함',
    '애교쟁이', '겁쟁이', '호기심왕',
    '느긋함', '의젓함', '예민함',
    '사람좋아', '독립적', '다정다감',
  ];

  final Set<String> selectedTags = {};

  void toggleTag(String tag) {
    setState(() {
      if (selectedTags.contains(tag)) {
        selectedTags.remove(tag);
      } else {
        if (selectedTags.length < 5) {
          selectedTags.add(tag);
        }
      }
    });
  }

  List<List<String>> chunkedTags(List<String> tags, int size) {
    List<List<String>> chunks = [];
    for (var i = 0; i < tags.length; i += size) {
      chunks.add(tags.sublist(i, i + size > tags.length ? tags.length : i + size));
    }
    return chunks;
  }

  @override
  Widget build(BuildContext context) {
    final chunked = chunkedTags(allTags, 3);

    // 각 줄마다 패딩값을 번갈아가며 적용
    final List<EdgeInsets> paddings = [
      const EdgeInsets.only(left: 37, right: 56), // 1번째 줄
      const EdgeInsets.only(left: 56, right: 37), // 2번째 줄
      const EdgeInsets.only(left: 37, right: 56), // 3번째 줄
      const EdgeInsets.only(left: 56, right: 37), // 4번째 줄
    ];

    return buildPetInfoScreen(
      context: context,
      currentStep: 2,
      subject: PetInfoProvider().getPetName() != null ? '${PetInfoProvider().getPetName()}의 ' : '반려동물의 ',
      title: '성격',
      titleSub: '를 선택해 주세요!',
      subtitle: '최대 5개까지 선택 가능해요.',
      onPrevious: () {
        Navigator.pushNamed(context, '/pet_information_name');
      },
      isFirst: 1,
      onNext: selectedTags.isNotEmpty
          ? () async {
              final characters = selectedTags.toList();
              final petInfo = context.read<PetInfoProvider>();
              petInfo.setPetCharacters(characters);
              Navigator.pushNamed(context, '/pet_information_profile');
            }
          : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: List.generate(chunked.length, (i) {
            return Padding(
              padding: paddings[i % paddings.length].copyWith(top: 6, bottom: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: chunked[i].map((tag) {
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: PetInfoCharacterSelect(
                        label: tag,
                        isSelected: selectedTags.contains(tag),
                        onTap: () => toggleTag(tag),
                      ),
                    ),
                  );
                }).toList(),
              ),
            );
          }),
        ),
      ),
    );
  }
}