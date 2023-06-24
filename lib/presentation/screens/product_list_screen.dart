import 'dart:io';

import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:product_pur_app/config/asset_manager.dart';
import 'package:product_pur_app/config/color_manager.dart';
import 'package:product_pur_app/config/style_manager.dart';
import 'package:product_pur_app/db/model/product_model.dart';
import 'package:product_pur_app/presentation/screens/add_product_screen.dart';
import 'package:product_pur_app/util/snack_bar.dart';

class ProductListScreen extends StatelessWidget {
  final Box<Product> productBox = Hive.box<Product>('products');

  ProductListScreen({Key? key}) : super(key: key);

  Future<void> deleteProduct(int index, context) async {
    final deletedProduct = productBox.getAt(index);
    productBox.deleteAt(index);
    showAnimatedSnackBar(context, 'Deleted ${deletedProduct?.name}',
        type: AnimatedSnackBarType.success);
  }

  Widget buildProductItem(BuildContext context, int index) {
    final product = productBox.getAt(index);
    return Dismissible(
      key: Key(productBox.keyAt(index).toString()),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => deleteProduct(index, context),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(5),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(8),
            leading: Image.file(
              File(product!.imagePath),
            ),
            title: Text(
              product.name,
              style: getRegularStyle(
                color: ColorManager.textColor,
                fontSize: 15,
              ),
            ),
            subtitle: Text(
              'Price: \$${product.price.toStringAsFixed(2)}\nCompany: ${product.company}',
              style: getRegularStyle(
                color: ColorManager.textColor,
                fontSize: 12,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          ColorFiltered(
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.5),
              BlendMode.srcOver,
            ),
            child: Image.asset(
              ImageAssets.background,
              height: size.height,
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: productBox.isEmpty
                ? Text(
                    "No products available",
                    style: getRegularStyle(
                      color: ColorManager.textColor,
                      fontSize: 15,
                    ),
                  )
                : Container(),
          ),
          ValueListenableBuilder<Box<Product>>(
            valueListenable: productBox.listenable(),
            builder: (context, box, _) {
              return ListView.builder(
                itemCount: box.length,
                itemBuilder: buildProductItem,
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorManager.primary,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddProductScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
