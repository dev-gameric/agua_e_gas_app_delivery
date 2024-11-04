import 'package:aguaegas/api/models/cliente.dart';
import 'package:aguaegas/api/models/produto.dart';
import 'package:aguaegas/api/services/cliente_service.dart';
import 'package:flutter/material.dart';
import 'package:aguaegas/screens/cliente/shop/pagamento.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EnderecoPage extends StatefulWidget {
  final Produto produto;
  final int quantidade;

  const EnderecoPage(
      {super.key, required this.produto, required this.quantidade});

  @override
  _EnderecoPageState createState() => _EnderecoPageState();
}

class _EnderecoPageState extends State<EnderecoPage> {
  String endereco = 'Carregando...';
  final ClienteService clienteService = ClienteService();
  String _metodoEntrega = 'entrega_padrao';
  int _valorEntrega = 5;

  @override
  void initState() {
    super.initState();
    _carregarEndereco();
  }

  Future<void> _carregarEndereco() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int? clienteId = prefs.getInt('clienteId');

    if (clienteId != null) {
      try {
        Cliente cliente = await clienteService.obterCliente(clienteId);
        setState(() {
          endereco = cliente.endereco;
        });
      } catch (e) {
        setState(() {
          endereco = 'Erro ao carregar endereço';
        });
      }
    } else {
      setState(() {
        endereco = 'ID do cliente não encontrado';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Entrega"),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Endereço",
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blueAccent),
                  onPressed: () {
                    // Lógica para trocar o endereço
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Alteração no cartão do endereço para ocupar toda a largura
            Card(
              elevation: 4,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                child: Text(endereco, style: const TextStyle(fontSize: 16)),
              ),
            ),
            const SizedBox(height: 16),
            const Text("Opções de Entrega",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            _buildDeliveryOption(
                "Entrega Padrão", "R\$ 5\nHoje, 30 min", "entrega_padrao"),
            _buildDeliveryOption(
                "Entrega Rápida", "R\$ 9\nHoje, 15 min", "entrega_rapida"),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.lightBlueAccent, // Cor de fundo do botão
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  textStyle: const TextStyle(
                      fontSize: 18,
                      color: Colors.white), // Cor do texto do botão
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PagamentoPage(
                        produto: widget.produto,
                        preco: (widget.produto.preco * widget.quantidade +
                                _valorEntrega)
                            .toString(),
                        entrega: _valorEntrega,
                        quantidade: widget.quantidade,
                      ),
                    ),
                  );
                },
                child: const Text("Continuar",
                    style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeliveryOption(String title, String subtitle, String value) {
    return Card(
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        leading: Radio(
          value: value,
          groupValue: _metodoEntrega,
          onChanged: (String? newValue) {
            setState(() {
              _metodoEntrega = newValue!;
              _valorEntrega = value == "entrega_padrao" ? 5 : 9;
            });
          },
        ),
      ),
    );
  }
}
