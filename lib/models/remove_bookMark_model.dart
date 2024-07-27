// To parse this JSON data, do
//
//     final removeBookMarkModels = removeBookMarkModelsFromJson(jsonString);

import 'dart:convert';

RemoveBookMarkModels removeBookMarkModelsFromJson(String str) => RemoveBookMarkModels.fromJson(json.decode(str));

String removeBookMarkModelsToJson(RemoveBookMarkModels data) => json.encode(data.toJson());

class RemoveBookMarkModels {
    String? status;
    String? message;

    RemoveBookMarkModels({
         this.status,
         this.message,
    });

    factory RemoveBookMarkModels.fromJson(Map<String, dynamic> json) => RemoveBookMarkModels(
        status: json["status"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
    };
}
