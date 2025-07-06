import 'package:dio/dio.dart';
import 'package:daenglog_fe/utils/secure_token_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> login(String email) async {
  final dio = Dio();
  final response = await dio.post(
    '${dotenv.env['API_URL']!}/oauth2/authorization/google',
    data: {
      'email': email,
    },
  );
  final data = response.data;
  final accessToken = data['accessToken'];
  await SecureTokenStorage.saveToken(accessToken);
}

