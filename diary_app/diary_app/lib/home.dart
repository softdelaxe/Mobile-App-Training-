import 'package:diary_app/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'model/diary_entry.dart';
//TODo add sharedPreference

class DiaryHomePage extends ConsumerWidget {
  final _diaryEntryController = TextEditingController();

  DiaryHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final diaryEntries = ref.watch(diaryProvider);

    // Initialize Banner Ad
    final BannerAd bannerAd = BannerAd(
      adUnitId:
          'ca-app-pub-3940256099942544/6300978111', // Replace with your actual Ad Unit ID
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) => print('Ad loaded successfully'),
        onAdFailedToLoad: (ad, error) {
          print('Ad failed to load: $error');
          ad.dispose();
        },
      ),
    )..load();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Diary App',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.purpleAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: diaryEntries.length,
                      itemBuilder: (context, index) {
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            title: Text(
                              diaryEntries[index].title,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(diaryEntries[index].content),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _diaryEntryController,
                    decoration: InputDecoration(
                      hintText: 'Write your diary entry...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade400),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 16),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            final diaryEntry = DiaryEntry(
                              id: DateTime.now()
                                  .millisecondsSinceEpoch
                                  .toString(),
                              title: DateFormat.yMd().format(DateTime.now()),
                              content: _diaryEntryController.text,
                              createdAt: DateTime.now(),
                            );
                            ref
                                .read(diaryProvider.notifier)
                                .addDiaryEntry(diaryEntry);
                            _diaryEntryController.clear();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            elevation: 5,
                          ),
                          child: const Text('Add Entry',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            final notifier = ref.read(diaryProvider.notifier);
                            notifier.state = [];
                            final prefs = await SharedPreferences.getInstance();
                            await prefs.remove('diaryEntries');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            elevation: 5,
                          ),
                          child: const Text('Clear All',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Banner Ad Widget
          SizedBox(
            height: 50, // Banner height
            child: AdWidget(ad: bannerAd),
          ),
        ],
      ),
    );
  }
}

// class DiaryHomePage extends ConsumerWidget {
//   final _diaryEntryController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final diaryEntries = ref.watch(diaryProvider);
//     final BannerAd bannerAd = BannerAd(
//       adUnitId: 'ca-app-pub-3940256099942544/6300978111', // Replace with your actual Ad Unit ID
//       size: AdSize.banner,
//       request: AdRequest(),
//       listener: BannerAdListener(
//         onAdLoaded: (_) => print('Ad loaded successfully'),
//         onAdFailedToLoad: (ad, error) {
//           print('Ad failed to load: $error');
//           ad.dispose();
//         },
//       ),
//     )..load();
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Diary App', style: TextStyle(fontWeight: FontWeight.bold)),
//         centerTitle: true,
//         flexibleSpace: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [Colors.blueAccent, Colors.purpleAccent],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//           ),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             Expanded(
//               child: ListView.builder(
//                 itemCount: diaryEntries.length,
//                 itemBuilder: (context, index) {
//                   return Card(
//                     margin: const EdgeInsets.symmetric(vertical: 8.0),
//                     elevation: 4,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: ListTile(
//                       title: Text(
//                         diaryEntries[index].title,
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                       subtitle: Text(diaryEntries[index].content),
//                     ),
//                   );
//                 },
//               ),
//             ),
//             SizedBox(height: 10),
//             TextField(
//               controller: _diaryEntryController,
//               decoration: InputDecoration(
//                 hintText: 'Write your diary entry...',
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: BorderSide(color: Colors.grey.shade400),
//                 ),
//                 filled: true,
//                 fillColor: Colors.grey.shade100,
//                 contentPadding:
//                 EdgeInsets.symmetric(vertical: 10, horizontal: 16),
//               ),
//             ),
//             SizedBox(height: 10),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Expanded(
//                   child: ElevatedButton(
//                     onPressed: () {
//                       final diaryEntry = DiaryEntry(
//                         id: DateTime.now().millisecondsSinceEpoch.toString(),
//                         title: DateFormat.yMd().format(DateTime.now()),
//                         content: _diaryEntryController.text,
//                         createdAt: DateTime.now(),
//                       );
//                       ref.read(diaryProvider.notifier).addDiaryEntry(diaryEntry);
//                       _diaryEntryController.clear();
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.blueAccent,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       padding: EdgeInsets.symmetric(vertical: 16),
//                       elevation: 5, // Add shadow for elevation
//                     ),
//                     child: Text('Add Entry',
//                         style:
//                         TextStyle(fontSize: 16, fontWeight: FontWeight.bold,
//                         color: Colors.white)),
//                   ),
//                 ),
//                 const SizedBox(width: 10), // Space between buttons
//                 Expanded(
//                   child: ElevatedButton(
//                     onPressed: () async {
//                       final notifier = ref.read(diaryProvider.notifier);
//                       notifier.state = [];
//                       final prefs = await SharedPreferences.getInstance();
//                       await prefs.remove('diaryEntries');
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.blueAccent,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       padding: EdgeInsets.symmetric(vertical: 16),
//                       elevation: 5, // Add shadow for elevation
//                     ),
//                     child: Text('Clear All',
//                         style:
//                         TextStyle(fontSize: 16, fontWeight: FontWeight.bold,
//                         color: Colors.white)),
//                   ),
//                 ),
//                 // Banner Ad Widget
//                 Container(
//                   height: 50, // Banner height
//                   child: AdWidget(ad: bannerAd),
//                 ),
//               ],
//
//             ),
//           ],
//         ),
//
//         ),
//     );
//   }
// }
