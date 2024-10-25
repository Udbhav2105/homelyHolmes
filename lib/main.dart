import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:homely_holmes/screens/screens.dart';

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: ".env");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Media Access Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MediaAccessPage(
        geminiApiKey: dotenv.env['GAPI'],
      ),
    );
  }
}
