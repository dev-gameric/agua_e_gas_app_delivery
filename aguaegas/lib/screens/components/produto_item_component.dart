import 'dart:io';
import 'package:flutter/material.dart';
import 'package:aguaegas/core/theme/app_colors.dart';
import 'package:aguaegas/core/theme/app_icons.dart';
import 'package:aguaegas/core/theme/app_typography.dart';
import 'package:aguaegas/api/models/produto.dart';
import 'package:aguaegas/api/services/produto_service.dart';
import 'package:aguaegas/screens/cliente/shop/sacola.dart';
import 'package:aguaegas/screens/fornecedor/features/add_produto.dart';

class ProdutoItemComponent extends StatelessWidget {
  final Produto produto;

  const ProdutoItemComponent({required this.produto, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SacolaPage(produto: produto),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundImage: _getImageProvider(produto.photoUrl),
                  radius: 30,
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(produto.nome,
                        style: AppTypography.produtoTitle(context)),
                    const SizedBox(height: 2),
                    Text('R\$ ${produto.preco.toStringAsFixed(2)}',
                        style: AppTypography.produtoDetails(context)),
                    const SizedBox(height: 2),
                    Text('Categoria: ${produto.categoria}',
                        style: AppTypography.produtoDetails(context)),
                  ],
                ),
              ],
            ),
            AppIcon(
              AppIcons.favLine,
              size: const Size(18, 18),
              color: AppColors.grey7 ?? Colors.grey,
            ),
          ],
        ),
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

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Produto>> _produtos;

  @override
  void initState() {
    super.initState();
    _produtos = _fetchProdutos();
  }

  Future<List<Produto>> _fetchProdutos() async {
    try {
      final produtoService =
          ProdutoService(); // Usando o ProdutoService para buscar produtos
      final produtos = await produtoService
          .listarProdutos(); // Modificado para usar o método correto
      if (produtos.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Nenhum produto cadastrado.')),
        );
      }
      return produtos;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar produtos: $e')),
      );
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        physics: const BouncingScrollPhysics(),
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [];
        },
        body: Column(
          children: [
            Expanded(
              child: FutureBuilder<List<Produto>>(
                future: _produtos,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Erro: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                        child: Text('Nenhum produto disponível.'));
                  }
                  final produtos = snapshot.data!;
                  return RefreshIndicator(
                    onRefresh: () async {
                      setState(() {
                        _produtos = _fetchProdutos();
                      });
                    },
                    child: ListView.builder(
                      itemCount: produtos.length,
                      itemBuilder: (context, index) {
                        return ProdutoItemComponent(produto: produtos[index]);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddProductPage()),
          );
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
      ),
    );
  }
}
