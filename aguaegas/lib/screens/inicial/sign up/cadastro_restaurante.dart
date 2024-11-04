import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:aguaegas/api/models/restaurante.dart';
import 'package:aguaegas/api/services/restaurant_service.dart';
import 'package:aguaegas/screens/inicial/sign%20in/login_empresario.dart';

class CadastroRestaurantePage extends StatefulWidget {
  final int empresarioId;

  const CadastroRestaurantePage({super.key, required this.empresarioId});

  @override
  _CadastroRestaurantePageState createState() =>
      _CadastroRestaurantePageState();
}

class _CadastroRestaurantePageState extends State<CadastroRestaurantePage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nomeFantasiaController = TextEditingController();
  final TextEditingController _cnpjController = TextEditingController();
  final TextEditingController _enderecoController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();

  bool _isLoading = false;
  late AnimationController _controller;
  late Animation<double> _animation;

  File? _imagem;
  final ImagePicker _picker = ImagePicker();

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

  Future<void> _requestPermission() async {
    if (await Permission.storage.request().isGranted) {
      _showImageSourceActionSheet();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permissão de armazenamento necessária.')),
      );
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    setState(() {
      if (pickedFile != null) {
        _imagem = File(pickedFile.path);
      } else {
        print('Nenhuma Imagem Selecionada');
      }
    });
  }

  void _showImageSourceActionSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Galeria'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Câmera'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<String> saveImageLocally(File imageFile) async {
    final directory = await getApplicationDocumentsDirectory();
    final imagePath =
        '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';

    await imageFile.copy(imagePath);
    return imagePath;
  }

  void cadastrarRestaurante() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      String imageUrl = '';
      if (_imagem != null) {
        imageUrl = await saveImageLocally(_imagem!);
      }

      try {
        Restaurante novoRestaurante = Restaurante(
          id: 0,
          nomeFantasia: _nomeFantasiaController.text,
          cnpj: _cnpjController.text,
          endereco: _enderecoController.text,
          telefone: _telefoneController.text,
          descricao: _descricaoController.text,
          empresarioId: widget.empresarioId,
          photoUrl: imageUrl,
        );

        RestauranteService service = RestauranteService();
        await service.cadastrarRestaurante(novoRestaurante);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Restaurante cadastrado com sucesso!')),
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoginEmpresarioPage()),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao cadastrar restaurante: $e')),
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
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/cenario/fundo_agua.png'),
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
                      'Cadastre seu Restaurante',
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      controller: _nomeFantasiaController,
                      label: 'Nome Fantasia',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Informe o nome fantasia';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    _buildTextField(
                      controller: _cnpjController,
                      label: 'CNPJ',
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.length != 14) {
                          return 'Informe um CNPJ válido com 14 dígitos';
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
                          return 'Informe o endereço';
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
                      controller: _descricaoController,
                      label: 'Descrição',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Informe uma descrição';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    _imagem == null
                        ? const Text('Nenhuma imagem selecionada.')
                        : Image.file(_imagem!, height: 150),
                    TextButton(
                      onPressed: _showImageSourceActionSheet,
                      child: const Text('Adicionar Imagem'),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: _isLoading ? null : cadastrarRestaurante,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Cadastrar Restaurante',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white)),
                    ),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginEmpresarioPage(),
                          ),
                        );
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
