import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pagination_view/pagination_view.dart';
import 'package:productsapp/bloc/product/product_bloc.dart';
import 'package:productsapp/bloc/product/product_event.dart';
import 'package:productsapp/bloc/product/product_state.dart';
import 'package:productsapp/models/product.dart';
import 'package:productsapp/utils/constants.dart';
import 'package:productsapp/widgets/my_app_bar.dart';
import 'package:productsapp/widgets/product_widget.dart';
import 'package:productsapp/widgets/search_textfield.dart';
import 'package:quiver/iterables.dart';

import 'favourite_products_page.dart';

class ProductSearchPage extends StatefulWidget {
  const ProductSearchPage({Key? key}) : super(key: key);

  @override
  State<ProductSearchPage> createState() => _ProductSearchPageState();
}

class _ProductSearchPageState extends State<ProductSearchPage> {
  FavouriteBlocMixin? _favouriteBlocMixin;
  ProductBloc? _productBloc;
  GlobalKey<PaginationViewState>? _key;
  int _page = -1;
  int favFetch = 0;

  @override
  void initState() {
    _key = GlobalKey<PaginationViewState>();
    _favouriteBlocMixin = BlocProvider.of<FavouriteBlocMixin>(context);
    _productBloc = BlocProvider.of<ProductBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(
          title: 'ProductsApp',
          showFavourites: true,
          openFavourites: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const FavouriteProductsPage(),
              ),
            );
          },
        ),
        body: Column(
          children: [
            Container(
              margin:
                  const EdgeInsets.only(top: 10, bottom: 10, left: 5, right: 5),
              child: SearchTextField(
                onSubmitted: (value) {
                  _productBloc!.add(SearchProducts(query: value));
                },
              ),
            ),
            Expanded(
              child: BlocBuilder<ProductBloc, ProductState>(
                builder: (context, ProductState state) {
                  if (state is SearchingProducts) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is SearchingProductsSuccess) {
                    if (state.products.isEmpty) {
                      return const Center(child: Text("No data found"));
                    }
                    var paginatedData = partition(state.products, 20);
                    return PaginationView<Product>(
                      key: _key,
                      preloadedItems: paginatedData.first,
                      paginationViewType: PaginationViewType.listView,
                      itemBuilder:
                          (BuildContext context, Product product, int index) {
                        return ProductWidget(
                          product: product,
                          isFavourite: false,
                          addToFavourites: (Product product) {
                            _favouriteBlocMixin!.add(AddToFavourites(
                              product: product,
                            ));
                          },
                        );
                      },
                      pageFetch: (int offset) async {
                        _page = (offset / 20).round();
                        if (paginatedData.length > _page + 1) {
                          await Future<void>.delayed(
                              const Duration(seconds: 2));
                          return paginatedData.elementAt(_page + 1);
                        } else {
                          return [];
                        }
                      },
                      pullToRefresh: true,
                      onError: (dynamic error) => const Center(
                        child: Text('Error occured'),
                      ),
                      onEmpty: const Center(
                        child: Text('No data found'),
                      ),
                      bottomLoader: const Center(
                        child: CircularProgressIndicator(),
                      ),
                      initialLoader: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else {
                    return const Center(child: Text("No data found"));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
