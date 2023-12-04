class UserModel {
  final int uid;
  final String name, allergies;
  final List<int> prescIdList;

  UserModel(
    this.name, {
    required this.uid,
    required this.prescIdList,
    required this.allergies,
  });

  UserModel.fromJson(Map<String, dynamic> json)
      : uid = json['uid'],
        name = json['name'],
        prescIdList = json['prescIdList'],
        allergies = json['allergic'];
}
