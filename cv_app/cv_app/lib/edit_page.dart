
import 'dart:io';
import 'package:cv_app/provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


import 'dart:io'; // Import File
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Import ImagePicker
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Assuming you're using Riverpod
class EditableCVPage extends ConsumerStatefulWidget {
  EditableCVPage({Key? key}) : super(key: key);

  @override
  ConsumerState<EditableCVPage> createState() => _EditableCVPageState();
}

class _EditableCVPageState extends ConsumerState<EditableCVPage> {
  final ImagePicker _picker = ImagePicker();
  String? profileImagePath;


  // TextEditingControllers for each field
  late TextEditingController nameController;
  late TextEditingController titleController;
  late TextEditingController phoneController;
  late TextEditingController emailController;
  late TextEditingController addressController;
  late TextEditingController skillController;
  // Controllers for experience input
  late TextEditingController experienceTitleController;
  late TextEditingController experienceCompanyController;
  late TextEditingController experienceDurationController;
  late TextEditingController experienceDescriptionController;

  @override
  void initState() {
    super.initState();
    final cv = ref.read(cvProvider);

    // Initialize controllers with existing values
    nameController = TextEditingController(text: cv.name);
    titleController = TextEditingController(text: cv.jobTitle);
    phoneController = TextEditingController(text: cv.phone);
    emailController = TextEditingController(text: cv.email);
    addressController = TextEditingController(text: cv.address);
    skillController = TextEditingController();
    // Initialize controllers for new experience input
    experienceTitleController = TextEditingController();
    experienceCompanyController = TextEditingController();
    experienceDurationController = TextEditingController();
    experienceDescriptionController = TextEditingController();
  }

