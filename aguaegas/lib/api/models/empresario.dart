class Empresario {
  final int id;
  final String nome;
  final String email;
  final String senha;

  Empresario({
    required this.id,
    required this.nome,
    required this.email,
    required this.senha,
  });

  factory Empresario.fromJson(Map<String, dynamic> json) {
    return Empresario(
      id: json['id'],
      nome: json['nome'],
      email: json['email'],
      senha: json['senha'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'senha': senha,
    };
  }
}
