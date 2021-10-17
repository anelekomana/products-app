import 'package:dio/dio.dart';
import 'package:productsapp/models/product.dart';
import 'package:productsapp/repositories/product_repository.dart';
import 'package:productsapp/utils/constants.dart';

class ProductService implements ProductRepository {
  Dio dio = Dio();

  @override
  Future<List<Product>> searchProducts({required String query}) async {
    try {
      final response = await dio.get('$kProductsBaseUrl$query');
      List data = response.data['products']['data'];
      List<Product> products =
          data.map((data) => Product.fromJson(data)).toList();
      return products;
    } catch (e) {
      rethrow;
    }
  }
}
