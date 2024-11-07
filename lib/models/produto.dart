class Produto {
  final int id;
  final String descricao;
  final double preco;
  final int estoque; // Adiciona o campo estoque
  final DateTime data;

  Produto({
    required this.id,
    required this.descricao,
    required this.preco,
    required this.estoque, // Inclui estoque no construtor
    required this.data,
  });

  // Converte JSON em um objeto Produto
  factory Produto.fromJson(Map<String, dynamic> json) {
    return Produto(
      id: json['id'],
      descricao: json['descricao'],
      preco: json['preco'].toDouble(),
      estoque: json['estoque'], // Adiciona estoque
      data: DateTime.parse(json['data']),
    );
  }

  // Converte Produto em JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'descricao': descricao,
      'preco': preco,
      'estoque': estoque, // Inclui estoque na conversão para JSON
      'data': data.toIso8601String(),
    };
  }
}
