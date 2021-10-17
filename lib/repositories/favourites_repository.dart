import 'package:productsapp/models/product.dart';

abstract class FavouritesRepository {
  List<Product> getAll();
  void saveAll({required List<Product> products});
  List<Product> save({required Product product});
  List<Product> remove({required Product product});
}
