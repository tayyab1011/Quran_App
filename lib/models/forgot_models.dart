// To parse this JSON data, do
//
//     final forgotModels = forgotModelsFromJson(jsonString);

import 'dart:convert';

ForgotModels forgotModelsFromJson(String str) => ForgotModels.fromJson(json.decode(str));

String forgotModelsToJson(ForgotModels data) => json.encode(data.toJson());

class ForgotModels {
  String? status;
  Data? data;
  String? message;

  ForgotModels({
     this.status,
     this.data,
    this.message
  });

  factory ForgotModels.fromJson(Map<String, dynamic> json) => ForgotModels(
    status: json["status"],
    message: json['message'],
    data : json["data"] != null ? Data.fromJson(json["data"]) : null,
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    'message': message,
    "data": data!.toJson(),
  };
}

class Data {
  int? otp;
  String? message;

  Data({
     this.otp,
     this.message,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    otp: json["otp"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "otp": otp,
    "message": message,
  };
}
