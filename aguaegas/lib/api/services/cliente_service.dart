import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/cliente.dart';

class ClienteService {
  final String baseUrl = 'http://10.0.2.2:8080/cliente';

  // Método para listar todos os clientes
  Future<List<Cliente>> listarClientes() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Cliente> clientes =
          body.map((dynamic item) => Cliente.fromJson(item)).toList();
      return clientes;
    } else {
      throw Exception('Erro ao buscar clientes');
    }
  }

  // Método para cadastrar um cliente
  Future<Cliente> cadastrarCliente(Cliente cliente) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(cliente.toJson()),
    );

    print('Status code: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      return Cliente.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Erro ao cadastrar cliente');
    }
  }

  Future<Cliente> obterCliente(int clienteId) async {
    final response = await http.get(Uri.parse('$baseUrl/$clienteId'));
    if (response.statusCode == 200) {
      return Cliente.fromJson(json.decode(response.body));
    } else {
      throw Exception('Erro ao carregar perfil do cliente');
    }
  }

  Future<void> atualizarCliente(Cliente cliente) async {
    final response = await http.put(
      Uri.parse('$baseUrl/${cliente.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(cliente.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Erro ao atualizar perfil do cliente');
    }
  }
}
