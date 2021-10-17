import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pagination_view/pagination_view.dart';
import 'package:productsapp/bloc/product/product_bloc.dart';
import 'package:productsapp/bloc/product/product_event.dart';
import 'package:productsapp/bloc/product/product_state.dart';
import 'package:productsapp/models/product.dart';
import 'package:productsapp/utils/constants.dart';
import 'package:productsapp/widgets/product_widget.dart';
import 'package:quiver/iterables.dart';

import 'favourite_products_page.dart';

class ProductSearchPage extends StatefulWidget {
  const ProductSearchPage({Key? key}) : super(key: key);

  @override
  State<ProductSearchPage> createState() => _ProductSearchPageState();
}

class _ProductSearchPageState extends State<ProductSearchPage> {
  final _controller = TextEditingController();
  FavouriteBlocMixin? _favouriteBlocMixin;
  ProductBloc? _productBloc;
  GlobalKey<PaginationViewState>? _key;
  int _favCount = 0;
  int _page = -1;

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
        appBar: AppBar(
          title: const Text('ProductsApp'),
          centerTitle: true,
          actions: [
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FavouriteProductsPage(),
                  ),
                );
              },
              child: Center(
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 15),
                      child: const Icon(Icons.favorite),
                    ),
                    (_favCount > 0)
                        ? Positioned(
                            right: 5,
                            top: 0,
                            child: Container(
                              height: 20,
                              width: 20,
                              decoration: BoxDecoration(
                                color: kSecondaryColor,
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(100),
                                ),
                              ),
                              child: Center(
                                  child: (_favCount <= 9)
                                      ? Text('$_favCount')
                                      : const Text('9+')),
                            ),
                          )
                        : const SizedBox(height: 20, width: 20)
                  ],
                ),
              ),
            ),
          ],
        ),
        body: MultiBlocListener(
          listeners: [
            BlocListener<FavouriteBlocMixin, ProductState>(
              listener: (context, state) {
                if (state is FetchingFavouritesSuccess) {
                  setState(() => _favCount = state.products.length);
                }
                if (state is AddingFavouriteSuccess) {
                  setState(() => _favCount = state.favCount);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Added to favourites")),
                  );
                }
                if (state is RemovingFavouriteSuccess) {
                  setState(() => _favCount = state.favCount);
                }
              },
            ),
          ],
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(
                    top: 10, bottom: 10, left: 5, right: 5),
                child: TextField(
                  controller: _controller,
                  onSubmitted: (value) {
                    if (value.isNotEmpty) {
                      _productBloc!.add(SearchProducts(query: value));
                    }
                  },
                  decoration: InputDecoration(
                    hintText: 'Search product by name',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                      onPressed: () {
                        if (_controller.text.isNotEmpty) {
                          _controller.clear();
                        }
                      },
                      icon: const Icon(Icons.clear),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 20.0,
                    ),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: kPrimaryColor,
                        width: 2.0,
                      ),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(32.0)),
                    ),
                  ),
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
                      // return ListView.builder(
                      //   scrollDirection: Axis.vertical,
                      //   shrinkWrap: true,
                      //   itemCount: state.products.length,
                      //   itemBuilder: (BuildContext context, int index) {
                      //     return ProductWidget(
                      //       product: state.products[index],
                      //       isFavourite: false,
                      //       addToFavourites: (Product product) {
                      //         _favouriteBlocMixin!.add(AddToFavourites(
                      //           product: product,
                      //         ));
                      //       },
                      //     );
                      //   },
                      // );
                    } else {
                      return const Center(child: Text("No data found"));
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
