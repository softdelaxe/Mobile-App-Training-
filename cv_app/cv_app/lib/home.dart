
import 'dart:io';

import 'package:cv_app/provider.dart';
import 'package:cv_app/section.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';


// Display Page
import 'package:flutter/material.dart';

import 'edit_page.dart';

class CVDisplayPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cvData = ref.watch(cvProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("My CV"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Section
                  Center(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundImage: (cvData.profileImage != null)
                              ? (kIsWeb
                              ? NetworkImage(cvData.profileImage!.path) as ImageProvider
                              : FileImage(cvData.profileImage!))
                              : const AssetImage('assets/profile.jpg'),
                        )

                        ,
                        const SizedBox(height: 16),
                        Text(
                          cvData.name.isNotEmpty ? cvData.name : "John Doe",
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          cvData.jobTitle.isNotEmpty
                              ? cvData.jobTitle
                              : "Flutter Developer",
                          style: TextStyle(
                              fontSize: 18, color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Contact Information Card
                  SectionTitle(title: "Contact Information"),
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          leading:
                          const Icon(Icons.phone, color: Colors.blueAccent),
                          title: Text(cvData.phone.isNotEmpty
                              ? cvData.phone
                              : "+123 456 7890"),
                        ),
                        const Divider(),
                        ListTile(
                          leading:
                          const Icon(Icons.email, color: Colors.blueAccent),
                          title: Text(cvData.email.isNotEmpty
                              ? cvData.email
                              : "johndoe@example.com"),
                        ),
                        const Divider(),
                        ListTile(
                          leading: const Icon(Icons.location_on,
                              color: Colors.blueAccent),
                          title: Text(cvData.address.isNotEmpty
                              ? cvData.address
                              : "123 Main Street, City, Country"),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Skills Section
                  SectionTitle(title: "Skills"),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: (cvData.skills.isNotEmpty
                        ? cvData.skills
                        : ["Flutter", "Dart", "Firebase", "REST APIs", "Git"])
                        .map((skill) => Chip(label: Text(skill)))
                        .toList(),
                  ),
                  const SizedBox(height: 20),

                  // Experience Section
                  SectionTitle(title: "Experience"),
                  ...(cvData.experiences.isNotEmpty
                      ? cvData.experiences
                      : [
                    {
                      "title": "Flutter Developer",
                      "company": "Tech Solutions Ltd",
                      "duration": "2020 - Present",
                      "description":
                      "Developed mobile applications using Flutter and integrated Firebase for backend services."
                    },
                    {
                      "title": "Software Engineer",
                      "company": "Code Factory Inc",
                      "duration": "2018 - 2020",
                      "description":
                      "Worked on building scalable software solutions and contributed to multiple projects."
                    }
                  ])
                      .map((experience) {
                    return Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      margin: const EdgeInsets.only(bottom: 10),
                      child: ListTile(
                        title: Text(experience['title']!),
                        subtitle: Text(
                            "${experience['company']} • ${experience['duration']}"),
                      ),
                    );
                  }).toList(),
                  const SizedBox(height: 20),

                  // Navigate to Editing Page
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => EditableCVPage(),
                          ),
                        );
                      },
                      child: const Text("Edit CV"),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

//
// class CVDisplayPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("My CV"),
//         centerTitle: true,
//         backgroundColor: Colors.blueAccent,
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Card(
//             elevation: 5,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Padding(
//               padding: const EdgeInsets.all(20.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Profile Section
//                   Center(
//                     child: Column(
//                       children: [
//                         CircleAvatar(
//                           radius: 60,
//                           backgroundImage: AssetImage('assets/profile.jpg'),
//                         ),
//                         const SizedBox(height: 16),
//                         Text(
//                           "John Doe",
//                           style: TextStyle(
//                               fontSize: 24, fontWeight: FontWeight.bold),
//                         ),
//                         const SizedBox(height: 8),
//                         Text(
//                           "Flutter Developer",
//                           style:
//                           TextStyle(fontSize: 18, color: Colors.grey.shade600),
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//
//                   // Contact Information Card
//                   SectionTitle(title: "Contact Information"),
//                   Card(
//                     elevation: 2,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: Column(
//                       children: [
//                         ListTile(
//                           leading:
//                           Icon(Icons.phone, color: Colors.blueAccent),
//                           title: Text("+123 456 7890"),
//                         ),
//                         Divider(),
//                         ListTile(
//                           leading:
//                           Icon(Icons.email, color: Colors.blueAccent),
//                           title: Text("johndoe@example.com"),
//                         ),
//                         Divider(),
//                         ListTile(
//                           leading:
//                           Icon(Icons.location_on, color: Colors.blueAccent),
//                           title:
//                           Text("123 Main Street, City, Country"),
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//
//                   // Skills Section
//                   SectionTitle(title: "Skills"),
//                   Wrap(
//                     spacing: 10,
//                     runSpacing: 10,
//                     children:
//                     ["Flutter", "Dart", "Firebase", "REST APIs", "Git"]
//                         .map((skill) => Chip(label: Text(skill)))
//                         .toList(),
//                   ),
//                   const SizedBox(height: 20),
//
//                   // Experience Section
//                   SectionTitle(title: "Experience"),
//                   ...[
//                     {
//                       "title": "Flutter Developer",
//                       "company": "Tech Solutions Ltd",
//                       "duration": "2020 - Present",
//                       "description":
//                       "Developed mobile applications using Flutter and integrated Firebase for backend services."
//                     },
//                     {
//                       "title": "Software Engineer",
//                       "company": "Code Factory Inc",
//                       "duration": "2018 - 2020",
//                       "description":
//                       "Worked on building scalable software solutions and contributed to multiple projects."
//                     }
//                   ].map((experience) {
//                     return Card(
//                       elevation: 2,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       margin: const EdgeInsets.only(bottom: 10),
//                       child: ListTile(
//                         title: Text(experience['title']!),
//                         subtitle:
//                         Text("${experience['company']} • ${experience['duration']}"),
//                       ),
//                     );
//                   }).toList(),
//                   const SizedBox(height: 20),
//
//                   // Navigate to Editing Page
//                   Center(
//                     child: ElevatedButton(
//                       onPressed: () {
//                         Navigator.of(context).push(
//                           MaterialPageRoute(
//                             builder: (context) => EditableCVPage(),
//                           ),
//                         );
//                       },
//                       child: Text("Edit CV"),
//                       style:
//                       ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// // Section Title Widget
// class SectionTitle extends StatelessWidget {
//   final String title;
//
//   const SectionTitle({required this.title});
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding:
//       const EdgeInsets.symmetric(vertical: 8.0),
//       child:
//       Text(title,
//           style:
//           TextStyle(fontSize:
//           22, fontWeight:
//           FontWeight.bold, color:
//           Colors.blue)),
//     );
//   }
// }

// // Section Title Widget
// class SectionTitle extends StatelessWidget {
//   final String title;
//
//   const SectionTitle({required this.title});
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding:
//       const EdgeInsets.only(top:
//       8.0,left: 20,right: 20,bottom: 8),
//       child:
//       Text(title,
//           style:
//           TextStyle(fontSize:
//           22, fontWeight:
//           FontWeight.bold, color:
//           Colors.blue)),
//     );
//   }
// }
