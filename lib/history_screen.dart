import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      _history = prefs.getStringList('scan_history') ?? [];
    });
  }

  Future<void> _clearHistory() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('scan_history');
    _loadHistory();
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
                return ListTile(title: Text(_history[index]));
              },
            ),
    );
  }
}
