import 'package:flutter/material.dart';

class RevisaoPage extends StatelessWidget {
  final String endereco;
  final String metodoPagamento;

  const RevisaoPage({
    super.key,
    required this.endereco,
    required this.metodoPagamento,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Revisão do Pedido"),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text("Resumo do Pedido"),
            const SizedBox(height: 16),
            Text("Endereço: $endereco"),
            Text("Forma de Pagamento: $metodoPagamento"),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                // Lógica para cadastrar o pedido
                // Pode ser uma chamada a um service que realiza o post para o PedidoController
              },
              child: const Text("Realizar Pedido"),
            ),
          ],
        ),
      ),
    );
  }
}