  @override
  void dispose() {
    // Dispose controllers to free resources
    nameController.dispose();
    titleController.dispose();
    phoneController.dispose();
    emailController.dispose();
    addressController.dispose();
    skillController.dispose();
    // Dispose of experience controllers
    experienceTitleController.dispose();
    experienceCompanyController.dispose();
    experienceDurationController.dispose();
    experienceDescriptionController.dispose();
    super.dispose();

  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        profileImagePath = pickedFile.path;
      });
      ref.read(cvProvider.notifier).updateProfileImage(File(pickedFile.path));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile image updated!')),
      );
    } else {
      print('No image selected');
    }
  }

  @override
  Widget build(BuildContext context) {
    final cv = ref.watch(cvProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit CV"),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: _buildProfileImage(),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Name and Title
                  _buildTextField(
                    label: "Full Name",
                    controller: nameController,
                    onChanged: (value) => ref.read(cvProvider.notifier).updateName(value),
                  ),
                  const SizedBox(height: 10),
                  _buildTextField(
                    label: "Professional Title",
                    controller: titleController,
                    onChanged: (value) => ref.read(cvProvider.notifier).updateTitle(value),
                  ),
                  const SizedBox(height: 20),

                  // Contact Information
                  const Text(
                      "Contact Information", style: TextStyle(fontSize: 18)),
                  const SizedBox(height: 10),
                  _buildTextField(
                    label: "Phone",
                    controller: phoneController,
                    onChanged: (value) => ref.read(cvProvider.notifier).updatePhone(value),
                  ),
                  const SizedBox(height: 10),
                  _buildTextField(
                    label: "Email",
                    controller: emailController,
                    onChanged: (value) => ref.read(cvProvider.notifier).updateEmail(value),
                  ),
                  const SizedBox(height: 10),
                  _buildTextField(
                    label: "Address",
                    controller: addressController,
                    onChanged: (value) => ref.read(cvProvider.notifier).updateAddress(value),
                  ),
                  const SizedBox(height: 20),

                  // Skills Section
                  const Text("Skills", style: TextStyle(fontSize: 18)),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: cv.skills.map((skill) {
                      return Chip(
                        label: Text(skill),
                        onDeleted: () =>
                            ref.read(cvProvider.notifier).removeSkill(skill),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),

                  _buildTextFieldForSubmit(
                    label: "Add Skill",
                    value: '',
                    onChanged: (String value) {},
                    onSubmitted: (value) {
                      if (value.isNotEmpty) {
                        ref.read(cvProvider.notifier).addSkill(value);
                      }
                    },
                  ),

                  const SizedBox(height: 20),
                  const Text("Add Experience", style :TextStyle(fontSize :18)),

                  _buildTextField(label:"Job Title", controller :experienceTitleController, onChanged:(value) {}),
                  const SizedBox(height: 10),

                  _buildTextField(label:"Company", controller :experienceCompanyController, onChanged:(value) {}),
                  const SizedBox(height: 10),

                  _buildTextField(label:"Duration", controller :experienceDurationController, onChanged:(value) {}),
                  const SizedBox(height: 10),

                  _buildTextField(label:"Description", controller :experienceDescriptionController, onChanged:(value) {}),
                  const SizedBox(height: 10),

                  ElevatedButton(
                    onPressed : () {
                      if (experienceTitleController.text.isNotEmpty &&
                          experienceCompanyController.text.isNotEmpty &&
                          experienceDurationController.text.isNotEmpty &&
                          experienceDescriptionController.text.isNotEmpty) {

                        ref.read(cvProvider.notifier).addExperience({
                          "title": experienceTitleController.text,
                          "company": experienceCompanyController.text,
                          "duration": experienceDurationController.text,
                          "description": experienceDescriptionController.text,
                        });

                        // Clear the input fields after adding
                        experienceTitleController.clear();
                        experienceCompanyController.clear();
                        experienceDurationController.clear();
                        experienceDescriptionController.clear();

                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content:
                          Text("Please fill all fields")),
                        );
                      }
                    },
                    child : const Text("Add Experience"),
                  ),
                  const SizedBox(height: 20),

                  // Experiences Section
                  const Text("Experiences", style: TextStyle(fontSize: 18)),
                  ...cv.experiences.map((experience) {
                    return ListTile(
                      title: Text(experience['title'] ?? 'No Title'),
                      subtitle:
                      Text("${experience['company'] ??
                          'Unknown Company'} • ${experience['duration'] ??
                          'Unknown Duration'}"),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () =>
                            ref.read(cvProvider.notifier).removeExperience(
                                experience),
                      ),
                    );
                  }),

                  // ElevatedButton(
                  //   onPressed: () {
                  //     ref.read(cvProvider.notifier).addExperience({
                  //       "title": "New Experience",
                  //       "company": "Company Name",
                  //       "duration": "Year - Year",
                  //       "description": "Description here.",
                  //     });
                  //   },
                  //   child: const Text("Add Experience"),
                  // ),

                  const SizedBox(height: 20),

                  // Save Button
                  ElevatedButton(
                    onPressed: () {
                      // Save CV Logic
                      Navigator.pop(context);
                    },
                    style:
                    ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50)),
                    child: const Text("Save Changes"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


  // Widget _buildProfileImage() {
  //   // Implement your logic to display profile image here
  //   return CircleAvatar(
  //     radius: 50,
  //     backgroundImage:
  //     profileImagePath != null ? FileImage(File(profileImagePath!)) : null,
  //     child:
  //     profileImagePath == null ? const Icon(Icons.person, size: 50) : null,
  //   );
  // }
  Widget _buildTextFieldForSubmit({
    required String label,
    required String value,
    required ValueChanged<String> onChanged,
    required ValueChanged<String> onSubmitted, // Separate onSubmitted handler
  }) {
    final controller = TextEditingController(text: value);

    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.blueAccent),
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey, width: 1.5),
          borderRadius: BorderRadius.circular(10),
        ),
        filled: true,
        fillColor: Colors.grey[100],
      ),
      style: TextStyle(fontSize: 16, color: Colors.grey[800]),
      textAlign: TextAlign.start,
      onChanged: onChanged,
      onSubmitted: onSubmitted, // Handle onSubmitted here
    );
  }
  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required ValueChanged<String> onChanged,
    ValueChanged<String>? onSubmitted,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.blueAccent),
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey, width: 1.5),
          borderRadius: BorderRadius.circular(10),
        ),
        filled: true,
        fillColor: Colors.grey[100],
      ),
      style: TextStyle(fontSize: 16, color: Colors.grey[800]),
      textAlign: TextAlign.start,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
    );
  }

  Widget _buildProfileImage() {
    if (profileImagePath != null) {
      try {
        return CircleAvatar(
          radius: 60,
          backgroundImage: kIsWeb
              ? NetworkImage(profileImagePath!) as ImageProvider
              : FileImage(File(profileImagePath!)),
        );
      } catch (e) {
        print('Error loading image: $e');
        // Fallback in case of error
        return CircleAvatar(
          radius: 60,
          backgroundImage: const AssetImage('assets/profile.jpg'),
        );
      }
    }
    // Default profile image
    return CircleAvatar(
      radius: 60,
      backgroundImage: const AssetImage('assets/profile.jpg'),
      child: const Icon(Icons.person, size: 50),
    );
  }
}