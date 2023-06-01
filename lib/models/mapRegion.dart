class MapRegion {
  int mapRegionId;
  double x;
  double y;
  double height;
  double width;
  String name;
  String mapRegionType;

  MapRegion(this.mapRegionId, this.x, this.y, this.height, this.width,
      this.name, this.mapRegionType);

  factory MapRegion.fromJson(json, scale) {
    return MapRegion(
        json['mapRegionId'] as int,
        (json['x'] as int).toDouble() * scale,
        (json['y'] as int).toDouble() * scale,
        (json['height'] as int).toDouble() * scale,
        (json['width'] as int).toDouble() * scale,
        json['name'] as String,
        json['mapRegionType'] as String);
  }
}
