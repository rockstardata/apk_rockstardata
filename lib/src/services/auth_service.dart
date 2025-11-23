import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'storage_service.dart';
import 'logger_service.dart';

/// Servicio de autenticación
class AuthService {
  static final AuthService instance = AuthService._internal();
  AuthService._internal();

  final ValueNotifier<bool> isAuthenticated = ValueNotifier<bool>(false);
  final ValueNotifier<Map<String, dynamic>?> currentUser =
      ValueNotifier<Map<String, dynamic>?>(null);

  // URL base del backend desde .env
  String get _baseUrl => dotenv.env['API_URL'] ?? 'http://10.0.2.2:3000';

  /// Inicializa el servicio y verifica si hay sesión guardada
  Future<void> initialize() async {
    try {
      final userData = await StorageService.instance.getUserData();
      if (userData != null) {
        currentUser.value = userData;
        isAuthenticated.value = true;
        LoggerService.instance.info('Usuario autenticado desde almacenamiento');
      }
    } catch (e) {
      LoggerService.instance.error('Error al inicializar AuthService: $e');
    }
  }

  /// Registra un nuevo usuario
  Future<bool> register({
    required String name,
    required String email,
    required String restaurantName,
    String? phone,
    String? address,
    required String city,
    required String country,
  }) async {
    try {
      final userData = {
        'name': name,
        'email': email,
        'restaurantName': restaurantName,
        'phone': phone ?? '',
        'address': address ?? '',
        'city': city,
        'country': country,
        'createdAt': DateTime.now().toIso8601String(),
      };

      await StorageService.instance.saveUserData(userData);
      currentUser.value = userData;
      isAuthenticated.value = true;

      LoggerService.instance.info('Usuario registrado: $email');
      return true;
    } catch (e) {
      LoggerService.instance.error('Error al registrar usuario: $e');
      return false;
    }
  }

  /// Inicia sesión contra la API NestJS
  Future<bool> login(String email, String password) async {
    try {
      LoggerService.instance.info('Intentando login para: $email');

      final response = await http.post(
        Uri.parse('$_baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final token =
            data['access_token'] ??
            data['token']; // Ajustar según respuesta real

        // Decodificar token o usar datos del usuario si vienen en la respuesta
        // Por ahora simulamos datos de usuario básicos + token
        final userData = {
          'email': email,
          'token': token,
          'name': 'Usuario API', // Idealmente el backend debería devolver esto
          'restaurantName': 'Restaurante API',
        };

        await StorageService.instance.saveUserData(userData);
        currentUser.value = userData;
        isAuthenticated.value = true;
        LoggerService.instance.info('Login exitoso API: $email');
        return true;
      } else {
        LoggerService.instance.error(
          'Login fallido: ${response.statusCode} - ${response.body}',
        );
        return false;
      }
    } catch (e) {
      LoggerService.instance.error('Error al iniciar sesión API: $e');
      return false;
    }
  }

  /// Login simulado con Google (Placeholder)
  Future<bool> loginWithGoogle() async {
    // Aquí iría la implementación real con google_sign_in
    await Future.delayed(const Duration(seconds: 1));
    final userData = {
      'name': 'Usuario Google',
      'email': 'google@example.com',
      'restaurantName': 'Restaurante Google',
    };
    await StorageService.instance.saveUserData(userData);
    currentUser.value = userData;
    isAuthenticated.value = true;
    return true;
  }

  /// Cierra sesión
  Future<void> logout() async {
    try {
      await StorageService.instance.remove('user_data');
      currentUser.value = null;
      isAuthenticated.value = false;
      LoggerService.instance.info('Usuario cerró sesión');
    } catch (e) {
      LoggerService.instance.error('Error al cerrar sesión: $e');
    }
  }

  /// Verifica si el usuario está autenticado
  bool get isLoggedIn => isAuthenticated.value;
}
