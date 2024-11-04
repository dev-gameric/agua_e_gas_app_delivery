import 'dart:io';
import 'package:aguaegas/api/models/produto.dart';
import 'package:aguaegas/api/services/produto_service.dart';
import 'package:aguaegas/screens/fornecedor/home/home_empresario.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  String? _nomeProduto;
  String? _descricao;
  double? _preco;
  String? _categoria;
  int? _quantidadeEstoque;
  File? _imagem;

  final ImagePicker _picker = ImagePicker();
  final ProdutoService _produtoService = ProdutoService();

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

  void _adicionarProduto() async {
    if (_formKey.currentState!.validate()) {
      if (_imagem == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor, adicione uma imagem.')),
        );
        return;
      }

      String imageUrl;
      try {
        imageUrl = await saveImageLocally(_imagem!);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao salvar a imagem: $e')),
        );
        return;
      }

      final prefs = await SharedPreferences.getInstance();
      final restauranteId = prefs.getInt('restauranteId');

      if (restauranteId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('ID do restaurante não encontrado.')),
        );
        return;
      }

      final produto = Produto(
        id: 0,
        nome: _nomeProduto!,
        categoria: _categoria!,
        descricao: _descricao!,
        preco: _preco!,
        photoUrl: imageUrl,
        quantidadeEstoque: _quantidadeEstoque ?? 0,
        restauranteId: restauranteId,
      );

      try {
        await _produtoService.cadastrarProduto(produto);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Produto adicionado com sucesso')),
        );
        await Future.delayed(const Duration(seconds: 1));
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const HomeEmpresarioPage()),
          (route) => false,
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao adicionar produto: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Produto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField(
                label: 'Nome do Produto',
                onChanged: (value) => _nomeProduto = value,
                validator: (value) => value == null || value.isEmpty
                    ? 'Por favor, insira o nome do produto'
                    : null,
              ),
              _buildTextField(
                label: 'Categoria',
                onChanged: (value) => _categoria = value,
                validator: (value) => value == null || value.isEmpty
                    ? 'Por favor, insira a categoria'
                    : null,
              ),
              _buildTextField(
                label: 'Descrição',
                onChanged: (value) => _descricao = value,
                validator: (value) => value == null || value.isEmpty
                    ? 'Por favor, insira a descrição'
                    : null,
              ),
              _buildTextField(
                label: 'Preço',
                keyboardType: TextInputType.number,
                onChanged: (value) => _preco = double.tryParse(value!),
                validator: (value) =>
                    value == null || double.tryParse(value) == null
                        ? 'Por favor, insira um preço válido'
                        : null,
              ),
              _buildTextField(
                label: 'Quantidade em Estoque',
                keyboardType: TextInputType.number,
                onChanged: (value) => _quantidadeEstoque = int.tryParse(value!),
                validator: (value) =>
                    value == null || int.tryParse(value) == null
                        ? 'Por favor, insira uma quantidade válida'
                        : null,
              ),
              const SizedBox(height: 20),
              _imagem == null
                  ? const Text('Nenhuma imagem selecionada.')
                  : Image.file(_imagem!, height: 150),
              TextButton(
                onPressed: _showImageSourceActionSheet,
                child: const Text('Adicionar Imagem'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                onPressed: _adicionarProduto,
                child: const Text('Adicionar Produto',
                    style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required ValueChanged<String?> onChanged,
    required String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          vertical: 8.0), // Melhor espaçamento vertical
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey),
          ),
          const SizedBox(height: 8), // Espaço entre label e campo
          TextFormField(
            keyboardType: keyboardType,
            onChanged: onChanged,
            validator: validator,
            decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).primaryColor),
                borderRadius: BorderRadius.circular(12),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.blueAccent),
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.symmetric(
                  vertical: 12, horizontal: 16), // Espaçamento interno
            ),
          ),
        ],
      ),
    );
  }
}
