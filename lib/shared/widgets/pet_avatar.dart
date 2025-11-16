import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:daenglog_fe/shared/services/pet_profile_provider.dart';

class PetAvatar extends StatefulWidget {
  final String? imageUrl;
  final double size;
  final double? borderWidth;
  final Color? borderColor;
  final int? petId;
  final String fallbackAsset;

  const PetAvatar({
    super.key,
    required this.imageUrl,
    required this.size,
    this.borderWidth,
    this.borderColor,
    this.petId,
    this.fallbackAsset = 'assets/images/home/default_profile.png',
  });

  @override
  State<PetAvatar> createState() => _PetAvatarState();
}

class _PetAvatarState extends State<PetAvatar> {
  bool _hasRetried = false;
  bool _isRetrying = false;
  String? _currentImageUrl;

  @override
  void initState() {
    super.initState();
    _currentImageUrl = widget.imageUrl;
  }

  @override
  void didUpdateWidget(PetAvatar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imageUrl != widget.imageUrl) {
      _currentImageUrl = widget.imageUrl;
      _hasRetried = false;
      _isRetrying = false;
    }
  }

  Future<void> _retryImageLoad() async {
    if (_hasRetried || _isRetrying || widget.petId == null) return;

    setState(() {
      _isRetrying = true;
    });

    _hasRetried = true;
    debugPrint('🔄 403 에러로 인한 이미지 URL 재요청: petId=${widget.petId}');

    try {
      if (!mounted) {
        _isRetrying = false;
        return;
      }
      final provider = Provider.of<PetProfileProvider>(context, listen: false);
      final newUrl = await provider.refreshPetImageUrl(widget.petId!);

      if (newUrl != null && newUrl != _currentImageUrl && mounted) {
        setState(() {
          _currentImageUrl = newUrl;
          _isRetrying = false;
        });
      } else {
        setState(() {
          _isRetrying = false;
        });
      }
    } catch (e) {
      debugPrint('🔴 이미지 URL 갱신 실패: $e');
      if (mounted) {
        setState(() {
          _isRetrying = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        children: [
          // 이미지 부분
          ClipOval(
            child: _buildImageContent(),
          ),
          // 테두리는 필요할 때만 사용 (기본 마이페이지 아바타에는 발광 효과 제거)
          if (widget.borderWidth != null && widget.borderColor != null)
            CustomPaint(
              painter: CircleBorderPainter(
                  color: widget.borderColor!, strokeWidth: widget.borderWidth!),
              child: SizedBox(
                width: widget.size,
                height: widget.size,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildImageContent() {
    if (_isRetrying) {
      return Container(
        width: widget.size,
        height: widget.size,
        color: Colors.grey[200],
        child: const Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }

    final imageUrl = _currentImageUrl;

    if (imageUrl == null || imageUrl.isEmpty) {
      return _buildFallbackImage();
    }

    // URI 검증
    try {
      final uri = Uri.parse(imageUrl);
      if (!uri.hasScheme || uri.host.isEmpty) {
        debugPrint('🔴 잘못된 URI 형식: $imageUrl');
        return _buildFallbackImage();
      }
    } catch (e) {
      debugPrint('🔴 URI 파싱 실패: $imageUrl - $e');
      return _buildFallbackImage();
    }

    return Image.network(
      imageUrl,
      width: widget.size,
      height: widget.size,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        debugPrint('🔴 Image.network 에러: $error');

        // 403 에러이고 아직 재시도하지 않았다면
        if (error.toString().contains('403') && !_hasRetried && !_isRetrying) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              _retryImageLoad();
            }
          });
        }

        return _buildFallbackImage();
      },
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          return child;
        }

        return Container(
          width: widget.size,
          height: widget.size,
          color: Colors.grey[100],
          child: const Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFallbackImage() {
    return Image.asset(
      widget.fallbackAsset,
      width: widget.size,
      height: widget.size,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        debugPrint("🔴 Asset 이미지도 로드 실패: $error");
        return Container(
          width: widget.size,
          height: widget.size,
          color: Colors.grey[300],
          child: const Center(
            child: Icon(Icons.pets, color: Colors.white, size: 30),
          ),
        );
      },
    );
  }
}

class CircleBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  CircleBorderPainter({
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - (strokeWidth / 2);

    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
