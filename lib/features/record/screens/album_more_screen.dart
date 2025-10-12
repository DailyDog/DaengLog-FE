import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:daenglog_fe/api/album/get/album_pet_api.dart';
import 'package:daenglog_fe/api/album/models/album_item.dart';
import 'package:daenglog_fe/api/album/post/album_create_api.dart';
import 'package:daenglog_fe/features/record/providers/record_provider.dart';
import 'package:go_router/go_router.dart';

class AlbumMoreScreen extends StatefulWidget {
  const AlbumMoreScreen({super.key});

  @override
  State<AlbumMoreScreen> createState() => _AlbumMoreScreenState();
}

class _AlbumMoreScreenState extends State<AlbumMoreScreen> {
  bool _isGridView = true; // true: 앨범형, false: 목록형
  late Future<List<AlbumItem>> _albumsFuture;

  @override
  void initState() {
    super.initState();
    final recordProvider = context.read<RecordProvider>();
    if (recordProvider.selectedPet != null) {
      _albumsFuture =
          AlbumPetApi().getAlbumsByPet(recordProvider.selectedPet!.id);
    } else {
      _albumsFuture = Future.value(<AlbumItem>[]);
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final scale = (width / 393.0).clamp(0.8, 1.4);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.go('/record'),
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Color(0xFF272727),
          ),
        ),
        title: Text(
          '앨범',
          style: TextStyle(
            fontFamily: 'Pretendard',
            fontSize: (18 * scale).clamp(16.0, 20.0),
            fontWeight: FontWeight.w700,
            color: const Color(0xFF272727),
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _toggleView,
            icon: Icon(
              _isGridView ? Icons.list : Icons.grid_view,
              color: const Color(0xFF666666),
            ),
          ),
          Consumer<RecordProvider>(
            builder: (context, recordProvider, child) {
              return IconButton(
                onPressed: recordProvider.selectedPet != null
                    ? _showCreateAlbumDialog
                    : () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('반려동물을 먼저 선택해주세요'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      },
                icon: const Icon(
                  Icons.add,
                  color: Color(0xFFFF5F01),
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<RecordProvider>(
        builder: (context, recordProvider, child) {
          if (recordProvider.selectedPet == null) {
            return _buildEmptyState('반려동물을 선택해주세요', scale);
          }

          return RefreshIndicator(
            onRefresh: () async {
              setState(() {
                _albumsFuture = AlbumPetApi()
                    .getAlbumsByPet(recordProvider.selectedPet!.id);
              });
            },
            child: FutureBuilder<List<AlbumItem>>(
              future: _albumsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return _buildEmptyState('앨범을 불러오지 못했습니다', scale);
                }
                final albums = snapshot.data ?? <AlbumItem>[];
                if (albums.isEmpty) {
                  return _buildEmptyState('아직 앨범이 없습니다', scale);
                }

                return _isGridView
                    ? _buildGridView(albums, scale)
                    : _buildListView(albums, scale);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildGridView(List<AlbumItem> albums, double scale) {
    return Padding(
      padding: EdgeInsets.all(20 * scale),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 20 * scale,
          mainAxisSpacing: 20 * scale,
          childAspectRatio: 0.75,
        ),
        itemCount: albums.length,
        itemBuilder: (context, index) {
          final album = albums[index];
          return _AlbumGridCard(
            album: album,
            onTap: () => context.go('/album-detail/${album.albumId}'),
          );
        },
      ),
    );
  }

  Widget _buildListView(List<AlbumItem> albums, double scale) {
    return ListView.builder(
      padding: EdgeInsets.all(20 * scale),
      itemCount: albums.length,
      itemBuilder: (context, index) {
        final album = albums[index];
        return Padding(
          padding: EdgeInsets.only(bottom: 12 * scale),
          child: _AlbumListCard(
            album: album,
            onTap: () => context.go('/album-detail/${album.albumId}'),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(String message, double scale) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.photo_library_outlined,
            size: (64 * scale).clamp(48.0, 80.0),
            color: const Color(0xFFCCCCCC),
          ),
          SizedBox(height: 16 * scale),
          Text(
            message,
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: (16 * scale).clamp(14.0, 18.0),
              color: const Color(0xFF999999),
            ),
          ),
        ],
      ),
    );
  }

  void _toggleView() {
    setState(() {
      _isGridView = !_isGridView;
    });
  }

  void _showCreateAlbumDialog() {
    final TextEditingController controller = TextEditingController();
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 400;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.symmetric(
            horizontal: isSmallScreen ? 24 : 32,
          ),
          child: Container(
            padding: EdgeInsets.all(isSmallScreen ? 24 : 32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title
                Text(
                  '새 앨범 만들기',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: isSmallScreen ? 18 : 20,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF272727),
                  ),
                ),

                SizedBox(height: isSmallScreen ? 16 : 20),

                // Content
                Text(
                  '앨범 이름을 입력해주세요',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: isSmallScreen ? 14 : 16,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF666666),
                  ),
                ),

                SizedBox(height: isSmallScreen ? 20 : 24),

                // Text field
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F8F8),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFFE0E0E0),
                      width: 1,
                    ),
                  ),
                  child: TextField(
                    controller: controller,
                    autofocus: true,
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: isSmallScreen ? 14 : 16,
                      color: const Color(0xFF272727),
                    ),
                    decoration: InputDecoration(
                      hintText: '앨범 이름을 입력하세요',
                      hintStyle: TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: isSmallScreen ? 14 : 16,
                        color: const Color(0xFF999999),
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: isSmallScreen ? 16 : 20,
                        vertical: isSmallScreen ? 12 : 16,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: isSmallScreen ? 24 : 32),

