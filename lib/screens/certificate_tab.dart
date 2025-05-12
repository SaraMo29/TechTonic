import 'package:flutter/material.dart';

class CertificateTab extends StatelessWidget {
  final bool isCompleted;

  CertificateTab({Key? key, required this.isCompleted}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: isCompleted
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.emoji_events, size: 80),
                const SizedBox(height: 12),
                const Text(
                  'Congratulations!\nYou’ve earned a certificate.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => print('Download certificate'),
                  child: const Text('Download Certificate'),
                )
              ],
            )
          : const Text('Complete the course to unlock your certificate.'),
    );
  }
}
