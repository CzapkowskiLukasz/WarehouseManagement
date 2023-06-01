class Product {
  late int productId;
  String name;
  late String assetIcon;
  late num weight;
  late String barcode;
  late int mapRegionId;
  late bool collected;
  late int count;

  Product(this.productId, this.name, this.mapRegionId, this.barcode,
      this.collected, this.weight, this.count) {
    assetIcon = getAssetIcon(weight);
  }

  String getAssetIcon(num weight) {
    if (weight > 2) {
      if (weight > 10) {
        if (weight > 20) {
          return 'assets/xl-package.svg';
        }
        return 'assets/l-package.svg';
      }
      return 'assets/m-package.svg';
    }

    return 'assets/s-package.svg';
  }

  Map toJson() => {
        'productId': productId,
        'name': name,
        'barcode': barcode,
        'mapRegionId': mapRegionId,
        'assetIcon': assetIcon,
        'weight': weight,
        'count': count,
        'collected': collected
      };

  factory Product.fromJson(json) {
    return Product(
        json['productId'] as int,
        json['name'] as String,
        json['mapRegionId'] as int,
        json['barcode'] as String,
        false,
        json['weight'] as num,
        json['count'] as int);
  }

  factory Product.fromJsonWithCollectedFlag(json) {
    return Product(
        json['productId'] as int,
        json['name'] as String,
        json['mapRegionId'] as int,
        json['barcode'] as String,
        json['collected'] as bool,
        json['weight'] as num,
        json['count'] as int);
  }
}
