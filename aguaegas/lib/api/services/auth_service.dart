import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static Future<Map<String, dynamic>> loginCliente(
      String email, String password) async {
    // Log da requisição
    print('Requisição para loginCliente:');
    print('Email: $email');
    print('Password: $password');

    final response = await http.post(
      Uri.parse('http://10.0.2.2:8080/auth/login/cliente'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    // Log da resposta
    print('Resposta do loginCliente: ${response.statusCode}');
    print('Corpo da resposta: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // Salva os IDs do cliente e do restaurante no SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      if (data['userId'] != null) {
        await prefs.setInt(
            'clienteId', data['userId']); // Armazena o ID do usuário
      } else {
        print('userId é null');
      } // Altere para o nome correto que você recebe

      return {
        'token': data['token'],
        'TipoUsuario': data['TipoUsuario'],
        'success': true
      };
    } else {
      return {'message': 'Falha ao autenticar', 'success': false};
    }
  }

  static Future<Map<String, dynamic>> loginEmpresario(
      String email, String password) async {
    // Log da requisição
    print('Requisição para loginEmpresario:');
    print('Email: $email');
    print('Password: $password');

    final response = await http.post(
      Uri.parse('http://10.0.2.2:8080/auth/login/empresario'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    // Log da resposta
    print('Resposta do loginEmpresario: ${response.statusCode}');
    print('Corpo da resposta: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // Salva os IDs do cliente e do restaurante no SharedPreferences
      final prefs = await SharedPreferences.getInstance();

      // Verifica se os valores são não nulos antes de salvar
      if (data['userId'] != null) {
        await prefs.setInt(
            'clienteId', data['userId']); // Armazena o ID do usuário
      } else {
        print('userId é null');
      }

      if (data['restauranteId'] != null) {
        await prefs.setInt('restauranteId',
            data['restauranteId']); // Armazena o ID do restaurante
      } else {
        print('restauranteId é null');
      }

      return {
        'token': data['token'],
        'TipoUsuario': data['TipoUsuario'],
        'success': true
      };
    } else {
      return {'message': 'Falha ao autenticar', 'success': false};
    }
  }

  static Future<void> getIds() async {
    final prefs = await SharedPreferences.getInstance();

    // Recupera os IDs do SharedPreferences
    final clienteId = prefs.getInt('clienteId');
    final restauranteId = prefs.getInt('restauranteId');

    // Exibe os IDs no console
    print('Cliente ID: $clienteId');
    print('Restaurante ID: $restauranteId');
  }
}
