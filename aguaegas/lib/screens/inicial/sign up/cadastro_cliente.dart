import 'package:flutter/material.dart';
import 'package:aguaegas/api/models/cliente.dart';
import 'package:aguaegas/api/services/cliente_service.dart';
import 'package:aguaegas/screens/inicial/sign%20in/login_cliente.dart';

class CadastroClienteScreen extends StatefulWidget {
  const CadastroClienteScreen({super.key});

  @override
  CadastroClienteScreenState createState() => CadastroClienteScreenState();
}

class CadastroClienteScreenState extends State<CadastroClienteScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _cpfController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final TextEditingController _confirmarSenhaController =
      TextEditingController();
  final TextEditingController _enderecoController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();

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

  Future<void> _cadastrarCliente() async {
    if (_formKey.currentState!.validate()) {
      if (_senhaController.text != _confirmarSenhaController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('As senhas não coincidem')));
        return;
      }

      setState(() {
        _isLoading = true;
      });

      Cliente novoCliente = Cliente(
        id: 0,
        nome: _nomeController.text,
        cpf: _cpfController.text,
        email: _emailController.text,
        senha: _senhaController.text,
        endereco: _enderecoController.text,
        telefone: _telefoneController.text,
      );

      try {
        Cliente clienteCadastrado =
            await ClienteService().cadastrarCliente(novoCliente);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                'Cliente cadastrado com sucesso: ${clienteCadastrado.nome}')));
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const LoginClientePage()));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro ao cadastrar cliente: $e')));
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
                      'Crie sua conta de cliente',
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
                      controller: _cpfController,
                      label: 'CPF',
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.length != 11) {
                          return 'Informe um CPF válido com 11 dígitos';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    _buildTextField(
                      controller: _enderecoController,
                      label: 'Endereço',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Informe seu endereço';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    _buildTextField(
                      controller: _telefoneController,
                      label: 'Telefone',
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Informe um telefone válido';
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
                      onPressed: _isLoading ? null : _cadastrarCliente,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal, // Cor do botão
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Cadastrar',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white)),
                    ),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Já tem uma conta? Entrar',
                          style: TextStyle(color: Colors.white)),
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
