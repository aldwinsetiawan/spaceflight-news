import 'package:dio/dio.dart';
import '../constants/constant.dart';
import 'network_interceptor.dart';

class ApiClient {
  factory ApiClient() {
    return _apiClient;
  }
  ApiClient._internal();

  static final ApiClient _apiClient = ApiClient._internal();

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: AppConstants.apiUrl + AppConstants.apiVersion,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ),
  )..interceptors.add(NetworkInterceptor());

  Dio get dio {
    return _dio;
  }
}
