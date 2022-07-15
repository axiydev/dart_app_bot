import 'package:uuid/uuid.dart';

class Book {
  final String? name;
  final String? author;
  final String? id;
  final String? link;

  const Book(
      {required this.name,
      required this.author,
      required this.id,
      required this.link});

  Book.fromJson(Map<String, dynamic> json)
      : name = json['name'] ?? 'unknown',
        author = json['author'] ?? 'author',
        id = json['id'] ?? Uuid().v1(),
        link = json['link'] ?? '';

  Map<String, dynamic> get toJson =>
      {"name": name, "author": author, "id": id, "link": link};
}
