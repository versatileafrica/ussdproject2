class marchand {
  final int id;
  final String nom_marchand;
  final int id_marchand;
  final int simchoice;

  const marchand({
    required this.id,
    required this.nom_marchand,
    required this.id_marchand,
    required this.simchoice,
  });

  factory marchand.fromJson(Map<String, dynamic> json) {
    return marchand(
      id: json['id'],
      nom_marchand: json['nom_marchand'],
      id_marchand: json['id_marchand'],
      simchoice: json['simchoice'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id.toString();
    data['nom_marchand'] = this.nom_marchand;
    data['id_marchand'] = this.id_marchand;
    data['simchoice'] = this.simchoice;
    return data;
  }
}
