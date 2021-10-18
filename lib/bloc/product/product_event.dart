import 'package:equatable/equatable.dart';
import 'package:productsapp/models/product.dart';

abstract class ProductEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchFavourites extends ProductEvent {
  final int delay;
  FetchFavourites({required this.delay});
  @override
  List<Object?> get props => [delay];
}

class SearchProducts extends ProductEvent {
  final String query;
  SearchProducts({required this.query});
  @override
  List<Object?> get props => [query];
}

class AddToFavourites extends ProductEvent {
  final Product product;
  AddToFavourites({required this.product});
  @override
  List<Object?> get props => [product];
}

class RemoveFromFavourites extends ProductEvent {
  final Product product;
  RemoveFromFavourites({required this.product});
  @override
  List<Object?> get props => [product];
}
