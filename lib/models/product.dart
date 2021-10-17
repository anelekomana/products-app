class Product {
  int? id;
  String? name;
  String? image;
  String? brand;
  String? type;

  Product({
    this.id,
    this.name,
    this.image,
    this.brand,
    this.type,
  });

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? '';
    name = json['name'] ?? '';
    image = json['image'] ?? '';
    brand = json['brand'] != null ? json['brand']['name'] : '';
    type = json['type'] != null ? json['type']['name'] : '';
  }

  Product.fromJson2(Map<String, dynamic> json) {
    id = json['id'] ?? '';
    name = json['name'] ?? '';
    image = json['image'] ?? '';
    brand = json['brand'] ?? '';
    type = json['type'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['image'] = image;
    data['brand'] = brand;
    data['type'] = type;
    return data;
  }

  static List<Map<String, dynamic>> toJsonList(List<Product> products) {
    return products.map((item) => item.toJson()).toList();
  }

  static List<Product> fromJsonList(List<dynamic> data) {
    return data.map((item) => Product.fromJson2(item)).toList();
  }
}
