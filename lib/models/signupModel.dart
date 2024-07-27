// To parse this JSON data, do
//
//     final signUpModels = signUpModelsFromJson(jsonString);

import 'dart:convert';

SignUpModels signUpModelsFromJson(String str) => SignUpModels.fromJson(json.decode(str));

String signUpModelsToJson(SignUpModels data) => json.encode(data.toJson());

class SignUpModels {
  String? status;
  String? message;
  Data? data;

  SignUpModels({
     this.status,
    this.message,
     this.data,
  });

  factory SignUpModels.fromJson(Map<String, dynamic> json) => SignUpModels(
    status: json["status"],
    message: json['message'],
    data : json["data"] != null ? Data.fromJson(json["data"]) : null,
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message" : message,
    "data": data!.toJson(),
  };
}

class Data {
  int usersCustomersId;
  String oneSignalId;
  String usersCustomersType;
  String firstName;
  String lastName;
  dynamic phone;
  String email;
  String password;
  dynamic profilePic;
  dynamic proofDocument;
  dynamic validDocument;
  String messages;
  String notifications;
  String accountType;
  String socialAccType;
  String googleAccessToken;
  dynamic verifyCode;
  String verifiedBadge;
  dynamic dateExpiry;
  DateTime dateAdded;
  String status;

  Data({
    required this.usersCustomersId,
    required this.oneSignalId,
    required this.usersCustomersType,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.email,
    required this.password,
    required this.profilePic,
    required this.proofDocument,
    required this.validDocument,
    required this.messages,
    required this.notifications,
    required this.accountType,
    required this.socialAccType,
    required this.googleAccessToken,
    required this.verifyCode,
    required this.verifiedBadge,
    required this.dateExpiry,
    required this.dateAdded,
    required this.status,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    usersCustomersId: json["users_customers_id"],
    oneSignalId: json["one_signal_id"],
    usersCustomersType: json["users_customers_type"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    phone: json["phone"],
    email: json["email"],
    password: json["password"],
    profilePic: json["profile_pic"],
    proofDocument: json["proof_document"],
    validDocument: json["valid_document"],
    messages: json["messages"],
    notifications: json["notifications"],
    accountType: json["account_type"],
    socialAccType: json["social_acc_type"],
    googleAccessToken: json["google_access_token"],
    verifyCode: json["verify_code"],
    verifiedBadge: json["verified_badge"],
    dateExpiry: json["date_expiry"],
    dateAdded: DateTime.parse(json["date_added"]),
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "users_customers_id": usersCustomersId,
    "one_signal_id": oneSignalId,
    "users_customers_type": usersCustomersType,
    "first_name": firstName,
    "last_name": lastName,
    "phone": phone,
    "email": email,
    "password": password,
    "profile_pic": profilePic,
    "proof_document": proofDocument,
    "valid_document": validDocument,
    "messages": messages,
    "notifications": notifications,
    "account_type": accountType,
    "social_acc_type": socialAccType,
    "google_access_token": googleAccessToken,
    "verify_code": verifyCode,
    "verified_badge": verifiedBadge,
    "date_expiry": dateExpiry,
    "date_added": dateAdded.toIso8601String(),
    "status": status,
  };
}
