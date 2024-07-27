// To parse this JSON data, do
//
//     final bookDownloadModels = bookDownloadModelsFromJson(jsonString);

import 'dart:convert';

BookDownloadModels bookDownloadModelsFromJson(String str) =>
    BookDownloadModels.fromJson(json.decode(str));

String bookDownloadModelsToJson(BookDownloadModels data) =>
    json.encode(data.toJson());

class BookDownloadModels {
  String? status;
  String? message;
  Data? data;

  BookDownloadModels({
    this.status,
    this.message,
    this.data,
  });

  factory BookDownloadModels.fromJson(Map<String, dynamic> json) =>
      BookDownloadModels(
        status: json["status"],
        message: json["message"],
        data: json['data'] != null ? Data.fromJson(json["data"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data!.toJson(),
      };
}

class Data {
  int booksId;
  int categoriesId;
  int authorsId;
  String title;
  int pages;
  String bookUrl;
  String cover;
  int downloads;
  DateTime dateAdded;
  String status;

  Data({
    required this.booksId,
    required this.categoriesId,
    required this.authorsId,
    required this.title,
    required this.pages,
    required this.bookUrl,
    required this.cover,
    required this.downloads,
    required this.dateAdded,
    required this.status,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        booksId: json["books_id"],
        categoriesId: json["categories_id"],
        authorsId: json["authors_id"],
        title: json["title"],
        pages: json["pages"],
        bookUrl: json["book_url"],
        cover: json["cover"],
        downloads: json["downloads"],
        dateAdded: DateTime.parse(json["date_added"]),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "books_id": booksId,
        "categories_id": categoriesId,
        "authors_id": authorsId,
        "title": title,
        "pages": pages,
        "book_url": bookUrl,
        "cover": cover,
        "downloads": downloads,
        "date_added": dateAdded.toIso8601String(),
        "status": status,
      };
}
