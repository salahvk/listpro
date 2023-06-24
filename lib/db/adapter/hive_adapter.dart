import 'package:hive_flutter/hive_flutter.dart';
import 'package:product_pur_app/db/model/product_model.dart';

class ProductAdapter extends TypeAdapter<Product> {
  @override
  int get typeId => 0;

  @override
  Product read(BinaryReader reader) {
    return Product(
      name: reader.read(),
      price: reader.read(),
      company: reader.read(),
      imagePath: reader.read(),
    );
  }

  @override
  void write(BinaryWriter writer, Product obj) {
    writer.write(obj.name);
    writer.write(obj.price);
    writer.write(obj.company);
    writer.write(obj.imagePath);
  }
}
