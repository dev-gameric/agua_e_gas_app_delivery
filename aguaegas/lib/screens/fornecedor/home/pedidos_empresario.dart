import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PedidosPage extends StatefulWidget {
  @override
  _PedidosPageState createState() => _PedidosPageState();
}

class _PedidosPageState extends State<PedidosPage> {
  List<dynamic> pedidos = [];
  int? restauranteId;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRestauranteId();
  }

  Future<void> _loadRestauranteId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      restauranteId = prefs.getInt('restauranteId');
    });
    if (restauranteId != null) {
      await _fetchPedidos();
    } else {
      _showSnackbar('Restaurante ID não encontrado.');
    }
  }

  Future<void> _fetchPedidos() async {
    setState(() => isLoading = true);
    try {
      final response = await http.get(
        Uri.parse(
            'http://10.0.2.2:8080/pedido/pedidos?restauranteId=$restauranteId'),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final pedidosList = jsonDecode(response.body);

        // Inverte a lista para que o último pedido fique primeiro
        pedidosList.sort((a, b) => (b['id'] as int).compareTo(a['id'] as int));

        setState(() {
          pedidos = pedidosList;
        });
      } else {
        _showSnackbar('Erro ao buscar pedidos: ${response.statusCode}');
      }
    } catch (e) {
      _showSnackbar('Erro de conexão: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pedidos'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : pedidos.isEmpty
              ? _buildEmptyState()
              : SingleChildScrollView(
                  child: _buildPedidosList(),
                ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Text(
        'Nenhum pedido encontrado',
        style: TextStyle(fontSize: 18, color: Colors.grey),
      ),
    );
  }

  Widget _buildPedidosList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(8.0),
      itemCount: pedidos.length,
      itemBuilder: (context, index) {
        final pedido = pedidos[index];
        return PedidoListItem(
            pedido: pedido, numeroSequencia: pedidos.length - index);
      },
    );
  }
}

class PedidoListItem extends StatelessWidget {
  final dynamic pedido;
  final int numeroSequencia;

  const PedidoListItem({required this.pedido, required this.numeroSequencia});

  @override
  Widget build(BuildContext context) {
    final endereco = pedido['cliente']['endereco'] ?? 'Endereço não disponível';
    final produtoNome = pedido['produto']['nome'] ?? 'Produto não especificado';
    final clienteNome =
        pedido['cliente']['nome'] ?? 'Nome Cliente não especificado';

    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12.0),
        title: Text(
          'Pedido #$numeroSequencia',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 5),
            Text(
              'Cliente: $clienteNome\nPagamento: ${pedido['formaPagamento']}',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 5),
            Text(
              'Endereço: $endereco',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 5),
            Text(
              'Produto: $produtoNome',
              style: const TextStyle(fontSize: 14, color: Colors.blueGrey),
            ),
          ],
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.blueAccent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            'Qtd: ${pedido['quantidade']}',
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
