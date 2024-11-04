import 'package:aguaegas/screens/inicial/sign%20up/cadastro_cliente.dart';
import 'package:flutter/material.dart';
import 'package:aguaegas/api/services/auth_service.dart';
import 'package:aguaegas/screens/cliente/home/home_cliente.dart';

class LoginClientePage extends StatefulWidget {
  const LoginClientePage({super.key});

  @override
  _LoginClientePageState createState() => _LoginClientePageState();
}

class _LoginClientePageState extends State<LoginClientePage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _fadeAnimation =
        Tween<double>(begin: 0, end: 1).animate(_animationController);
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _loginCliente() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    var response = await AuthService.loginCliente(email, password);
    bool success = response['success'] ?? false;

    if (success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeClientePage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['message'] ?? 'Erro desconhecido')),
      );
    }
    await AuthService.getIds();
  }

  void _navigateToCadastro() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CadastroClienteScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.4,
              child: Image.asset(
                'assets/images/cenario/fundo_agua.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Hero(
                        tag: 'app-logo',
                        child: Image.asset(
                          'assets/images/cenario/agua.png',
                          height: 250,
                        ),
                      ),
                      const SizedBox(height: 40),
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle: const TextStyle(color: Colors.black),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.8),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon:
                              const Icon(Icons.email, color: Colors.blueAccent),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Senha',
                          labelStyle: const TextStyle(color: Colors.black),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.8),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon:
                              const Icon(Icons.lock, color: Colors.blueAccent),
                        ),
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          backgroundColor: Colors.blueAccent,
                        ),
                        onPressed: _loginCliente,
                        child: const Text(
                          'Login Cliente',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: _navigateToCadastro,
                        child: Text(
                          'Não tem uma conta? Cadastre-se',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.blueAccent.withOpacity(0.9),
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).viewInsets.bottom,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
