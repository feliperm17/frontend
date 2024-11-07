import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:frontend/models/produto.dart';
    //'produto.dart';

class ProdutoService {
  final String baseUrl = 'http://localhost:3000/api/v1/produtos'; // ajuste o endereço se necessário

  Future<List<Produto>> getProdutos() async {
    final response = await http.get(Uri.parse('$baseUrl/'));

  

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Produto.fromJson(data)).toList();
    } else {
      throw Exception('Falha ao carregar produtos');
    }
  }

  Future<Produto> getProdutoById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));
    print(json.decode(response.body));
    if (response.statusCode == 200) {
      return Produto.fromJson(json.decode(response.body));
    } else {
      throw Exception('Falha ao carregar produto');
    }
  }

  Future<void> addProduto(Produto produto) async {
    final response = await http.post(
      Uri.parse('$baseUrl/'),
      headers: {"Content-Type": "application/json"},
      body: json.encode(produto.toJson()),
    );
    if (response.statusCode != 201) {
      throw Exception('Falha ao adicionar produto');
    }
  }

  Future<void> updateProduto(Produto produto) async {
  final response = await http.put(
    Uri.parse('$baseUrl/${produto.id}'),
    headers: {"Content-Type": "application/json"},
    body: json.encode(produto.toJson()),
  );
  
  // Adiciona logs para verificar a resposta
  print('Status Code: ${response.statusCode}');
  print('Response Body: ${response.body}');
  
  if (response.statusCode != 200) {
    throw Exception('Falha ao atualizar produto');
  }
}


  Future<void> deleteProduto(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 200) {
      throw Exception('Falha ao deletar produto');
    }
  }
}
