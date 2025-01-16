import 'dart:io';

import 'package:riverpod/riverpod.dart';

import '../model/cv_model.dart';

class CVNotifier extends StateNotifier<CVModel> {
  CVNotifier()
      : super(
          CVModel(
            name: "Engr Peter",
            jobTitle: "Flutter Developer/ Facilitator",
            phone: "+123 456 7890",
            email: "peter@gmail.com",
            address: " Tech-solutions",
            profileImage: null,
            skills: ["Flutter", "Dart", "Firebase", "REST APIs", "Git"],
            experiences: [
              {
                "title": "Flutter Developer",
                "company": "Tech Solutions Ltd",
                "duration": "2020 - Present",
                "description": "Developed mobile applications using Flutter."
              },
              {
                "title": "Software Engineer",
                "company": "Code Factory Inc",
                "duration": "2018 - 2020",
                "description": "Built scalable software solutions."
              },
            ],
          ),
        );

  void updateName(String name) => state = state.copyWith(name: name);
  void updateTitle(String title) => state = state.copyWith(jobTitle: title);
  void updatePhone(String phone) => state = state.copyWith(phone: phone);
  void updateEmail(String email) => state = state.copyWith(email: email);
  void updateAddress(String address) =>
      state = state.copyWith(address: address);
  void updateProfileImage(File? image) =>
      state = state.copyWith(profileImage: image);
  void addSkill(String skill) =>
      state = state.copyWith(skills: [...state.skills, skill]);
  void removeSkill(String skill) => state =
      state.copyWith(skills: state.skills.where((s) => s != skill).toList());
  void addExperience(Map<String, String> experience) =>
      state = state.copyWith(experiences: [...state.experiences, experience]);
  void removeExperience(Map<String, String> experience) =>
      state = state.copyWith(
          experiences:
              state.experiences.where((e) => e != experience).toList());
  // void addExperience(Map<String, String> experience) {
  //   state = state.copyWith(
  //     experiences: [...state.experiences, experience],
  //   );
  // }
  //
  // void removeExperience(Map<String, String> experience) {
  //   state = state.copyWith(
  //     experiences: [...state.experiences]..remove(experience),
  //   );
  // }
// }
}
