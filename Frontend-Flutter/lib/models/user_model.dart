class UserModel {
  final int uid;
  final String name, allergies;
  final List<int> prescId;

  UserModel(
    this.name, {
    required this.uid,
    required this.prescId,
    required this.allergies,
  });

  UserModel.fromJson(Map<String, dynamic> json)
      : uid = json['uid'],
        name = json['name'],
        prescId = json['prescId'],
        allergies = json['allergic'];
}
