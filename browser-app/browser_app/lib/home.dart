import 'package:browser_app/provider/all_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'mywebview.dart';

class BrowserHome extends ConsumerStatefulWidget {
  const BrowserHome({super.key});

  @override
  ConsumerState<BrowserHome> createState() => _BrowserHomeState();
}

class _BrowserHomeState extends ConsumerState<BrowserHome> {
  final TextEditingController _searchController = TextEditingController();

  void _search() {
    String query = _searchController.text.trim();
    if (ref.read(searchProvider.notifier).isUrl()) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MyWebView(url: query),
        ),
      );
    } else {
      String searchUrl = 'https://www.google.com/search?q=$query';
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MyWebView(url: searchUrl),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final searchQuery = ref.watch(searchProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Browser"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            const SizedBox(height: 20),
            TextFormField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Enter URL or search',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    ref
                        .read(searchProvider.notifier)
                        .updateQuery(_searchController.text);
                    _search();
                  },
                ),
              ),
              onChanged: (value) {
                ref.read(searchProvider.notifier).updateQuery(value);
              },
            ),
            const SizedBox(height: 30),
            InkWell(
              onTap: () {
                ref
                    .read(searchProvider.notifier)
                    .updateQuery(_searchController.text);
                _search();
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 40),
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  "Search",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose(); // Dispose of the controller when done
    super.dispose();
  }
}
