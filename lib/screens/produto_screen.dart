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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _showEditModal(Produto produto) {
  TextEditingController descricaoController =
      TextEditingController(text: produto.descricao);
  TextEditingController precoController =
      TextEditingController(text: produto.preco.toString());
  TextEditingController estoqueController =
      TextEditingController(text: produto.estoque.toString());
  DateTime date = produto.data;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        title: const Text(
          'Editar Produto',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: descricaoController,
                    decoration: const InputDecoration(
                      labelText: 'Descrição',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: precoController,
                    decoration: const InputDecoration(
                      labelText: 'Preço',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: estoqueController,
                    decoration: const InputDecoration(
                      labelText: 'Estoque',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Text('Data: ${dateFormat.format(date)}'),
                      IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: date,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101),
                          );
                          if (picked != null && picked != date) {
                            setState(() {
                              date = picked;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              final double preco = double.tryParse(precoController.text) ?? 0.0;
              final int estoque = int.tryParse(estoqueController.text) ?? 0;

              final updatedProduto = Produto(
                id: produto.id,
                descricao: descricaoController.text,
                preco: preco,
                estoque: estoque,
                data: date,
              );

              await produtoService.updateProduto(updatedProduto);
              Navigator.of(context).pop();
              setState(() {
                futureProdutos = produtoService.getProdutos();
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            child: const Text('Salvar Alterações'),
          ),
        ],
      );
    },
  );
}

  void _showAddProductModal() {
  TextEditingController descricaoController = TextEditingController();
  TextEditingController precoController = TextEditingController();
  TextEditingController estoqueController = TextEditingController();
  DateTime date = selectedDate;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        title: const Text(
          'Adicionar Produto',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: descricaoController,
                    decoration: const InputDecoration(
                      labelText: 'Descrição',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: precoController,
                    decoration: const InputDecoration(
                      labelText: 'Preço',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: estoqueController,
                    decoration: const InputDecoration(
                      labelText: 'Estoque',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Text('Data: ${dateFormat.format(date)}'),
                      IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: date,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101),
                          );
                          if (picked != null && picked != date) {
                            setState(() {
                              date = picked;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              final double preco = double.tryParse(precoController.text) ?? 0.0;
              final int estoque = int.tryParse(estoqueController.text) ?? 0;
              final newProduto = Produto(
                id: 0,  // O ID será gerado pelo banco de dados
                descricao: descricaoController.text,
                preco: preco,
                estoque: estoque,
                data: date,
              );
              await produtoService.addProduto(newProduto);
              Navigator.of(context).pop();
              setState(() {
                futureProdutos = produtoService.getProdutos();
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            child: const Text('Adicionar Produto'),
          ),
        ],
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