                // Buttons
                Row(
                  children: [
                    // Cancel button
                    Expanded(
                      child: Container(
                        height: isSmallScreen ? 48 : 52,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFFE0E0E0),
                            width: 1,
                          ),
                        ),
                        child: TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            '취소',
                            style: TextStyle(
                              fontFamily: 'Pretendard',
                              fontSize: isSmallScreen ? 14 : 16,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF666666),
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(width: isSmallScreen ? 12 : 16),

                    // Create button
                    Expanded(
                      child: Container(
                        height: isSmallScreen ? 48 : 52,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF5F01),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TextButton(
                          onPressed: () async {
                            if (controller.text.trim().isNotEmpty) {
                              await _createAlbum(controller.text.trim());
                              Navigator.of(context).pop();
                            }
                          },
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            '만들기',
                            style: TextStyle(
                              fontFamily: 'Pretendard',
                              fontSize: isSmallScreen ? 14 : 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _createAlbum(String name) async {
    try {
      final recordProvider = context.read<RecordProvider>();
      final petId = recordProvider.selectedPet?.id;

      if (petId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('반려동물을 먼저 선택해주세요'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      await AlbumCreateApi().createAlbum(name, petId: petId);
      setState(() {
        _albumsFuture =
            AlbumPetApi().getAlbumsByPet(recordProvider.selectedPet!.id);
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('"$name" 앨범이 생성되었습니다'),
            backgroundColor: const Color(0xFFFF5F01),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('앨범 생성에 실패했습니다: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

class _AlbumGridCard extends StatelessWidget {
  final AlbumItem album;
  final VoidCallback onTap;

  const _AlbumGridCard({
    required this.album,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final scale = (width / 393.0).clamp(0.8, 1.4);
    final hasUrl = (album.thumbnailImageUrl ?? '').isNotEmpty;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  color: const Color(0xFFF5F5F5),
                  image: hasUrl
                      ? DecorationImage(
                          image: NetworkImage(album.thumbnailImageUrl!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: Stack(
                  children: [
                    if (!hasUrl)
                      Center(
                        child: Icon(
                          Icons.photo_library_outlined,
                          size: (40 * scale).clamp(32.0, 48.0),
                          color: const Color(0xFFCCCCCC),
                        ),
                      ),
                    // Photo count badge
                    Positioned(
                      top: 8 * scale,
                      right: 8 * scale,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8 * scale,
                          vertical: 4 * scale,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${album.imageCount}',
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: (12 * scale).clamp(10.0, 14.0),
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Album info
            Container(
              height: 60 * scale,
              padding: EdgeInsets.all(8 * scale),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      album.name,
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: (13 * scale).clamp(11.0, 15.0),
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF272727),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    '${album.imageCount}개의 사진',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: (11 * scale).clamp(9.0, 13.0),
                      color: const Color(0xFF666666),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AlbumListCard extends StatelessWidget {
  final AlbumItem album;
  final VoidCallback onTap;

  const _AlbumListCard({
    required this.album,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final scale = (width / 393.0).clamp(0.8, 1.4);
    final hasUrl = (album.thumbnailImageUrl ?? '').isNotEmpty;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16 * scale),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Thumbnail
            Container(
              width: 60 * scale,
              height: 60 * scale,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: const Color(0xFFF5F5F5),
                image: hasUrl
                    ? DecorationImage(
                        image: NetworkImage(album.thumbnailImageUrl!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: !hasUrl
                  ? Center(
                      child: Icon(
                        Icons.photo_library_outlined,
                        size: (24 * scale).clamp(20.0, 28.0),
                        color: const Color(0xFFCCCCCC),
                      ),
                    )
                  : null,
            ),
            SizedBox(width: 16 * scale),
            // Album info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    album.name,
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: (16 * scale).clamp(14.0, 18.0),
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF272727),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4 * scale),
                  Text(
                    '${album.imageCount}개의 사진',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: (14 * scale).clamp(12.0, 16.0),
                      color: const Color(0xFF666666),
                    ),
                  ),
                ],
              ),
            ),
            // Arrow icon
            Icon(
              Icons.arrow_forward_ios,
              size: (16 * scale).clamp(14.0, 18.0),
              color: const Color(0xFFCCCCCC),
            ),
          ],
        ),
      ),
    );
  }
}
