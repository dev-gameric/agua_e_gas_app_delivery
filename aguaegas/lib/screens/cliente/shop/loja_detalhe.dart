import 'package:aguaegas/screens/components/produto_item_component.dart';
import 'package:flutter/material.dart';
import 'package:aguaegas/api/models/produto.dart';
import 'package:aguaegas/api/models/restaurante.dart';
import 'package:aguaegas/api/services/produto_service.dart';
import 'package:aguaegas/core/theme/app_colors.dart';

class RestauranteDetailPage extends StatelessWidget {
  final Restaurante restaurante;

  const RestauranteDetailPage({super.key, required this.restaurante});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(restaurante.nomeFantasia),
        backgroundColor: AppColors.white,
      ),
      body: FutureBuilder<List<Produto>>(
        future: ProdutoService().listarProdutosPorRestauranteId(
            restaurante.id), // Utilize o novo método
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
                child: Text('Nenhum produto disponível neste restaurante.'));
          }

          final produtos = snapshot.data!;

          return ListView.builder(
            itemCount: produtos.length,
            itemBuilder: (context, index) {
              final produto = produtos[index];
              return ProdutoItemComponent(
                  produto: produto); // Use o componente aqui
            },
          );
        },
      ),
    );
  }
}
