class IndoorNode {
  final String id;
  final String name;
  final String block;
  final String floor;
  final String type;
  final List<String> connectedNodes;

  const IndoorNode({
    required this.id,
    required this.name,
    required this.block,
    required this.floor,
    required this.type,
    required this.connectedNodes,
  });

  factory IndoorNode.fromMap(Map<String, dynamic> map) {
    return IndoorNode(
      id: map['id']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      block: map['block']?.toString() ?? '',
      floor: map['floor']?.toString() ?? '',
      type: map['type']?.toString() ?? 'room',
      connectedNodes: List<String>.from(
        map['connectedNodes'] ?? const [],
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'block': block,
      'floor': floor,
      'type': type,
      'connectedNodes': connectedNodes,
    };
  }
}