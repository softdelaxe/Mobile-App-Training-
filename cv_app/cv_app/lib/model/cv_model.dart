// CV Model
import 'dart:io';
class CVModel {
  String name;
  String jobTitle; // Renamed 'title' to 'jobTitle' for clarity
  String phone;
  String email;
  String address;
  File? profileImage;
  List<String> skills;
  List<Map<String, String>> experiences;

  CVModel({
    required this.name,
    required this.jobTitle,
    required this.phone,
    required this.email,
    required this.address,
    this.profileImage,
    required this.skills,
    required this.experiences,
  });

  CVModel copyWith({
    String? name,
    String? jobTitle,
    String? phone,
    String? email,
    String? address,
    File? profileImage,
    List<String>? skills,
    List<Map<String, String>>? experiences,
  }) {
    return CVModel(
      name: name ?? this.name,
      jobTitle: jobTitle ?? this.jobTitle,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
      profileImage: profileImage ?? this.profileImage,
      skills: skills ?? this.skills,
      experiences: experiences ?? this.experiences,
    );
  }
}