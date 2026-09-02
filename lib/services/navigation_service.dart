import '../models/indoor_node_model.dart';

class NavigationService {
  List<IndoorNode> findRoute(
      List<IndoorNode> nodes,
      String startId,
      String destinationId,
      ) {
    final Map<String, IndoorNode> nodeMap = {
      for (final node in nodes) node.id: node,
    };

    if (!nodeMap.containsKey(startId) ||
        !nodeMap.containsKey(destinationId)) {
      return [];
    }

    final queue = <String>[startId];

    final Map<String, String?> previous = {
      startId: null,
    };

    while (queue.isNotEmpty) {
      final currentId = queue.removeAt(0);

      if (currentId == destinationId) {
        break;
      }

      final currentNode = nodeMap[currentId];

      if (currentNode == null) {
        continue;
      }

      for (final neighbor in currentNode.connectedNodes) {
        if (!previous.containsKey(neighbor) &&
            nodeMap.containsKey(neighbor)) {
          previous[neighbor] = currentId;
          queue.add(neighbor);
        }
      }
    }

    if (!previous.containsKey(destinationId)) {
      return [];
    }

    final List<IndoorNode> route = [];

    String? current = destinationId;

    while (current != null) {
      final node = nodeMap[current];

      if (node != null) {
        route.add(node);
      }

      current = previous[current];
    }

    return route.reversed.toList();
  }

  List<String> generateDirections(List<IndoorNode> route) {
    final directions = <String>[];

    if (route.length < 2) {
      return ['You have arrived at your destination.'];
    }

    for (int i = 0; i < route.length - 1; i++) {
      final current = route[i];
      final next = route[i + 1];

      if (current.floor != next.floor) {
        directions.add(
          'Move from ${current.floor} to ${next.floor} using ${next.type}.',
        );
      } else {
        directions.add(
          'Walk from ${current.name} to ${next.name}.',
        );
      }
    }

    directions.add('You have arrived at ${route.last.name}.');

    return directions;
  }
}