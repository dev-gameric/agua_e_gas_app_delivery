import 'package:flutter/material.dart';
import 'package:aguaegas/screens/components/produto_item_component.dart';
import 'package:aguaegas/screens/fornecedor/features/add_produto.dart';
import 'package:aguaegas/api/models/produto.dart';
import 'package:aguaegas/api/services/produto_service.dart';
import 'package:aguaegas/core/theme/app_colors.dart';

class HomeEmpresarioPage extends StatefulWidget {
  const HomeEmpresarioPage({super.key});

  @override
  HomeEmpresarioPageState createState() => HomeEmpresarioPageState();
}

class HomeEmpresarioPageState extends State<HomeEmpresarioPage> {
  final ProdutoService _produtoService = ProdutoService();
  late Future<List<Produto>> _produtosFuture;

  @override
  void initState() {
    super.initState();
    _carregarProdutosPorRestaurante();
  }

  void _carregarProdutosPorRestaurante() {
    setState(() {
      _produtosFuture = _produtoService.listarProdutosPorRestaurante();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text('Produtos'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _carregarProdutosPorRestaurante,
          ),
        ],
      ),
      body: SafeArea(
        child: FutureBuilder<List<Produto>>(
          future: _produtosFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Erro ao carregar produtos: ${snapshot.error}'),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('Nenhum produto cadastrado.'));
            } else {
              final produtos = snapshot.data!;
              return ListView.builder(
                padding:
                    const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
                itemCount: produtos.length,
                itemBuilder: (context, index) {
                  return AnimatedPadding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    duration: const Duration(milliseconds: 300),
                    child: Material(
                      elevation: 4,
                      borderRadius: BorderRadius.circular(12),
                      child: ProdutoItemComponent(produto: produtos[index]),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddProductPage()),
          ).then((_) {
            _carregarProdutosPorRestaurante();
          });
        },
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add),
      ),
    );
  }
}
