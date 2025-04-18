import 'package:dio/dio.dart';

class ApiService {
  final _baseUrl = 'http://10.0.2.2:5000/api/';
  final Dio _dio;

  ApiService(this._dio);

  Future<dynamic> get({required String endPoint}) async {
    var response = await _dio.get('$_baseUrl$endPoint');
    return response.data;
  }

  Future<dynamic> post({
    required String endPoint,
    required Map<String, dynamic> data,
  }) async {
    try {
      var response = await _dio.post('$_baseUrl$endPoint', data: data);
      return response.data;
    } catch (e) {
      print('Error during POST request: $e');
      rethrow; // You can handle the error as you wish
    }
  }
}
