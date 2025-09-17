import 'package:dio/dio.dart';

import '../../../../core/network/api_client.dart';
import '../model/news.dart';

class NewsRepository {
  final Dio _dio = ApiClient().dio;

  Future<Map<String, dynamic>> fetchNews(String? url) async {
    final urlString = url ?? "/articles";
    urlString.replaceAll("https://api.spaceflightnewsapi.net/v4", '');
    final response = await _dio.get(urlString);
    final List data = response.data['results'];
    return {
      "hasNext": response.data['next'],
      "result": data.map((json) => News.fromJson(json)).toList(),
    };
  }

  Future<News> fetchNewsDetail(int id) async {
    final response = await _dio.get("/news/$id");
    return News.fromJson(response.data);
  }
}
