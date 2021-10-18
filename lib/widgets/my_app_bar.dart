import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:productsapp/bloc/product/product_bloc.dart';
import 'package:productsapp/bloc/product/product_event.dart';
import 'package:productsapp/bloc/product/product_state.dart';
import 'package:productsapp/utils/constants.dart';

class MyAppBar extends StatefulWidget with PreferredSizeWidget {
  final String title;
  final bool showFavourites;
  final Function()? openFavourites;

  const MyAppBar({
    Key? key,
    required this.title,
    required this.showFavourites,
    this.openFavourites,
  }) : super(key: key);

  @override
  State<MyAppBar> createState() => _MyAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _MyAppBarState extends State<MyAppBar> {
  FavouriteBlocMixin? _favouriteBlocMixin;
  int _favCount = 0;
  int favFetch = 0;

  @override
  void initState() {
    if (mounted) {
      _favouriteBlocMixin = BlocProvider.of<FavouriteBlocMixin>(context);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<FavouriteBlocMixin, ProductState>(
          listener: (context, state) {
            if (state is FetchingFavouritesSuccess) {
              if (state.products.isEmpty && favFetch < 2) {
                favFetch++;
                _favouriteBlocMixin!.add(FetchFavourites(delay: 5));
              } else {
                setState(() => _favCount = state.products.length);
              }
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
      child: AppBar(
          title: Text(widget.title),
          centerTitle: true,
          actions: widget.showFavourites
              ? [
                  InkWell(
                    onTap: () {
                      widget.openFavourites!();
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
                ]
              : null),
    );
  }
}
