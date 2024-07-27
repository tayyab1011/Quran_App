// To parse this JSON data, do
//
//     final booksModels = booksModelsFromJson(jsonString);

import 'dart:convert';

BooksModels booksModelsFromJson(String str) => BooksModels.fromJson(json.decode(str));

String booksModelsToJson(BooksModels data) => json.encode(data.toJson());

class BooksModels {
    String? status;
    List<Datum>? data;
    String? message;

    BooksModels({
         this.status,
         this.data,
         this.message
    });

    factory BooksModels.fromJson(Map<String, dynamic> json) => BooksModels(
        status: json["status"],
        message: json["message"],
        data:json['data'] != null ? List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))):null,
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class Datum {
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
    Category category;
    Author author;

    Datum({
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
        required this.category,
        required this.author,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
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
        category: Category.fromJson(json["category"]),
        author: Author.fromJson(json["author"]),
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
        "category": category.toJson(),
        "author": author.toJson(),
    };
}

class Author {
    int authorsId;
    String name;
    String description;
    String image;
    DateTime addedDate;
    String status;

    Author({
        required this.authorsId,
        required this.name,
        required this.description,
        required this.image,
        required this.addedDate,
        required this.status,
    });

    factory Author.fromJson(Map<String, dynamic> json) => Author(
        authorsId: json["authors_id"],
        name: json["name"],
        description: json["description"],
        image: json["image"],
        addedDate: DateTime.parse(json["added_date"]),
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "authors_id": authorsId,
        "name": name,
        "description": description,
        "image": image,
        "added_date": addedDate.toIso8601String(),
        "status": status,
    };
}

class Category {
    int categoriesId;
    String name;
    DateTime addedDate;
    String status;

    Category({
        required this.categoriesId,
        required this.name,
        required this.addedDate,
        required this.status,
    });

    factory Category.fromJson(Map<String, dynamic> json) => Category(
        categoriesId: json["categories_id"],
        name: json["name"],
        addedDate: DateTime.parse(json["added_date"]),
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "categories_id": categoriesId,
        "name": name,
        "added_date": addedDate.toIso8601String(),
        "status": status,
    };
}
