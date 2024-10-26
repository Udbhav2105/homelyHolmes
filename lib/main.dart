import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:homely_holmes/screens/screens.dart';

void main()  {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  // await dotenv.load(fileName: ".env");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Media Access Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MediaAccessPage(
        geminiApiKey: 'AIzaSyAdoC69uK73kJMGzIdCBFniY0nMzbgh5Zo',
      ),
    );
  }
}
