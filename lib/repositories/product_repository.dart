import 'package:productsapp/models/product.dart';

abstract class ProductRepository {
  Future<List<Product>> searchProducts({required String query});
}
