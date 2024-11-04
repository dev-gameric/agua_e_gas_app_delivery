import 'package:aguaegas/api/models/restaurante.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RestauranteService {
  final String _baseUrl = 'http://10.0.2.2:8080';

  Future<List<Restaurante>> listarRestaurantes() async {
    final response = await http.get(Uri.parse('$_baseUrl/restaurantes/listar'));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      print(response.body);

      return jsonResponse.map((data) => Restaurante.fromJson(data)).toList();
    } else {
      throw Exception('Erro ao listar restaurantes');
    }
  }

  Future<void> cadastrarRestaurante(Restaurante restaurante) async {
    final response = await http.post(
      Uri.parse(
          '$_baseUrl/restaurantes/cadastrar?empresarioId=${restaurante.empresarioId}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode({
        'nomeFantasia': restaurante.nomeFantasia,
        'cnpj': restaurante.cnpj,
        'endereco': restaurante.endereco,
        'telefone': restaurante.telefone,
        'descricao': restaurante.descricao,
        'photoUrl': restaurante.photoUrl,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Erro ao cadastrar restaurante');
    }
  }
}
