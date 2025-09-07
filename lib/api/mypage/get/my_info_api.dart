import 'package:dio/dio.dart';
import 'package:daenglog_fe/shared/services/dio_client.dart';
import 'package:daenglog_fe/api/mypage/models/my_info.dart';

class MyInfoApi {
  final Dio _dio = getDioWithAuth('api/v1/users');

  Future<MyInfoModel> getMyInfo() async {
    try {
      final response = await _dio.get(
        '/my-Info',
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
      return MyInfoModel.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      throw Exception('내 정보 불러오기 실패: $e');
    }
  }
}


