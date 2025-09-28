import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/services.dart';
import 'dart:io';



class EnvelopeReceiveScreen extends StatefulWidget {
  const EnvelopeReceiveScreen({Key? key}) : super(key: key);

  @override
  State<EnvelopeReceiveScreen> createState() => _EnvelopeReceiveScreenState();
}

class _EnvelopeReceiveScreenState extends State<EnvelopeReceiveScreen>
    with TickerProviderStateMixin {
  final GlobalKey contentKey = GlobalKey();
  Uint8List? capturedImageBytes;
  bool isConfirmed = false;
  bool _isEnvelopeOpened = false; // 편지 열림 상태 관리
  bool _showOpenedEnvelope = false; // 열린 편지 표시 상태
  bool _showDarkBackground = false; // 어두운 배경 표시 상태
  bool _showClosedEnvelope = false; // 닫힌 편지 표시 상태

  @override
  void initState() {
    super.initState();
    // 초기 상태 설정
    _showClosedEnvelope = true;
  }

  Future<void> captureAndConvertToJpg() async {
    try {
      // 프레임 색상 변경이 반영되도록 더 긴 지연 시간
      await Future.delayed(const Duration(milliseconds: 200));
      RenderRepaintBoundary boundary = contentKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData != null) {
        setState(() {
          capturedImageBytes = byteData.buffer.asUint8List();
          isConfirmed = true;
        });
      }
    } catch (e) {
      print('이미지 캡처 오류: $e');
    }
  }

  // --- 이미지 공유 ---
  void shareImage() async {
    if (capturedImageBytes == null) return;
    final directory = await getTemporaryDirectory();
    final imagePath = '${directory.path}/photo_card.jpg';
    final imageFile = File(imagePath);
    await imageFile.writeAsBytes(capturedImageBytes!);
    await Share.shareXFiles([
      XFile(imagePath),
    ]);
  }
  void saveImageToGallery() async {
    try {
      // assets/images/test.png 파일을 바이트로 읽기
      final ByteData data = await rootBundle.load('assets/images/test.png');
      final Uint8List bytes = data.buffer.asUint8List();
      
      final result = await ImageGallerySaver.saveImage(
        bytes,
        quality: 100,
        name: 'daenglog_${DateTime.now().millisecondsSinceEpoch}',
        isReturnImagePathOfIOS: true,
      );
      
      if (result['isSuccess'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('갤러리에 저장되었습니다!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('저장에 실패했습니다.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('저장 중 오류가 발생했습니다.')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: !_isEnvelopeOpened ? IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Color(0xFFFF5F01),
          ),
          onPressed: () => Navigator.pushNamed(context, '/home'),
        ) : IconButton(
          icon: const Icon(
            Icons.home_outlined,
            color: Color(0xFFFF5F01),
            size: 30,
          ),
          onPressed: () => Navigator.pushNamed(context, '/home'),
        ),
        actions: _isEnvelopeOpened ? [
          IconButton(
            icon: Image.asset(
              'assets/images/chat/download_icon.png',
              width: 30,
              height: 30,
            ),
            onPressed: () async {
              // 다운로드 기능 구현
              saveImageToGallery();
            },
          ),
        ] : null,
        title: const Text(
          '편지',
          style: TextStyle(
            color: Color(0xFF272727),
            fontSize: 20,
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/family/send_back.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        // API 연동 필요
        child: Stack(
                      children: [
              // 어두운 배경
              AnimatedOpacity(
                opacity: _showDarkBackground ? 0.7 : 0.0,
                duration: const Duration(milliseconds: 500),
                child: Container(
                  color: Colors.black,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
              // 닫힌 편지 (조건부 렌더링)
              if (!_isEnvelopeOpened)
                _buildClosedEnvelope(),
              if (_isEnvelopeOpened)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 1000),
                  curve: Curves.easeInOut,
                  transform: Matrix4.translationValues(
                    0, 
                    _showOpenedEnvelope ? 0 : MediaQuery.of(context).size.height, 
                    0
                  ),
                  child: _buildOpenedEnvelope(), // 열린 편지 표시
                ),
            ],
        ),
      ),
    );
  }

//---------------------------------------------------------------

  // 편지가 닫혀있을 때의 UI
  Widget _buildClosedEnvelope() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Text(
          '엄마님이\n 망고의 사진과 편지를 전송했습니다',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 14),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '해당 편지는 수신을 끌 수 있어요 ',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFFADADAD),
                fontSize: 14,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w500,
              ),
            ),
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('편지 수신 안내'),
                      content: Text('해당 편지는 수신을 끌 수 있어요'), 
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('확인'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Icon(Icons.help_outline, color: Colors.grey, size: 16),
            ),
          ],
        ),
        Container(
          width: 400,
          height: 400,
          child: Image.asset('assets/images/family/envelope.png'),
        ),
        Text(
          '"오늘 망고 간식주고 찍은 사진이야!"',
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontFamily: 'Yeongdeok-Sea',
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 40),
        Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: ElevatedButton(
            onPressed: () {
              _startEnvelopeAnimation();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF5F01),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text(
              '열어보기',
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // 편지가 열렸을 때의 UI
  Widget _buildOpenedEnvelope() {
    return Center(
      child: Container(
        width: 350,
        height: 650,
        padding: const EdgeInsets.fromLTRB(5, 40, 5, 5),  // 사진을 약간 축소하는 효과
        decoration: BoxDecoration(
          border: Border.all(color: Color(0xFFFF5F01), width: 3),
          borderRadius: BorderRadius.circular(40),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Image.asset(
            'assets/images/test.png',
            fit: BoxFit.cover,  // 프레임을 꽉 채움
          ),
        ),
      ),
    );
  }

  // 편지 열기 애니메이션 시작
  void _startEnvelopeAnimation() async {
    // 열린 편지 상태로 변경 (닫힌 편지가 조건부 렌더링으로 사라짐)
    setState(() {
      _isEnvelopeOpened = true;
    });

    // 1초 대기
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _showOpenedEnvelope = true; // 편지 열기
      _showDarkBackground = true; // 어두운 배경과 함께
    });

    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _showDarkBackground = false; // 어두운 배경 사라짐
    });
  }
}