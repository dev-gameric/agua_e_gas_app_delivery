import 'dart:io'; // Adicione esta importação
import 'package:aguaegas/api/models/produto.dart';
import 'package:aguaegas/api/models/restaurante.dart';
import 'package:aguaegas/screens/cliente/shop/loja_detalhe.dart';
import 'package:flutter/material.dart';
import 'package:aguaegas/core/theme/app_colors.dart';
import 'package:aguaegas/core/theme/app_typography.dart';

class RestaurantItemComponent extends StatelessWidget {
  final Restaurante restaurant;
  final List<Produto> produtos; // Lista de produtos para o restaurante

  const RestaurantItemComponent({
    required this.restaurant,
    required this.produtos, // Novo parâmetro
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navega para a página da loja, passando o restaurante e a lista de produtos
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RestauranteDetailPage(
              restaurante: restaurant,
              // Passa a lista de produtos
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 24),
        child: Row(
          children: [
            // Adicionando a imagem do restaurante
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child:
                  _getImage(restaurant.photoUrl), // Método para obter a imagem
            ),
            const SizedBox(width: 12), // Espaçamento entre a imagem e o texto
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    restaurant.nomeFantasia,
                    style: AppTypography.restaurantTitle(context),
                  ),
                  const SizedBox(height: 4),
                  const SizedBox(height: 2),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getImage(String imageUrl) {
    if (imageUrl.startsWith('http://') || imageUrl.startsWith('https://')) {
      return Image.network(
        imageUrl, // URL da foto do restaurante
        width: 60, // Definindo largura
        height: 60, // Definindo altura
        fit: BoxFit.cover, // Ajusta a imagem ao tamanho do container
      );
    } else {
      return Image.file(
        File(imageUrl), // Imagem local
        width: 60, // Definindo largura
        height: 60, // Definindo altura
        fit: BoxFit.cover, // Ajusta a imagem ao tamanho do container
      );
    }
  }
}

class _Dot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      '•',
      style: TextStyle(fontSize: 9, color: AppColors.grey7),
    );
  }
}
