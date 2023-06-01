import '../../models/product.dart';

abstract class ProductManagementInterface {
  Future<List<Product>> getProductList(int assignmentId);
}
