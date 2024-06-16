// auth_service.dart
import 'dart:convert';
import 'package:auth_test/models/profile.dart';
import 'package:auth_test/models/company.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final String baseUrl =
      'http://ip172-18-0-13-cpngtia91nsg00ffufv0-3010.direct.labs.play-with-docker.com/api/v1';

  Future<Map<String, dynamic>> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/sign-in'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      final token = responseBody['token'];
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);

      final profile = Profile.fromJson(responseBody['profile']);
      return {
        'token': token,
        'profile': profile,
      };
    } else {
      throw Exception('Error en el inicio de sesión');
    }
  }

  Future<void> signUp(
    String username,
    String firstName,
    String lastName,
    String password,
    String invitationCode,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/sign-up'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'firstName': firstName,
        'lastName': lastName,
        'password': password,
        'invitationCode': invitationCode,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Error al registrar el usuario');
    }
  }

  Future<void> registerCompany(Company company, String token) async {
    final response = await http.post(
      Uri.parse('$baseUrl/companies'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(company.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Error al registrar la compañía');
    }
  }

  Future<String?> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }
}
