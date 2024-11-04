import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/produto.dart';

class ProdutoService {
  final String baseUrl = 'http://10.0.2.2:8080/produto';

  // Método para listar todos os produtos
  Future<List<Produto>> listarProdutos() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        return body.map((item) => Produto.fromJson(item)).toList();
      } else {
        throw Exception('Erro ao buscar produtos');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  // Método para cadastrar um produto
  Future<Produto> cadastrarProduto(Produto produto) async {
    // Obter o restauranteId do SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final restauranteId = prefs.getInt('restauranteId');

    // Verifique se o restauranteId não é nulo
    if (restauranteId == null) {
      throw Exception('Restaurante ID não encontrado nos SharedPreferences');
    }

    // Criar um objeto Produto com o restauranteId
    final produtoComRestaurante = Produto(
      id: produto.id,
      nome: produto.nome,
      categoria: produto.categoria,
      descricao: produto.descricao,
      preco: produto.preco,
      photoUrl: produto.photoUrl,
      quantidadeEstoque: produto.quantidadeEstoque,
      restauranteId: restauranteId, // Associando o ID aqui
    );

    final response = await http.post(
      Uri.parse(baseUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(produtoComRestaurante.toJson()),
    );

    if (response.statusCode == 200) {
      return Produto.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Erro ao cadastrar produto');
    }
  }

  // Método para remover um produto
  Future<void> removerProduto(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));

    if (response.statusCode != 204) {
      throw Exception('Erro ao remover produto');
    }
  }

  Future<List<Produto>> listarProdutosPorRestaurante() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final restauranteId = prefs.getInt('restauranteId');

      final response = await http.get(Uri.parse(
          'http://10.0.2.2:8080/restaurantes/$restauranteId/produtos'));

      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        return body.map((item) => Produto.fromJson(item)).toList();
      } else {
        throw Exception('Erro ao buscar produtos');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  Future<List<Produto>> listarProdutosPorRestauranteId(
      int restauranteId) async {
    final response = await http.get(
        Uri.parse('http://10.0.2.2:8080/restaurantes/$restauranteId/produtos'));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Produto.fromJson(data)).toList();
    } else {
      throw Exception(
          'Erro ao listar produtos para o restaurante com ID: $restauranteId');
    }
  }
}
