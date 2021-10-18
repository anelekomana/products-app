import 'package:flutter/material.dart';
import 'package:productsapp/utils/constants.dart';

class SearchTextField extends StatelessWidget {
  final Function(String value) onSubmitted;
  final _controller = TextEditingController();

  SearchTextField({Key? key, required this.onSubmitted}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      onSubmitted: (value) {
        if (value.isNotEmpty) {
          onSubmitted(value);
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
          borderRadius: const BorderRadius.all(Radius.circular(32.0)),
        ),
      ),
    );
  }
}
