import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/record_provider.dart';

class MediaSelectionBottomSheet extends StatelessWidget {
  const MediaSelectionBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 헤더
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              children: [
                // 드래그 핸들
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 16),

                // 제목
                const Text(
                  '추억 기록하기',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF272727),
                  ),
                ),
                const SizedBox(height: 8),

                // 부제목
                Text(
                  '어떤 방식으로 기록하시겠어요?',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),

          // 옵션 목록
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                // 갤러리 선택
                _buildOptionTile(
                  context: context,
                  icon: Icons.photo_library_outlined,
                  title: '갤러리',
                  subtitle: '기존 사진에서 선택',
                  color: const Color(0xFF4CAF50),
                  onTap: () {
                    context.read<RecordProvider>().selectFromGallery(context);
                  },
                ),

                const SizedBox(height: 12),

                // 카메라 선택
                _buildOptionTile(
                  context: context,
                  icon: Icons.camera_alt_outlined,
                  title: '카메라',
                  subtitle: '지금 바로 촬영',
                  color: const Color(0xFF2196F3),
                  onTap: () {
                    context.read<RecordProvider>().selectFromCamera(context);
                  },
                ),

                const SizedBox(height: 12),

                // 파일 선택
                _buildOptionTile(
                  context: context,
                  icon: Icons.insert_drive_file_outlined,
                  title: '파일',
                  subtitle: '기기에서 파일 선택',
                  color: const Color(0xFFFF9800),
                  onTap: () {
                    context.read<RecordProvider>().selectFromFiles(context);
                  },
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Row(
          children: [
            // 아이콘
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),

            const SizedBox(width: 16),

            // 텍스트 정보
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF272727),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),

            // 화살표
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey[400],
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
