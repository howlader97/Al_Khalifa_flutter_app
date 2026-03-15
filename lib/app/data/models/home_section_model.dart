class HomeSectionModel {
  final int id;
  final String name;
  final List<dynamic> products;

  HomeSectionModel({
    required this.id,
    required this.name,
    required this.products,
  });

  factory HomeSectionModel.fromJson(Map<String, dynamic> json) {
    return HomeSectionModel(
      id: json['id'],
      name: json['name'],
      products: json['products'] != null
          ? (json['products'] as List).toList()
          : [],
    );
  }
}
