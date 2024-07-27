// To parse this JSON data, do
//
//     final bookViewModels = bookViewModelsFromJson(jsonString);

import 'dart:convert';

BookViewModels bookViewModelsFromJson(String str) => BookViewModels.fromJson(json.decode(str));

String bookViewModelsToJson(BookViewModels data) => json.encode(data.toJson());

class BookViewModels {
    String? status;
    Data? data;

    BookViewModels({
         this.status,
         this.data,
    });

    factory BookViewModels.fromJson(Map<String, dynamic> json) => BookViewModels(
        status: json["status"],
        data:json['data'] !=null ? Data.fromJson(json["data"]):null,
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "data": data!.toJson(),
    };
}

class Data {
    int booksViewsId;
    int usersCustomersId;
    int booksId;
    DateTime addedDate;
    String status;

    Data({
        required this.booksViewsId,
        required this.usersCustomersId,
        required this.booksId,
        required this.addedDate,
        required this.status,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        booksViewsId: json["books_views_id"],
        usersCustomersId: json["users_customers_id"],
        booksId: json["books_id"],
        addedDate: DateTime.parse(json["added_date"]),
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "books_views_id": booksViewsId,
        "users_customers_id": usersCustomersId,
        "books_id": booksId,
        "added_date": addedDate.toIso8601String(),
        "status": status,
    };
}
