import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/app_config.dart';
import '../models/models.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;
  ApiClient._internal();

  AuthSession? _currentSession;
  AuthSession? get session => _currentSession;
  bool get isAuthenticated => _currentSession != null && _currentSession!.token.isNotEmpty;

  VoidCallback? onSessionExpired;

  // --- Métodos Estáticos de Conveniencia ---
  static ApiClient get instance => _instance;

  static Future<String?> getToken() async {
    if (_instance._currentSession == null) {
      await _instance.initSession();
    }
    return _instance._currentSession?.token;
  }

  static Future<AuthSession?> getStoredUser() async {
    if (_instance._currentSession == null) {
      await _instance.initSession();
    }
    return _instance._currentSession;
  }

  static Future<AuthSession> login(String email, String password) async {
    final response = await _instance.post('/auth/login', {
      'email': email,
      'password': password,
    });
    final session = AuthSession.fromJson(response['data'] as Map<String, dynamic>);
    await _instance.saveSession(session);
    return session;
  }

  static Future<void> logout() async {
    await _instance.clearSession();
  }

  static Future<List<OpportunityDTO>> getOpportunities() async {
    try {
      final res = await _instance.get('/opportunities?size=100');
      final data = res['data'];
      List<dynamic> items = [];
      if (data is Map<String, dynamic> && data.containsKey('content')) {
        items = data['content'] as List<dynamic>;
      } else if (data is List) {
        items = data;
      }
      return items.map((e) => OpportunityDTO.fromJson(e as Map<String, dynamic>)).toList();
    } catch (e) {
      debugPrint('Error al obtener oportunidades: $e');
      return [];
    }
  }

  static Future<OpportunityDTO> updateOpportunity(String id, Map<String, dynamic> data) async {
    final payload = Map<String, dynamic>.from(data);
    if (payload.containsKey('stageName') && !payload.containsKey('stage')) {
      payload['stage'] = payload['stageName'];
    }
    final res = await _instance.put('/opportunities/$id', payload);
    return OpportunityDTO.fromJson(res['data'] as Map<String, dynamic>);
  }

  Future<void> initSession() async {
    final prefs = await SharedPreferences.getInstance();
    final sessionJson = prefs.getString('luppo_session');
    if (sessionJson != null) {
      try {
        final data = jsonDecode(sessionJson);
        _currentSession = AuthSession.fromJson(data);
      } catch (e) {
        debugPrint('Error al recuperar sesión previa: $e');
        await clearSession();
      }
    }
  }

  Future<void> saveSession(AuthSession session) async {
    _currentSession = session;
    final prefs = await SharedPreferences.getInstance();
    final map = {
      'token': session.token,
      'refreshToken': session.refreshToken,
      'userId': session.userId,
      'email': session.email,
      'fullName': session.fullName,
      'title': session.title,
      'roles': session.roles,
    };
    await prefs.setString('luppo_session', jsonEncode(map));
  }

  Future<void> clearSession() async {
    _currentSession = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('luppo_session');
  }

  Map<String, String> _buildHeaders() {
    final headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
    };
    if (isAuthenticated) {
      headers['Authorization'] = 'Bearer ${_currentSession!.token}';
    }
    return headers;
  }

  Future<Map<String, dynamic>> get(String endpoint) async {
    final url = Uri.parse('${AppConfig.apiBaseUrl}$endpoint');
    final response = await http.get(url, headers: _buildHeaders());
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse('${AppConfig.apiBaseUrl}$endpoint');
    final response = await http.post(url, headers: _buildHeaders(), body: jsonEncode(body));
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> put(String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse('${AppConfig.apiBaseUrl}$endpoint');
    final response = await http.put(url, headers: _buildHeaders(), body: jsonEncode(body));
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> patch(String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse('${AppConfig.apiBaseUrl}$endpoint');
    final response = await http.patch(url, headers: _buildHeaders(), body: jsonEncode(body));
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> delete(String endpoint) async {
    final url = Uri.parse('${AppConfig.apiBaseUrl}$endpoint');
    final response = await http.delete(url, headers: _buildHeaders());
    return _handleResponse(response);
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode == 401) {
      clearSession();
      if (onSessionExpired != null) {
        onSessionExpired!();
      }
      throw Exception('Sesión expirada. Por favor ingresa nuevamente');
    }

    final decoded = jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;

    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (decoded['success'] == true) {
        return decoded;
      } else {
        throw Exception(decoded['message'] ?? 'Error en la operación');
      }
    } else {
      final errorMsg = decoded['message'] ?? 'Error HTTP ${response.statusCode}';
      throw Exception(errorMsg);
    }
  }
}
