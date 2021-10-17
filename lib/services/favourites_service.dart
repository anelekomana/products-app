import 'package:localstorage/localstorage.dart';
import 'package:productsapp/models/product.dart';
import 'package:productsapp/repositories/favourites_repository.dart';
import 'package:productsapp/utils/helpers.dart';

class FavouritesService implements FavouritesRepository {
  final LocalStorage storage = LocalStorage('favourites_db');

  @override
  List<Product> getAll() {
    try {
      final data = storage.getItem('favourites') ?? [];
      List<Product> favourites = Product.fromJsonList(data);
      favourites.sort((a, b) => a.name!.compareTo(b.name!));
      return favourites;
    } catch (e) {
      rethrow;
    }
  }

  @override
  void saveAll({required List<Product> products}) {
    try {
      storage.setItem('favourites', Product.toJsonList(products));
    } catch (e) {
      rethrow;
    }
  }

  @override
  List<Product> remove({required Product product}) {
    try {
      List<Product> favourites = getAll();
      if (listContains(product.id!, favourites)) {
        favourites = removeProductById(product.id!, favourites);
        saveAll(products: favourites);
      }
      return favourites;
    } catch (e) {
      rethrow;
    }
  }

  @override
  List<Product> save({required Product product}) {
    try {
      List<Product> favourites = getAll();
      if (!listContains(product.id!, favourites)) {
        favourites.add(product);
        saveAll(products: favourites);
      }
      return favourites;
    } catch (e) {
      rethrow;
    }
  }
}
