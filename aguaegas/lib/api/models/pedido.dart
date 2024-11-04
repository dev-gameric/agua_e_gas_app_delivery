class Pedido {
  final int id;
  final int clienteId;
  final int produtoId;
  final int quantidade;
  final String formaPagamento;
  final String statusPedido;
  final DateTime dataPedido;

  Pedido({
    required this.id,
    required this.clienteId,
    required this.produtoId,
    required this.quantidade,
    required this.formaPagamento,
    required this.statusPedido,
    required this.dataPedido,
  });

  factory Pedido.fromJson(Map<String, dynamic> json) {
    return Pedido(
      id: json['id'],
      clienteId:
          json['cliente'] != null ? json['cliente']['id'] : null, // Ajuste aqui
      produtoId: json['produto'] != null ? json['produto']['id'] : null,
      quantidade: json['quantidade'],
      formaPagamento: json['formaPagamento'],
      statusPedido: json['statusPedido'],
      dataPedido: DateTime.parse(json['dataPedido']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cliente': {
        'id': clienteId
      }, // Modificado para enviar o cliente como objeto
      'produto': {'id': produtoId},
      'quantidade': quantidade,
      'formaPagamento': formaPagamento,
      'statusPedido': statusPedido,
      'dataPedido': dataPedido.toIso8601String(),
    };
  }
}
