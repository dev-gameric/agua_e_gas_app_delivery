class Produto {
  final int id;
  final String nome;
  final String categoria;
  final String descricao;
  final double preco;
  final String photoUrl;
  final int quantidadeEstoque;
  final int restauranteId;

  Produto({
    required this.id,
    required this.nome,
    required this.categoria,
    required this.descricao,
    required this.preco,
    required this.photoUrl,
    required this.quantidadeEstoque,
    required this.restauranteId,
  });

  factory Produto.fromJson(Map<String, dynamic> json) {
    return Produto(
      id: json['id'],
      nome: json['nome'],
      categoria: json['categoria'],
      descricao: json['descricao'],
      preco: json['preco'],
      photoUrl: json['photoUrl'],
      quantidadeEstoque: json['quantidadeEstoque'],
      restauranteId: json['restaurante']['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'descricao': descricao,
      'preco': preco,
      'quantidadeEstoque': quantidadeEstoque,
      'photoUrl': photoUrl,
      'categoria': categoria,
      'restaurante': {
        'id': restauranteId, // Modificado para aninhar
      },
    };
  }

  Produto changeFav({required bool favorite}) {
    return Produto(
      id: id,
      nome: nome,
      descricao: descricao,
      categoria: categoria,
      preco: preco,
      quantidadeEstoque: quantidadeEstoque,
      photoUrl: photoUrl,
      restauranteId: restauranteId,
    );
  }
}
