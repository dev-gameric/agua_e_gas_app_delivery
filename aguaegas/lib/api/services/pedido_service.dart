import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pedido.dart';

class PedidoService {
  final String baseUrl = 'http://10.0.2.2:8080/pedido';

  // Método para listar todos os pedidos
  Future<List<Pedido>> listarPedidos() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((dynamic item) => Pedido.fromJson(item)).toList();
    } else {
      throw Exception('Erro ao buscar pedidos');
    }
  }

  Future<void> cadastrarPedido(Pedido pedido) async {
    try {
      // Converte o objeto Pedido em JSON
      String pedidoJson = jsonEncode(pedido.toJson());
      print('JSON enviado: $pedidoJson'); // Log para verificar o JSON

      // Realiza a requisição POST para cadastrar o pedido
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: pedidoJson,
      );

      if (response.statusCode == 201) {
        print("Pedido cadastrado com sucesso.");
      } else {
        print(
            "Falha ao cadastrar pedido: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      print("Erro ao cadastrar pedido: $e");
    }
  }

  // Método para atualizar um pedido
  Future<void> atualizarPedido(Pedido pedido) async {
    final response = await http.put(
      Uri.parse('$baseUrl/${pedido.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(pedido.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Erro ao atualizar pedido');
    }
  }
}
