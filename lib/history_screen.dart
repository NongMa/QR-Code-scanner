import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<String> _history = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _history = prefs.getStringList('scan_history')?.reversed.toList() ?? [];
    });
  }

  Future<void> _clearHistory() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('scan_history');
    _loadHistory();
  }

  bool _isUrl(String text) {
    final uri = Uri.tryParse(text);
    return uri != null && uri.isAbsolute;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan History'),
        actions: [
          IconButton(icon: const Icon(Icons.delete), onPressed: _clearHistory),
        ],
      ),
      body: _history.isEmpty
          ? const Center(child: Text('No history found.'))
          : ListView.builder(
              itemCount: _history.length,
              itemBuilder: (context, index) {
                final item = _history[index];
                final bool isUrl = _isUrl(item);
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item, style: const TextStyle(fontSize: 16)),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (isUrl)
                              TextButton.icon(
                                icon: const Icon(Icons.open_in_browser, size: 20),
                                label: const Text('Open'),
                                onPressed: () async {
                                  final uri = Uri.parse(item);
                                  if (await canLaunchUrl(uri)) {
                                    await launchUrl(uri);
                                  }
                                },
                              ),
                            TextButton.icon(
                              icon: const Icon(Icons.copy, size: 20),
                              label: const Text('Copy'),
                              onPressed: () {
                                Clipboard.setData(ClipboardData(text: item));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Copied to clipboard')),
                                );
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
