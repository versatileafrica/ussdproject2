class testFields {
  static final List<String> values = [
    //add all fields
    id, libeler, codeussd, simchoice
  ];
  static final String id = "id";
  static final String libeler = "libeler";
  static final String codeussd = "codeussd";
  static final String simchoice = "simchoice";
}

class test {
  final int id;
  final String libeler;
  final String codeussd;
  final int simchoice;

  const test({
    required this.id,
    required this.libeler,
    required this.codeussd,
    required this.simchoice,
  });

  factory test.fromJson(Map<String, dynamic> json) {
    return test(
      id: json['id'],
      libeler: json['libeler'],
      codeussd: json['codeussd'],
      simchoice: json['simchoice'],
    );
  }
  static test fromJsonn(Map<String, Object?> json) => test(
        id: json['id'] as int,
        libeler: json['libeler'] as String,
        codeussd: json['codeussd'] as String,
        simchoice: json['simchoice'] as int,
      );

  test copy({
    int? id,
    String? libeler,
    String? codeussd,
    int? simchoice,
  }) =>
      test(
          id: id ?? this.id,
          libeler: libeler ?? this.libeler,
          codeussd: codeussd ?? this.codeussd,
          simchoice: simchoice ?? this.simchoice);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id.toString();
    data['libeler'] = this.libeler;
    data['codeussd'] = this.codeussd;
    data['simchoice'] = this.simchoice;
    return data;
  }
}
