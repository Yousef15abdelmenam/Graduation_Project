import 'package:graduation_project/core/utils/api.dart';
import 'package:graduation_project/features/login/data/models/login_model.dart';

class LoginService {
  Future<dynamic> loginUser({
    required String email,
    required String password,
  }) async {
    final Map<String, String> requestBody = {
      'email': email,
      'password': password,
    };

    final dynamic response = await Api().post(
      url: 'http://10.0.2.2:5000/api/Auth/login',
      body: requestBody,
      token: null,
    );

    // Log the entire response for debugging
    print("🧪 Full Login Response: $response");

    // Check if the response is a Map and contains 'data'
    if (response is Map<String, dynamic> && response.containsKey('data')) {
      final data = response['data'];
      print("Login response data: $data");

      // Check if 'message' exists and contains the failure message
      if (data['message'] == "Invalid email or password") {
        throw Exception("Login failed: Invalid email or password");
      }

      // Ensure the token is not null
      if (data['token'] == null) {
        throw Exception("Login failed: No token received");
      }

      // If we have a valid token, proceed to return user data
      return {'user': LoginModel.fromJson(data)};
    } else {
      // If the response format is unexpected, throw an exception
      throw Exception("Unexpected response format: $response");
    }
  }
}
