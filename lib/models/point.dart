import 'package:equatable/equatable.dart';

class Point extends Equatable {
  int x;
  int y;

  Point(this.x, this.y);

  @override
  List<Object?> get props => [x, y];
}
