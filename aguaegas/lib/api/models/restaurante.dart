class Restaurante {
  final int id;
  final String nomeFantasia;
  final String cnpj;
  final String endereco;
  final String telefone;
  final String descricao;
  final String photoUrl;
  final int empresarioId; // Novo campo

  Restaurante({
    required this.id,
    required this.nomeFantasia,
    required this.cnpj,
    required this.endereco,
    required this.telefone,
    required this.descricao,
    required this.photoUrl,
    required this.empresarioId, // Adicionando no construtor
  });

  factory Restaurante.fromJson(Map<String, dynamic> json) {
    return Restaurante(
      id: json['id'],
      nomeFantasia: json['nomeFantasia'],
      cnpj: json['cnpj'],
      endereco: json['endereco'],
      telefone: json['telefone'],
      photoUrl: json['photoUrl'],
      descricao: json['descricao'],
      empresarioId: json['empresario']['id'], // Extraindo o novo campo
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nomeFantasia': nomeFantasia,
      'cnpj': cnpj,
      'endereco': endereco,
      'telefone': telefone,
      'descricao': descricao,
      'photoUrl': photoUrl,
      'empresarioId': empresarioId, // Incluindo no método toJson
    };
  }
}
