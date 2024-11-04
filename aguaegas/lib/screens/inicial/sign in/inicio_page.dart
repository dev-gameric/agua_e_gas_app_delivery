import 'package:aguaegas/screens/inicial/sign%20in/login_cliente.dart';
import 'package:aguaegas/screens/inicial/sign%20in/login_empresario.dart';
import 'package:flutter/material.dart';

class SelectionPage extends StatelessWidget {
  const SelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Column(
        children: [
          // Imagem ocupando 70% da tela
          SizedBox(
            height: size.height * 0.8,
            width: double.infinity,
            child: Image.asset(
              'assets/images/cenario/homem_com_agua.png',
              fit: BoxFit.cover,
            ),
          ),

          // Espaço para os botões
          Expanded(
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Botão para Cliente
                  AnimatedButton(
                    label: 'Login Cliente',
                    onPressed: () => _navigateWithAnimation(
                      context,
                      const LoginClientePage(),
                    ),
                  ),

                  // Botão para Empresário
                  AnimatedButton(
                    label: 'Login Empresário',
                    onPressed: () => _navigateWithAnimation(
                      context,
                      const LoginEmpresarioPage(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Função para navegar com animação de transição
  void _navigateWithAnimation(BuildContext context, Widget page) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0); // Animação de slide para a direita
          const end = Offset.zero;
          const curve = Curves.easeInOut;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var fadeAnimation =
              CurvedAnimation(parent: animation, curve: Curves.easeIn);

          return FadeTransition(
            opacity: fadeAnimation,
            child: SlideTransition(
              position: animation.drive(tween),
              child: child,
            ),
          );
        },
      ),
    );
  }
}

// Widget para o botão estilizado com animação
class AnimatedButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const AnimatedButton({required this.label, required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.blueAccent,
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        elevation: 5,
      ),
      onPressed: onPressed,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: Text(
          label,
          key: ValueKey<String>(label),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
