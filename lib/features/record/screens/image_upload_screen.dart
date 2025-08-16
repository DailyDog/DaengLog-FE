import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import '../providers/record_provider.dart';
import 'package:daenglog_fe/shared/widgets/bottom_nav_bar.dart';

class ImageUploadScreen extends StatefulWidget {
  const ImageUploadScreen({super.key});

  @override
  State<ImageUploadScreen> createState() => _ImageUploadScreenState();
}

class _ImageUploadScreenState extends State<ImageUploadScreen> {
  DateTime _selectedDate = DateTime.now();
  String _selectedAlbum = '산책';
  List<String> _selectedKeywords = ['일상', '추억'];
  List<String> _uploadedFiles = [];

  final List<String> _albums = ['산책', '사료', '놀이', '간식'];
  final List<String> _keywords = ['일상', '산책', '기념일', '여행', '추억', '+'];

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 400;
    final isLargeScreen = screenSize.width > 600;
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top header with back button
            Container(
              height: isSmallScreen ? 50 : 60,
              padding: EdgeInsets.symmetric(
                horizontal: isSmallScreen ? 16 : 20,
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: const Color(0xFF2E2E2E),
                      size: isSmallScreen ? 18 : 20,
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        '이미지 업로드',
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: isSmallScreen ? 18 : 20,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF2E2E2E),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: isSmallScreen ? 40 : 48), // Balance the layout
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: isSmallScreen ? 20 : 25,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Date selection section
                    Text(
                      '날짜 선택',
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: isSmallScreen ? 17 : 19,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF2E2E2E),
                      ),
                    ),
                    SizedBox(height: isSmallScreen ? 12 : 16),
                    
                    // Date picker field
                    Container(
                      height: isSmallScreen ? 35 : 37,
                      padding: EdgeInsets.symmetric(
                        horizontal: isSmallScreen ? 10 : 12,
                        vertical: isSmallScreen ? 5 : 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F0F0),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: isSmallScreen ? 14 : 16,
                            color: const Color(0xFF8C8B8B),
                          ),
                          SizedBox(width: isSmallScreen ? 6 : 8),
                          Text(
                            '${_selectedDate.year}.${_selectedDate.month.toString().padLeft(2, '0')}.${_selectedDate.day.toString().padLeft(2, '0')}',
                            style: TextStyle(
                              fontFamily: 'Pretendard',
                              fontSize: isSmallScreen ? 11 : 12,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF8C8B8B),
                            ),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () => _selectDate(context),
                            child: Icon(
                              Icons.keyboard_arrow_down,
                              size: isSmallScreen ? 14 : 16,
                              color: const Color(0xFF8C8B8B),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: isSmallScreen ? 24 : 32),

                    // Album selection section
                    Text(
                      '앨범',
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: isSmallScreen ? 17 : 19,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF2E2E2E),
                      ),
                    ),
                    SizedBox(height: isSmallScreen ? 12 : 16),
                    
                    // Album options
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final itemWidth = (constraints.maxWidth - 24) / 4; // 4 items with spacing
                        return Wrap(
                          spacing: isSmallScreen ? 6 : 8,
                          runSpacing: isSmallScreen ? 6 : 8,
                          children: _albums.map((album) {
                            final isSelected = _selectedAlbum == album;
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedAlbum = album;
                                });
                              },
                              child: Container(
                                width: isLargeScreen ? null : itemWidth,
                                height: isSmallScreen ? 28 : 32,
                                padding: EdgeInsets.symmetric(
                                  horizontal: isSmallScreen ? 12 : 16,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: isSelected ? const Color(0xFFFF5F01) : const Color(0xFFADADAD),
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(11),
                                ),
                                child: Center(
                                  child: Text(
                                    album,
                                    style: TextStyle(
                                      fontFamily: 'Pretendard',
                                      fontSize: isSmallScreen ? 14 : 16,
                                      fontWeight: FontWeight.w400,
                                      color: isSelected ? const Color(0xFFFF5F01) : const Color(0xFFADADAD),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      },
                    ),

                    SizedBox(height: isSmallScreen ? 24 : 32),

                    // Keyword selection section
                    Text(
                      '키워드 선택',
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: isSmallScreen ? 17 : 19,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF2E2E2E),
                      ),
                    ),
                    SizedBox(height: isSmallScreen ? 12 : 16),
                    
                    // Keyword options
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final itemWidth = (constraints.maxWidth - 24) / 6; // 6 items with spacing
                        return Wrap(
                          spacing: isSmallScreen ? 6 : 8,
                          runSpacing: isSmallScreen ? 6 : 8,
                          children: _keywords.map((keyword) {
                            final isSelected = _selectedKeywords.contains(keyword);
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (keyword == '+') {
                                    // Add custom keyword logic
                                    _showAddKeywordDialog(context);
                                  } else {
                                    if (isSelected) {
                                      _selectedKeywords.remove(keyword);
                                    } else {
                                      _selectedKeywords.add(keyword);
                                    }
                                  }
                                });
                              },
                              child: Container(
                                width: isLargeScreen ? null : itemWidth,
                                height: isSmallScreen ? 28 : 32,
                                padding: EdgeInsets.symmetric(
                                  horizontal: isSmallScreen ? 12 : 16,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: isSelected ? const Color(0xFFFF5F01) : const Color(0xFFADADAD),
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(11),
                                ),
                                child: Center(
                                  child: Text(
                                    keyword,
                                    style: TextStyle(
                                      fontFamily: 'Pretendard',
                                      fontSize: isSmallScreen ? 14 : 16,
                                      fontWeight: FontWeight.w400,
                                      color: isSelected ? const Color(0xFFFF5F01) : const Color(0xFFADADAD),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      },
                    ),

                    SizedBox(height: isSmallScreen ? 24 : 32),

                    // Selected image section
                    Text(
                      '선택된 이미지',
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: isSmallScreen ? 17 : 19,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF2E2E2E),
                      ),
                    ),
                    SizedBox(height: isSmallScreen ? 12 : 16),
                    
                    // Selected image display
                    Consumer<RecordProvider>(
                      builder: (context, recordProvider, child) {
                        if (recordProvider.selectedImage == null) {
                          return Container(
                            padding: EdgeInsets.all(isSmallScreen ? 24 : 32),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8F8F8),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0xFFE7E7E7),
                                width: 1,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                '이미지를 선택해주세요',
                                style: TextStyle(
                                  fontFamily: 'Pretendard',
                                  fontSize: isSmallScreen ? 13 : 14,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFF8C8B8B),
                                ),
                              ),
                            ),
                          );
                        }
                        
                        return Dismissible(
                          key: Key(recordProvider.selectedImage!.path),
                          direction: DismissDirection.endToStart, // 오른쪽에서 왼쪽으로만 슬라이드
                          confirmDismiss: (direction) async {
                            // 삭제 확인 다이얼로그
                            return await showDialog<bool>(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('이미지 삭제'),
                                  content: const Text('선택된 이미지를 삭제하시겠습니까?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.of(context).pop(false),
                                      child: const Text('취소'),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.of(context).pop(true),
                                      style: TextButton.styleFrom(
                                        foregroundColor: Colors.red,
                                      ),
                                      child: const Text('삭제'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          onDismissed: (direction) {
                            // 이미지 삭제 실행
                            recordProvider.clearSelections();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('이미지가 삭제되었습니다.'),
                                backgroundColor: Color(0xFFFF5F01),
                              ),
                            );
                          },
                          background: Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                  size: 24,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  '삭제',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8F8F8),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0xFFE7E7E7),
                                width: 1,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: isSmallScreen ? 50 : 60,
                                      height: isSmallScreen ? 50 : 60,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        image: DecorationImage(
                                          image: FileImage(File(recordProvider.selectedImage!.path)),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: isSmallScreen ? 12 : 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            recordProvider.selectedImage!.name,
                                            style: TextStyle(
                                              fontFamily: 'Pretendard',
                                              fontSize: isSmallScreen ? 13 : 14,
                                              fontWeight: FontWeight.w600,
                                              color: const Color(0xFF2E2E2E),
                                            ),
                                          ),
                                          SizedBox(height: isSmallScreen ? 6 : 8),
                                          Text(
                                            '${recordProvider.selectedImageSource == 'gallery' ? '갤러리' : '카메라'}에서 선택됨',
                                            style: TextStyle(
                                              fontFamily: 'Pretendard',
                                              fontSize: isSmallScreen ? 11 : 12,
                                              fontWeight: FontWeight.w400,
                                              color: const Color(0xFF8C8B8B),
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
                      },
                    ),

                    SizedBox(height: isSmallScreen ? 30 : 40),
                  ],
                ),
              ),
            ),

            // Upload button
            Container(
              padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
              child: SizedBox(
                width: double.infinity,
                height: isSmallScreen ? 50 : 57,
                child: ElevatedButton(
                  onPressed: _uploadFiles,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF5F01),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    '업로드',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: isSmallScreen ? 16 : 17,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }



  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _showAddKeywordDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('키워드 추가'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: '새로운 키워드를 입력하세요',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  setState(() {
                    _keywords.insert(_keywords.length - 1, controller.text);
                    _selectedKeywords.add(controller.text);
                  });
                  Navigator.of(context).pop();
                }
              },
              child: const Text('추가'),
            ),
          ],
        );
      },
    );
  }

  void _uploadFiles() {
    // Upload logic here
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('파일이 업로드되었습니다!'),
        backgroundColor: Color(0xFFFF5F01),
      ),
    );
    
    // Navigate back after upload
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pop(context);
    });
  }
}
