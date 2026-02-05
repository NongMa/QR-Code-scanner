import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  final MobileScannerController _controller = MobileScannerController();
  bool _isTorchOn = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool _isUrl(String text) {
    final uri = Uri.tryParse(text);
    return uri != null && uri.isAbsolute;
  }

  Future<void> _onDetect(BarcodeCapture capture) async {
    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isNotEmpty) {
      await _controller.stop();

      final String code = barcodes.first.rawValue ?? 'No code found';
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final List<String> history = prefs.getStringList('scan_history') ?? [];
      history.add(code);
      await prefs.setStringList('scan_history', history);

      if (mounted) {
        final bool isUrl = _isUrl(code);
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Code Scanned'),
            content: Text(code),
            actions: [
              TextButton(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: code));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Copied to clipboard')),
                  );
                },
                child: const Text('Copy'),
              ),
              if (isUrl)
                TextButton(
                  onPressed: () async {
                    final uri = Uri.parse(code);
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri);
                    }
                  },
                  child: const Text('Go to website'),
                ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
            ],
          ),
        );
      }

      if (mounted) {
        await _controller.start();
      }
    }
  }

  void _toggleTorch() {
    _controller.toggleTorch();
    setState(() {
      _isTorchOn = !_isTorchOn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR Code'),
        actions: [
          IconButton(
            icon: Icon(
              _isTorchOn ? Icons.flash_on : Icons.flash_off,
              color: _isTorchOn ? Colors.yellow : null,
            ),
            onPressed: _toggleTorch,
          ),
        ],
      ),
      body: MobileScanner(
        controller: _controller,
        onDetect: _onDetect,
      ),
    );
  }
}
