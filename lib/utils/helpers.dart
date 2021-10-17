import 'package:productsapp/models/product.dart';

bool listContains(int id, List<Product> products) {
  List<Product> productList =
      products.where((element) => element.id == id).toList();
  if (productList.isEmpty) {
    return false;
  }
  return true;
}

List<Product> removeProductById(int id, List<Product> products) {
  products.removeWhere((element) => element.id == id);
  return products;
}
