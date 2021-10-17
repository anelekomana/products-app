import 'package:equatable/equatable.dart';
import 'package:productsapp/models/product.dart';

abstract class ProductState extends Equatable {
  @override
  List<Object?> get props => [];
}

class Uninitialized extends ProductState {}

class SearchingProducts extends ProductState {}

class FetchingFavourites extends ProductState {}

class AddingFavourite extends ProductState {}

class RemovingFavourite extends ProductState {}

class RemovingFavouriteSuccess extends ProductState {
  final int favCount;
  RemovingFavouriteSuccess({required this.favCount});
  @override
  List<Object?> get props => [favCount];
}

class AddingFavouriteSuccess extends ProductState {
  final int favCount;
  AddingFavouriteSuccess({required this.favCount});
  @override
  List<Object?> get props => [favCount];
}

class SearchingProductsSuccess extends ProductState {
  final List<Product> products;
  SearchingProductsSuccess({required this.products});
  @override
  List<Object?> get props => [products];
}

class FetchingFavouritesSuccess extends ProductState {
  final List<Product> products;
  FetchingFavouritesSuccess({required this.products});
  @override
  List<Object?> get props => [products];
}

class ProductsException extends ProductState {
  final String? message;
  ProductsException({this.message});
  @override
  List<Object?> get props => [message];
}
