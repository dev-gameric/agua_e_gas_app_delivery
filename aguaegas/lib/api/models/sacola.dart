import 'package:aguaegas/api/models/produto.dart';

class Sacola {
  final String lojaId;
  final String lojaNome;
  final List<Produto> produtos;
  double total = 0;

  Sacola({required this.lojaId, required this.lojaNome}) : produtos = [];

  void adicionarProduto(Produto produto) {
    produtos.add(produto);
    total += produto.preco;
  }

  void removerProduto(Produto produto) {
    produtos.remove(produto);
    total -= produto.preco;
  }

  int get quantidadeItens => produtos.length;

  void limparSacola() {
    produtos.clear();
    total = 0;
  }
}
