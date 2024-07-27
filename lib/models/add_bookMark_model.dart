// To parse this JSON data, do
//
//     final addBookMarkModels = addBookMarkModelsFromJson(jsonString);

import 'dart:convert';

AddBookMarkModels addBookMarkModelsFromJson(String str) => AddBookMarkModels.fromJson(json.decode(str));

String addBookMarkModelsToJson(AddBookMarkModels data) => json.encode(data.toJson());

class AddBookMarkModels {
    String? status;
    Data? data;
    String? message;

    AddBookMarkModels({
         this.status,
         this.message,
         this.data,
    });

    factory AddBookMarkModels.fromJson(Map<String, dynamic> json) => AddBookMarkModels(
        status: json["status"],
        message: json["message"],
        data:json['data'] !=null ? Data.fromJson(json["data"]):null,
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data!.toJson(),
    };
}

class Data {
    String usersCustomersId;
    String booksId;
    String bookmarkBooksId;

    Data({
        required this.usersCustomersId,
        required this.booksId,
        required this.bookmarkBooksId,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        usersCustomersId: json["users_customers_id"].toString(),
        booksId: json["books_id"].toString(),
        bookmarkBooksId: json["bookmark_books_id"].toString(),
    );

    Map<String, dynamic> toJson() => {
        "users_customers_id": usersCustomersId,
        "books_id": booksId,
        "bookmark_books_id": bookmarkBooksId,
    };
}
