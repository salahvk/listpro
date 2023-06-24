import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:product_pur_app/config/asset_manager.dart';
import 'package:product_pur_app/config/style_manager.dart';
import 'package:product_pur_app/controllers/text_controllers.dart';
import 'package:product_pur_app/db/model/product_model.dart';
import 'package:product_pur_app/util/snack_bar.dart';
import 'package:product_pur_app/config/color_manager.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  AddProductScreenState createState() => AddProductScreenState();
}

class AddProductScreenState extends State<AddProductScreen> {
  String? imagePath;
  bool isProductAdding = false;

  void _selectImage() async {
    final imageFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (imageFile != null) {
      setState(() {
        imagePath = imageFile.path;
      });
    }
  }

  addProduct() {
    final String name = AddProductControllers.nameController.text;
    final String priceCo = AddProductControllers.priceController.text;
    final String company = AddProductControllers.companyController.text;
    if (name.isEmpty) {
      showAnimatedSnackBar(context, "Enter the product name");
    } else if (priceCo.isEmpty) {
      showAnimatedSnackBar(context, "Enter the Price");
    } else if (priceCo.isEmpty) {
      showAnimatedSnackBar(context, "Enter the Company name");
    } else if (imagePath?.isEmpty ?? true) {
      showAnimatedSnackBar(context, "Choose an Image");
    } else {
      setState(() {
        isProductAdding = true;
      });
      final double price = double.parse(priceCo);

      final Product newProduct = Product(
        name: name,
        price: price,
        company: company,
        imagePath: imagePath ?? '',
      );

      Hive.box<Product>('products').add(newProduct);
      setState(() {
        isProductAdding = false;
      });
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Product'),
        backgroundColor: ColorManager.primary,
      ),
      body: SingleChildScrollView(
        child: Stack(
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
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  InkWell(
                    onTap: _selectImage,
                    child: Container(
                      height: 200.0,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(color: Colors.grey),
                      ),
                      child: imagePath != null
                          ? Image.file(File(imagePath!))
                          : const Icon(Icons.camera_alt, size: 80.0),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    style: getRegularStyle(
                      color: ColorManager.textColor,
                      fontSize: 20,
                    ),
                    controller: AddProductControllers.nameController,
                    decoration: InputDecoration(
                      labelText: 'Product Name',
                      labelStyle: getRegularStyle(
                        color: ColorManager.textColor,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    style: getRegularStyle(
                      color: ColorManager.textColor,
                      fontSize: 20,
                    ),
                    controller: AddProductControllers.priceController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Price',
                      labelStyle: getRegularStyle(
                        color: ColorManager.textColor,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    controller: AddProductControllers.companyController,
                    style: getRegularStyle(
                      color: ColorManager.textColor,
                      fontSize: 20,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Company',
                      labelStyle: getRegularStyle(
                        color: ColorManager.textColor,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: addProduct,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: ColorManager.primary),
                    child: isProductAdding
                        ? const CircularProgressIndicator()
                        : const Text('Add Product'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
