import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:productsapp/bloc/product/product_bloc.dart';
import 'package:productsapp/bloc/product/product_event.dart';
import 'package:productsapp/bloc/product/product_state.dart';
import 'package:productsapp/models/product.dart';
import 'package:productsapp/widgets/my_app_bar.dart';
import 'package:productsapp/widgets/product_widget.dart';

class FavouriteProductsPage extends StatefulWidget {
  const FavouriteProductsPage({Key? key}) : super(key: key);

  @override
  State<FavouriteProductsPage> createState() => _FavouriteProductsPageState();
}

class _FavouriteProductsPageState extends State<FavouriteProductsPage> {
  FavouriteBlocMixin? _productBloc;

  @override
  void initState() {
    _productBloc = BlocProvider.of<FavouriteBlocMixin>(context);
    _productBloc!.add(FetchFavourites(delay: 0));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: const MyAppBar(
          title: 'Favourites',
          showFavourites: false,
        ),
        body: BlocConsumer<FavouriteBlocMixin, ProductState>(
          listener: (context, ProductState state) {
            if (state is RemovingFavouriteSuccess) {
              _productBloc!.add(FetchFavourites(delay: 0));
            }
          },
          builder: (context, ProductState state) {
            if (state is FetchingFavourites) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is FetchingFavouritesSuccess) {
              if (state.products.isEmpty) {
                return const Center(child: Text("No data found"));
              }
              return Builder(
                builder: (context) {
                  return ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: state.products.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ProductWidget(
                        product: state.products[index],
                        isFavourite: true,
                        removeFromFavourites: () {
                          _productBloc!.add(RemoveFromFavourites(
                            product: state.products[index],
                          ));
                        },
                      );
                    },
                  );
                },
              );
            } else {
              return const Center(child: Text("Failed to fetch data"));
            }
          },
        ),
      ),
    );
  }
}
