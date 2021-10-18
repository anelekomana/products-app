import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:productsapp/utils/constants.dart';
import 'bloc/product/product_bloc.dart';
import 'bloc/product/product_event.dart';
import 'pages/product_search_page.dart';

void main() {
  runApp(MultiBlocProvider(providers: <BlocProvider<dynamic>>[
    BlocProvider<ProductBloc>(
      create: (_) => ProductBloc(),
    ),
    BlocProvider<FavouriteBlocMixin>(
      create: (_) => ProductBloc()..add(FetchFavourites(delay: 5)),
    ),
  ], child: const App()));
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.light(
          primary: kPrimaryColor,
        ),
      ),
      home: const ProductSearchPage(),
    );
  }
}
