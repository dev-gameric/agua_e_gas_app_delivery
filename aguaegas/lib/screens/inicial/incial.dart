import 'package:flutter/material.dart';
import 'package:aguaegas/screens/inicial/sign%20in/inicio_page.dart';
import 'package:video_player/video_player.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late VideoPlayerController _controller;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Configuração do controlador de vídeo
    _controller =
        VideoPlayerController.asset("assets/videos/agua_e_gas_loading.mp4")
          ..initialize().then((_) {
            _controller.play();
            setState(() {});
          });

    // Configuração do controlador de fade
    _fadeController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _fadeAnimation =
        Tween<double>(begin: 1.0, end: 0.0).animate(_fadeController);

    // Navegação ao final do vídeo com fade
    _controller.addListener(() {
      if (!_controller.value.isPlaying &&
          _controller.value.position == _controller.value.duration) {
        _fadeController.forward().then((_) {
          Navigator.of(context).pushReplacement(
            PageRouteBuilder(
              pageBuilder: (_, __, ___) => const SelectionPage(),
              transitionsBuilder: (_, animation, __, child) {
                return FadeTransition(opacity: animation, child: child);
              },
            ),
          );
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _fadeController.dispose(); // Libera o controlador de fade ao sair da tela
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _controller.value.isInitialized
            ? FadeTransition(
                opacity: _fadeAnimation,
                child: SizedBox.expand(
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: _controller.value.size.width,
                      height: _controller.value.size.height,
                      child: VideoPlayer(_controller),
                    ),
                  ),
                ),
              )
            : const CircularProgressIndicator(), // Mostra um indicador de carregamento enquanto o vídeo carrega
      ),
    );
  }
}
