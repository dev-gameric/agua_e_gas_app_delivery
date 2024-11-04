import 'dart:io';
import 'package:flutter/material.dart';
import 'package:aguaegas/api/models/produto.dart';
import 'package:aguaegas/screens/cliente/shop/entrega.dart';

class SacolaPage extends StatefulWidget {
  final Produto produto;

  const SacolaPage({required this.produto, super.key});

  @override
  State<SacolaPage> createState() => _SacolaPageState();
}

class _SacolaPageState extends State<SacolaPage>
    with SingleTickerProviderStateMixin {
  int quantidade = 1;

  @override
  Widget build(BuildContext context) {
    final double subtotal = widget.produto.preco * quantidade;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Sacola",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Divider(color: Colors.grey),
            // Adicionando o cabeçalho para o produto
            const SizedBox(
                height: 16), // Espaçamento entre o cabeçalho e a lista
            Expanded(child: _buildItemList()), // Lista de itens na sacola
            const SizedBox(height: 16), // Espaçamento antes do rodapé
            _buildFooter(subtotal), // Subtotal e botão de continuar
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
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
                color: Colors.black87),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildItemList() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: ListView(
        children: [
          _buildItemTile(),
        ],
      ),
    );
  }

  Widget _buildItemTile() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image(
            image: _getImageProvider(widget.produto.photoUrl),
            width: 60,
            height: 60,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(widget.produto.nome, style: const TextStyle(fontSize: 18)),
        subtitle: Text('R\$ ${widget.produto.preco.toStringAsFixed(2)}',
            style: const TextStyle(color: Colors.black)),
        trailing: _buildQuantityControl(),
      ),
    );
  }

  Widget _buildQuantityControl() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.remove, color: Colors.red),
          onPressed: () {
            setState(() {
              if (quantidade > 1) quantidade--;
            });
          },
        ),
        Text('$quantidade', style: const TextStyle(fontSize: 18)),
        IconButton(
          icon: const Icon(Icons.add, color: Colors.green),
          onPressed: () {
            setState(() {
              quantidade++;
            });
          },
        ),
      ],
    );
  }

  Widget _buildFooter(double subtotal) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text("Subtotal: R\$ ${subtotal.toStringAsFixed(2)}",
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EnderecoPage(
                    produto: widget.produto,
                    quantidade: quantidade,
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              padding: const EdgeInsets.symmetric(vertical: 16),
              textStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              foregroundColor:
                  Colors.white, // Define a cor do texto como branco
            ),
            child: const Text("Continuar"),
          ),
        ],
      ),
    );
  }

  ImageProvider _getImageProvider(String imageUrl) {
    if (imageUrl.startsWith('http://') || imageUrl.startsWith('https://')) {
      return NetworkImage(imageUrl); // Imagem da internet
    } else {
      return FileImage(File(imageUrl)); // Imagem local
    }
  }
}
