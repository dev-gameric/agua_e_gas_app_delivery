import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/empresario.dart';

class EmpresarioService {
  final String baseUrl = 'http://10.0.2.2:8080/empresario';

  // Método para listar todos os empresários
  Future<List<Empresario>> listarEmpresarios() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Empresario> empresarios =
          body.map((dynamic item) => Empresario.fromJson(item)).toList();
      return empresarios;
    } else {
      throw Exception('Erro ao buscar empresários');
    }
  }

  // Método para cadastrar um empresário
  Future<int> cadastrarEmpresario(Empresario empresario) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(empresario.toJson()), // Serializa o objeto Empresario
    );

    if (response.statusCode == 201) {
      // Se a API retornar o corpo com o empresário cadastrado
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      return responseBody['id']; // Assume que o ID está no campo 'id'
    } else {
      throw Exception('Erro ao cadastrar empresário');
    }
  }
}
