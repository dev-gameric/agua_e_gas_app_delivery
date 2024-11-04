import 'dart:io';
import 'package:aguaegas/api/models/produto.dart';
import 'package:aguaegas/api/models/pedido.dart';
import 'package:aguaegas/api/services/pedido_service.dart';
import 'package:aguaegas/screens/cliente/shop/pedido_concluido.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PagamentoPage extends StatefulWidget {
  final Produto produto;
  final String preco;
  final int entrega;
  final int quantidade;

  const PagamentoPage({
    super.key,
    required this.produto,
    required this.preco,
    required this.entrega,
    required this.quantidade,
  });

  @override
  PagamentoPageState createState() => PagamentoPageState();
}

class PagamentoPageState extends State<PagamentoPage>
    with SingleTickerProviderStateMixin {
  String _metodoSelecionado = 'Cartão de Crédito';
  int? clienteId;
  final PedidoService pedidoService = PedidoService();
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _carregarClienteId();

    // Animação de transição para os botões
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  Future<void> _carregarClienteId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      clienteId = prefs.getInt('clienteId');
    });
  }

  Future<void> _finalizarPagamento() async {
    if (clienteId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cliente não encontrado!')),
      );
      return;
    }

    Pedido novoPedido = Pedido(
      id: 0,
      clienteId: clienteId!,
      produtoId: widget.produto.id,
      quantidade: widget.quantidade,
      formaPagamento: _metodoSelecionado,
      statusPedido: 'CONCLUIDO',
      dataPedido: DateTime.now(),
    );

    try {
      await pedidoService.cadastrarPedido(novoPedido);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const PedidoConcluidoPage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao cadastrar pedido: $e')),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pagamento'),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FadeTransition(
          opacity: _animation,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              _buildDetalhesPedido(),
              const SizedBox(height: 20),
              _buildMetodoPagamento(),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _finalizarPagamento,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                child: const Text('Finalizar Pagamento',
                    style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetalhesPedido() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: _getImageProvider(widget.produto.photoUrl),
                  radius: 40,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    widget.produto.nome,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _buildInfoRow('Valor Produto:',
                'R\$ ${widget.produto.preco.toStringAsFixed(2)}'),
            _buildInfoRow('Quantidade:', widget.quantidade.toString()),
            _buildInfoRow('Valor Entrega:', 'R\$ ${widget.entrega.toString()}'),
            _buildInfoRow('Total:', 'R\$ ${widget.preco}'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 18)),
          Text(value,
              style: const TextStyle(fontSize: 18, color: Colors.blueAccent)),
        ],
      ),
    );
  }

  Widget _buildMetodoPagamento() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Método de Pagamento',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        ListTile(
          title: const Text('Cartão de Crédito'),
          leading: Radio<String>(
            value: 'CARTAO_DE_CREDITO',
            groupValue: _metodoSelecionado,
            onChanged: (String? value) {
              setState(() {
                _metodoSelecionado = value!;
              });
            },
          ),
        ),
        ListTile(
          title: const Text('Pix'),
          leading: Radio<String>(
            value: 'PIX',
            groupValue: _metodoSelecionado,
            onChanged: (String? value) {
              setState(() {
                _metodoSelecionado = value!;
              });
            },
          ),
        ),
        ListTile(
          title: const Text('Pagamento na Entrega'),
          leading: Radio<String>(
            value: 'PAGAMENTO_NA_ENTREGA',
            groupValue: _metodoSelecionado,
            onChanged: (String? value) {
              setState(() {
                _metodoSelecionado = value!;
              });
            },
          ),
        ),
      ],
    );
  }

  ImageProvider _getImageProvider(String imageUrl) {
    if (imageUrl.startsWith('http://') || imageUrl.startsWith('https://')) {
      return NetworkImage(imageUrl);
    } else {
      return FileImage(File(imageUrl));
    }
  }
}
