import 'package:flutter/material.dart';
import 'package:code_text_field/code_text_field.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';
import 'package:highlight/languages/python.dart';
import 'package:highlight/languages/javascript.dart';
import 'package:highlight/languages/java.dart';
import 'package:highlight/languages/cpp.dart';

import 'package:highlight/highlight.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CompilerScreen extends StatefulWidget {
  const CompilerScreen({Key? key}) : super(key: key);

  @override
  State<CompilerScreen> createState() => _CompilerScreenState();
}

class _CompilerScreenState extends State<CompilerScreen> {
  String selectedLanguage = 'Python';
  late CodeController _codeController;
  String output = '';

  final Map<String, Mode> languageModes = {
    'Python': python,
    'JavaScript': javascript,
    'Java': java,
    'C++': cpp,
  };

  final Map<String, String> defaultCode = {
    'Python': 'print("Hello, World!")',
    'JavaScript': 'console.log("Hello, World!");',
    'Java': 'public class Main {\n  public static void main(String[] args) {\n    System.out.println("Hello, World!");\n  }\n}',
    'C++': '#include <iostream>\nint main() {\n  std::cout << "Hello, World!";\n  return 0;\n}',
  };

  // Map language names to Piston API language identifiers
  final Map<String, String> pistonLanguages = {
    'Python': 'python3',
    'JavaScript': 'javascript',
    'Java': 'java',
    'C++': 'cpp',
  };

  // Map language identifiers to supported version strings
  final Map<String, String> pistonVersions = {
    'python3': '3.10.0',
    'javascript': '18.15.0',
    'java': '15.0.2',
    'cpp': '10.2.0',
  };

  @override
  void initState() {
    super.initState();
    _codeController = CodeController(
      text: defaultCode[selectedLanguage]!,
      language: languageModes[selectedLanguage],
    );
  }

  void _onLanguageChanged(String? lang) {
    if (lang != null && lang != selectedLanguage) {
      setState(() {
        selectedLanguage = lang;
        _codeController.language = languageModes[lang];
        _codeController.text = defaultCode[lang]!;
      });
    }
  }

  Future<void> _runCode() async {
    setState(() {
      output = 'Running...';
    });

    final code = _codeController.text;
    final language = pistonLanguages[selectedLanguage] ?? 'python3';
    final version = pistonVersions[language] ?? '3.10.0';

    try {
      final response = await http.post(
        Uri.parse('https://emkc.org/api/v2/piston/execute'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'language': language,
          'version': version,
          'files': [
            {
              'name': 'main.${language == "python3" ? "py" : language == "javascript" ? "js" : language == "java" ? "java" : "cpp"}',
              'content': code,
            }
          ],
        }),
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        final runResult = result['run'];
        final stdout = runResult?['stdout'] ?? '';
        final stderr = runResult?['stderr'] ?? '';
        setState(() {
          if ((stdout as String).trim().isNotEmpty) {
            output = stdout;
          } else if ((stderr as String).trim().isNotEmpty) {
            output = 'Error:\n$stderr';
          } else {
            output = 'No output';
          }
        });
      } else {
        setState(() {
          output = 'Error: ${response.statusCode}\n${response.body}';
        });
      }
    } catch (e) {
      setState(() {
        output = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Compiler')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButton<String>(
              value: selectedLanguage,
              items: languageModes.keys.map((lang) {
                return DropdownMenuItem(
                  value: lang,
                  child: Text(lang),
                );
              }).toList(),
              onChanged: _onLanguageChanged,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: CodeField(
                  controller: _codeController,
                  textStyle: const TextStyle(fontFamily: 'SourceCode'),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _runCode,
              child: const Text('Run'),
            ),
            const SizedBox(height: 16),
            Text('Output:', style: TextStyle(fontWeight: FontWeight.bold)),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              color: Colors.grey[200],
              child: Text(output),
            ),
          ],
        ),
      ),
    );
  }
}