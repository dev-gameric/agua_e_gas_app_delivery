import 'dart:io';

import 'package:aguaegas/api/models/cliente.dart';
import 'package:aguaegas/api/models/produto.dart';
import 'package:aguaegas/api/models/restaurante.dart';
import 'package:aguaegas/api/services/cliente_service.dart';
import 'package:aguaegas/api/services/restaurant_service.dart';
import 'package:aguaegas/core/theme/app_images.dart';
import 'package:aguaegas/screens/cliente/shop/loja_detalhe.dart';
import 'package:flutter/material.dart';
import 'package:aguaegas/core/theme/app_colors.dart';
import 'package:aguaegas/core/theme/app_typography.dart';
import 'package:aguaegas/screens/components/banners_component.dart';
import 'package:aguaegas/screens/components/filters_component.dart';
import 'package:aguaegas/screens/components/produto_item_component.dart';
import 'package:aguaegas/api/services/produto_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeClientePage extends StatefulWidget {
  const HomeClientePage({super.key});

  @override
  HomeClientePageState createState() => HomeClientePageState();
}

class HomeClientePageState extends State<HomeClientePage> {
  late Future<List<Produto>> _produtos;
  String endereco = 'Carregando...'; // Inicializa como "Carregando..."
  final ClienteService clienteService = ClienteService();

  @override
  void initState() {
    super.initState();
    _produtos = _fetchProdutos();
    _carregarEndereco(); // Carrega o endereço do cliente
  }

  Future<void> _carregarEndereco() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int? clienteId = prefs.getInt('clienteId'); // Obtém o ID do cliente

    if (clienteId != null) {
      print('Cliente ID recuperado: $clienteId'); // Log do cliente ID
      try {
        Cliente cliente = await clienteService.obterCliente(clienteId);
        print(
            'Cliente recuperado: ${cliente.nome}'); // Log do cliente recuperado
        setState(() {
          endereco =
              cliente.endereco; // Atualiza o estado com o endereço do cliente
        });
      } catch (e) {
        print('Erro ao carregar cliente: $e'); // Log do erro
        setState(() {
          endereco = 'Erro ao carregar endereço: $e';
        });
      }
    } else {
      print('ID do cliente não encontrado'); // Log se o ID não for encontrado
      setState(() {
        endereco = 'ID do cliente não encontrado';
      });
    }
  }

  Future<List<Produto>> _fetchProdutos() async {
    try {
      final produtoService = ProdutoService();
      return await produtoService.listarProdutos();
    } catch (e) {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: HomeContent(endereco: endereco),
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  final String endereco;

  const HomeContent({super.key, required this.endereco});

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      physics: const BouncingScrollPhysics(),
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Text(
                endereco,
                style: AppTypography.localTextStyle(context),
              ),
            ),
          ),
          const FiltersComponent(),
        ];
      },
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                return await Future.value();
              },
              child: FutureBuilder<List<Produto>>(
                future: ProdutoService().listarProdutos(),
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
                  return CustomScrollView(
                    physics: const BouncingScrollPhysics(),
                    slivers: [
                      _BannerSession(),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 24.0, right: 24, bottom: 24),
                          child: Text('Produtos',
                              style: AppTypography.sessionTitle(context)),
                        ),
                      ),
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) => ProdutoItemComponent(
                            produto: produtos[index],
                          ),
                          childCount: produtos.length,
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24.0, vertical: 16),
                          child: Text('Lojas',
                              style: AppTypography.sessionTitle(context)),
                        ),
                      ),
                      FutureBuilder<List<Restaurante>>(
                        future: RestauranteService().listarRestaurantes(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const SliverToBoxAdapter(
                                child:
                                    Center(child: CircularProgressIndicator()));
                          } else if (snapshot.hasError) {
                            return SliverToBoxAdapter(
                                child: Center(
                                    child: Text('Erro: ${snapshot.error}')));
                          } else if (!snapshot.hasData ||
                              snapshot.data!.isEmpty) {
                            return const SliverToBoxAdapter(
                                child: Center(
                                    child: Text(
                                        'Nenhum restaurante disponível.')));
                          }
                          final restaurantes = snapshot.data!;
                          return SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                final restaurante = restaurantes[index];
                                return ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage: _getImageProvider(restaurante
                                        .photoUrl), // Refatorado para usar o método
                                    radius: 30,
                                  ),
                                  title: Text(restaurante.nomeFantasia),
                                  subtitle: Text(restaurante.endereco),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            RestauranteDetailPage(
                                                restaurante: restaurante),
                                      ),
                                    );
                                  },
                                );
                              },
                              childCount: restaurantes.length,
                            ),
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
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

class _BannerSession extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const SliverToBoxAdapter(
      child: SizedBox(
        height: 170,
        child: BannersComponent(
          list: [
            BannerItemComponent(
              imagePath: AppImages.banner1,
            ),
            BannerItemComponent(
              imagePath: AppImages.banner2,
            ),
            BannerItemComponent(
              imagePath: AppImages.banner3,
            ),
            BannerItemComponent(
              imagePath: AppImages.banner4,
            ),
          ],
        ),
      ),
    );
  }
}
