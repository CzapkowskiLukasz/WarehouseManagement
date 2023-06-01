import 'package:mobile_application/DAL/api.dart';
import 'package:mobile_application/DAL/managers/userManagement.dart';
import 'package:mobile_application/DAL/interfaces/productManagementInterface.dart';
import 'package:mobile_application/models/product.dart';

class ProductManagement implements ProductManagementInterface {
  ApiAgent api = ApiAgent();
  UserManagement userManagement = UserManagement();

  @override
  Future<List<Product>> getProductList(int assingmentId) async {
    String? userKey = await userManagement.isLogged();
    List<Product> productList =
        await api.getProductsByAssignment(userKey, assingmentId);
    return productList;
  }
}
