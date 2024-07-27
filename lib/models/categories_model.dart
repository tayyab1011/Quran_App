// To parse this JSON data, do
//
//     final categoriesModels = categoriesModelsFromJson(jsonString);

import 'dart:convert';

CategoriesModels categoriesModelsFromJson(String str) => CategoriesModels.fromJson(json.decode(str));

String categoriesModelsToJson(CategoriesModels data) => json.encode(data.toJson());

class CategoriesModels {
    String? status;
    List<Datum>? data;
    String? message;

    CategoriesModels({
         this.status,
         this.data,
         this.message
    });

    factory CategoriesModels.fromJson(Map<String, dynamic> json) => CategoriesModels(
        status: json["status"],
        message: json["message"],
        data: json['data'] !=null? List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))): null,
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class Datum {
    int categoriesId;
    String name;
    DateTime addedDate;
    String status;

    Datum({
        required this.categoriesId,
        required this.name,
        required this.addedDate,
        required this.status,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
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
