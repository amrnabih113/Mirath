import 'package:flutter/material.dart';

class OfflineBanner extends StatelessWidget {
  final String message;
  const OfflineBanner({super.key, this.message = 'You are offline'});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.orange.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            const Icon(Icons.wifi_off, color: Colors.orange),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
      ),
    );
  }
}
