import 'package:flutter/material.dart';
import 'package:aguaegas/api/services/empresario_service.dart';
import 'package:aguaegas/api/models/empresario.dart';
import 'package:aguaegas/screens/inicial/sign%20up/cadastro_restaurante.dart';

class CadastroEmpresario extends StatefulWidget {
  const CadastroEmpresario({super.key});

  @override
  CadastroEmpresarioState createState() => CadastroEmpresarioState();
}

class CadastroEmpresarioState extends State<CadastroEmpresario>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  // Controladores para os campos de texto
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final TextEditingController _confirmarSenhaController =
      TextEditingController();

  bool _isLoading = false;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void continuarCadastro() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Cria o objeto Empresário com os dados fornecidos
        Empresario novoEmpresario = Empresario(
          id: 0, // ID inicial é 0, será preenchido após cadastro
          nome: _nomeController.text,
          email: _emailController.text,
          senha: _senhaController.text,
        );

        // Chama o serviço para cadastro e obtém o ID do empresário cadastrado
        EmpresarioService service = EmpresarioService();
        int empresarioId = await service.cadastrarEmpresario(novoEmpresario);

        // Redireciona para a tela de cadastro do restaurante com o ID do empresário
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                CadastroRestaurantePage(empresarioId: empresarioId),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao prosseguir com o cadastro: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FadeTransition(
        opacity: _animation,
        child: Stack(
          children: [
            // Imagem de fundo
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                      'assets/images/cenario/fundo_agua.png'), // Substitua pela sua imagem
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 80),
                    const Text(
                      'Crie sua conta de empresário',
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      controller: _nomeController,
                      label: 'Nome Completo',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Informe seu nome completo';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    _buildTextField(
                      controller: _emailController,
                      label: 'E-mail',
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Informe seu e-mail';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    _buildTextField(
                      controller: _senhaController,
                      label: 'Senha',
                      obscureText: true,
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.length < 6) {
                          return 'A senha deve ter pelo menos 6 caracteres';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    _buildTextField(
                      controller: _confirmarSenhaController,
                      label: 'Confirmar Senha',
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Confirme sua senha';
                        }
                        if (value != _senhaController.text) {
                          return 'As senhas não coincidem';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: _isLoading ? null : continuarCadastro,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal, // Cor do botão
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Continuar',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white)),
                    ),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Já tem uma conta? Entrar',
                          style: TextStyle(color: Colors.black)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.teal),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      ),
      style: const TextStyle(color: Colors.black),
    );
  }
}
