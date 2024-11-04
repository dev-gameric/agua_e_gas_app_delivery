class Cliente {
  final int id;
  final String nome;
  final String cpf;
  final String email;
  final String senha;
  final String endereco;
  final String telefone;

  Cliente({
    required this.id,
    required this.nome,
    required this.cpf,
    required this.email,
    required this.senha,
    required this.endereco,
    required this.telefone,
  });

  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
      id: json['id'],
      nome: json['nome'],
      email: json['email'],
      cpf: json['cpf'],
      senha: json['senha'],
      endereco: json['endereco'],
      telefone: json['telefone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'cpf': cpf,
      'email': email,
      'senha': senha,
      'endereco': endereco,
      'telefone': telefone,
    };
  }
}
