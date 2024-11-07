import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/produto.dart';
import '../services/produto_service.dart';

class ProdutoScreen extends StatefulWidget {
  const ProdutoScreen({super.key});

  @override
  ProdutosScreenState createState() => ProdutosScreenState();
}

class ProdutosScreenState extends State<ProdutoScreen> {
  final ProdutoService produtoService = ProdutoService();
  late Future<List<Produto>> futureProdutos;
  final DateFormat dateFormat = DateFormat('dd/MM/yyyy');
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    futureProdutos = produtoService.getProdutos();
    selectedDate = DateTime.now();
  }

  void _showDeleteConfirmation(Produto produto) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmação de Deleção'),
          content: const Text('Tem certeza que deseja deletar este produto?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Deletar'),
              onPressed: () {
                produtoService.deleteProduto(produto.id);
                Navigator.of(context).pop();
                setState(() {
                  futureProdutos = produtoService.getProdutos();
                });
              },
            ),
          ],
        );
      },
    );
  }

  void _showEditModal(Produto produto) {
    TextEditingController descricaoController =
        TextEditingController(text: produto.descricao);
    TextEditingController precoController =
        TextEditingController(text: produto.preco.toString());
    TextEditingController estoqueController =
        TextEditingController(text: produto.estoque.toString());

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16.0,
            right: 16.0,
            top: 16.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Editar Produto', style: TextStyle(fontSize: 18)),
              TextField(
                controller: descricaoController,
                decoration: const InputDecoration(labelText: 'Descrição'),
              ),
              TextField(
                controller: precoController,
                decoration: const InputDecoration(labelText: 'Preço'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: estoqueController,
                decoration: const InputDecoration(labelText: 'Estoque'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () async {
                  final updatedProduto = Produto(
                    id: produto.id,
                    descricao: descricaoController.text,
                    preco: double.parse(precoController.text),
                    estoque: int.parse(estoqueController.text),
                    data: produto.data,  // Mantém a data original
                  );

                  await produtoService.updateProduto(updatedProduto);
                  Navigator.of(context).pop();
                  setState(() {
                    futureProdutos = produtoService.getProdutos();
                  });
                },
                child: const Text('Salvar Alterações'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAddProductModal() {
    TextEditingController descricaoController = TextEditingController();
    TextEditingController precoController = TextEditingController();
    TextEditingController estoqueController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16.0,
            right: 16.0,
            top: 16.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Adicionar Produto', style: TextStyle(fontSize: 18)),
              TextField(
                controller: descricaoController,
                decoration: const InputDecoration(labelText: 'Nome'),
              ),
              TextField(
                controller: precoController,
                decoration: const InputDecoration(labelText: 'Preço'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: estoqueController,
                decoration: const InputDecoration(labelText: 'Estoque'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () async {
                  final newProduto = Produto(
                    id: 0,  // ID será gerado pelo banco
                    descricao: descricaoController.text,
                    preco: double.parse(precoController.text),
                    estoque: int.parse(estoqueController.text),
                    data: selectedDate,  // Data selecionada
                  );
                  await produtoService.addProduto(newProduto);
                  Navigator.of(context).pop();
                  setState(() {
                    futureProdutos = produtoService.getProdutos();
                  });
                },
                child: const Text('Adicionar Produto'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green, // Header verde
        title: const Text(
          'Api-Produtos',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: FutureBuilder<List<Produto>>(
        future: futureProdutos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Erro ao carregar produtos'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhum produto encontrado'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final produto = snapshot.data![index];
                return ListTile(
                  title: Text(produto.descricao),
                  subtitle: Text('Preço: R\$${produto.preco}'),
                  onTap: () {
                    // Ao clicar no produto, exibe os detalhes
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text(produto.descricao),
                          content: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Preço: R\$${produto.preco}'),
                              Text('Estoque: ${produto.estoque}'),
                              Text('Data: ${DateFormat('dd/MM/yyyy').format(produto.data)}'),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                _showEditModal(produto);  // Exibe modal de edição
                              },
                              child: const Text('Editar'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                _showDeleteConfirmation(produto);  // Confirmação de deleção
                              },
                              child: const Text('Deletar'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddProductModal,  // Abre o modal de cadastro de produto
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
      ),
    );
  }
}
