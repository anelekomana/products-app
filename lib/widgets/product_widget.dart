import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:productsapp/models/product.dart';
import 'package:productsapp/utils/constants.dart';

class ProductWidget extends StatelessWidget {
  final Product product;
  final bool isFavourite;
  final Function(Product product)? addToFavourites;
  final Function()? removeFromFavourites;

  const ProductWidget({
    Key? key,
    required this.product,
    required this.isFavourite,
    this.addToFavourites,
    this.removeFromFavourites,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 110,
          padding: const EdgeInsets.all(5),
          margin: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Colors.grey.shade300,
              width: 1,
            ),
            borderRadius: const BorderRadius.all(
              Radius.circular(8),
            ),
          ),
          child: Row(
            children: [
              Container(
                margin: const EdgeInsets.only(left: 8.0),
                child: CachedNetworkImage(
                  width: 80,
                  height: 80,
                  imageUrl: '$kImageBaseUrl${product.image!}',
                ),
              ),
              Flexible(
                child: Container(
                  margin: const EdgeInsets.only(left: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        product.name!,
                        style: TextStyle(
                          color: kPrimaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        product.brand!,
                        style: TextStyle(
                          //fontStyle: FontStyle.italic,
                          color: kSecondaryColor,
                        ),
                      ),
                      Text(product.type!),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        Positioned(
          right: 10,
          bottom: 5,
          child: isFavourite
              ? Transform.scale(
                  scale: 0.8,
                  child: ElevatedButton(
                    child: const Text('Remove'),
                    onPressed: () {
                      removeFromFavourites!();
                    },
                  ),
                )
              : Transform.scale(
                  scale: 0.8,
                  child: ElevatedButton(
                    child: const Text('+ Favourites'),
                    onPressed: () {
                      addToFavourites!(product);
                    },
                  ),
                ),
        ),
      ],
    );
  }
}
