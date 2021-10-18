import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:productsapp/models/product.dart';
import 'package:productsapp/services/favourites_service.dart';
import 'package:productsapp/services/product_service.dart';

import 'product_event.dart';
import 'product_state.dart';

mixin FavouriteBlocMixin on Bloc<ProductEvent, ProductState> {}

class ProductBloc extends Bloc<ProductEvent, ProductState>
    with FavouriteBlocMixin {
  ProductService productService = ProductService();
  FavouritesService favouritesService = FavouritesService();

  ProductBloc() : super(Uninitialized());

  @override
  Stream<ProductState> mapEventToState(ProductEvent event) async* {
    if (event is FetchFavourites) {
      yield* _mapFetchFavouritesToState(delay: event.delay);
    }
    if (event is SearchProducts) {
      yield* _mapSearchProductsToState(query: event.query);
    }
    if (event is AddToFavourites) {
      yield* _mapAddFavouriteToState(product: event.product);
    }
    if (event is RemoveFromFavourites) {
      yield* _mapRemoveFavouriteToState(product: event.product);
    }
  }

  Stream<ProductState> _mapSearchProductsToState({
    required String query,
  }) async* {
    yield SearchingProducts();
    try {
      List<Product> products =
          await productService.searchProducts(query: query);
      yield SearchingProductsSuccess(products: products);
    } catch (e) {
      print(e);
      yield ProductsException();
    }
  }

  Stream<ProductState> _mapFetchFavouritesToState({
    required int delay,
  }) async* {
    yield FetchingFavourites();
    try {
      await Future.delayed(Duration(seconds: delay));
      List<Product> favourites = favouritesService.getAll();
      yield FetchingFavouritesSuccess(products: favourites);
    } catch (e) {
      yield ProductsException();
    }
  }

  Stream<ProductState> _mapAddFavouriteToState({
    required Product product,
  }) async* {
    yield AddingFavourite();
    try {
      List<Product> favourites = favouritesService.save(
        product: product,
      );
      yield AddingFavouriteSuccess(favCount: favourites.length);
    } catch (e) {
      yield ProductsException();
    }
  }

  Stream<ProductState> _mapRemoveFavouriteToState({
    required Product product,
  }) async* {
    yield RemovingFavourite();
    try {
      List<Product> favourites = favouritesService.remove(
        product: product,
      );
      yield RemovingFavouriteSuccess(favCount: favourites.length);
    } catch (e) {
      yield ProductsException();
    }
  }
}
