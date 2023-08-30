import 'package:dio/dio.dart';

class UserData {
  int id;
  String name;
  List<MultipartFile> images;
  List<UserData> supervisors;

  UserData({
    required this.id,
    required this.name,
    required this.images,
    required this.supervisors,
  });

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "images": images,
      };
}
