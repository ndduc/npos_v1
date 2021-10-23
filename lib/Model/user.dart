import 'dart:convert';

List<Albums> albumsFromJson(String str) => List<Albums>.from(json.decode(str).map((x) => Albums.fromJson(x)));

String albumsToJson(List<Albums> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Albums {
  Albums({
    required this.id,
    required this.title,
  });

  late int id;
  late  String title;

  factory Albums.fromJson(Map<String, dynamic> json) => Albums(
    id: json["id"],
    title: json["email"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
  };
}