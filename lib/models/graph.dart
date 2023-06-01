import 'package:mobile_application/models/map.dart';
import 'package:mobile_application/models/mapRegion.dart';
import 'package:mobile_application/models/point.dart';

class Graph {
  late int nodeNumber;
  late List<List<int>> adj;

  List<List<int>> predecessor = List<List<int>>.empty(growable: true);
  List<List<int>> distances = List<List<int>>.empty(growable: true);

  List<Point> finalPath = [];

  Map map;

  Graph(this.map) {
    nodeNumber = map.nodesCount;
    adj = List.generate(nodeNumber, (i) => []);
    fillAdj(map);
  }

  void fillAdj(Map map) {
    for (int i = 0; i < map.stringMap.length; i++) {
      for (int j = 0; j < map.stringMap[i].length; j++) {
        if (map.stringMap[i][j] == ".") {
          if (map.stringMap[i][j - 1] == ".") {
            //gora
            addEdge(map.nodesNumber[i][j], map.nodesNumber[i][j - 1]);
          }
          if (map.stringMap[i + 1][j] == ".") {
            //prawo
            addEdge(map.nodesNumber[i][j], map.nodesNumber[i + 1][j]);
          }
          //if (j < map.stringMap[i].length - 1) {
          if (map.stringMap[i][j + 1] == ".") {
            //dol
            addEdge(map.nodesNumber[i][j], map.nodesNumber[i][j + 1]);
          }
          //}

          if (map.stringMap[i - 1][j] == ".") {
            //lewo
            addEdge(map.nodesNumber[i][j], map.nodesNumber[i - 1][j]);
          }
        }
      }
    }
  }

  void addEdge(int startNode, int destinationNode) {
    adj[startNode].add(destinationNode);
  }

  int findRegionPoint(MapRegion region) {
    int x = (region.width.round() / 2).floor() + region.x.round();
    int y = (region.height.round() / 2).floor() + region.y.round();

    return map.nodesNumber[x][y];
  }

  int getDestPoint(int mapRegionId) {
    int x = 0;
    int y = 0;
    for (var element in map.mapRegions) {
      if (element.mapRegionId == mapRegionId) {
        x = element.x.round() + (element.width / 2).round();
        y = element.y.round() + (element.height / 2).round();
      }
    }
    return map.nodesNumber[x][y];
  }

  MapRegion? getStartRegion() {
    for (var region in map.mapRegions) {
      if (region.mapRegionType == 'loadingarea') return region;
    }
    return null;
  }

  void findShortestPath() {
    int id = 0;
    int start = findRegionPoint(getStartRegion()!);
    int destination = getDestPoint(map.listOfProducts[id].mapRegionId);
    String state = 'add';
    for (int i = 0; i < map.listOfProducts.length; i++) {
      if (state == 'add') {
        predecessor.add([]);
        distances.add([]);
        if (bfsAlgorithm(start, destination, predecessor.length - 1) == false) {
          return;
        }
      }

      start = destination;
      if (i < map.listOfProducts.length - 1) {
        int test = i + 1;
        destination = getDestPoint(map.listOfProducts[test].mapRegionId);
        if (destination == start) {
          state = 'skip';
        } else {
          state = 'add';
        }
      }
    }

    List<int> path = List.empty(growable: true);

    int crawl = destination;

    path.add(crawl);

    for (int i = predecessor.length - 1; i >= 0; i--) {
      while (predecessor[i][crawl] != -1) {
        path.add((predecessor[i][crawl]));
        crawl = predecessor[i][crawl];
      }
    }

    for (int i = path.length - 1; i >= 0; i--) {
      for (int j = 1; j < map.nodesNumber.length - 1; j++) {
        for (int k = 1; k < map.warehouseHeight - 1; k++) {
          if (map.nodesNumber[j][k] == path[i]) {
            finalPath.add(Point(j, k));
          }
        }
      }
    }
  }

  bool bfsAlgorithm(int start, int dest, int id) {
    List<bool> visited = List.filled(nodeNumber, false);

    List<int> queue = List.empty(growable: true);

    predecessor[id] = List.filled(nodeNumber, -1);
    distances[id] = List.filled(nodeNumber, -1);

    visited[start] = true;
    distances[id][start] = 0;
    queue.add(start);

    while (queue.isNotEmpty) {
      int u = queue[0];
      queue.removeAt(0);
      for (int i = 0; i < adj[u].length; i++) {
        int idx = adj[u][i];
        if (visited[idx] == false) {
          visited[idx] = true;
          distances[id][idx] = distances[id][u] + 1;
          predecessor[id][idx] = u;
          queue.add(idx);

          if (idx == dest) {
            return true;
          }
        }
      }
    }

    return false;
  }
}
