import 'package:a8_bbyh/data/visits_repository.dart';
import 'package:a8_bbyh/firebase/firebase_options.dart';
import 'package:a8_bbyh/widgets/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const A8App());
}

class A8App extends StatelessWidget {
  const A8App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'A8_BBYH',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
          useMaterial3: true,
        ),
        home: HomePage(
            title: 'Upcoming visits',
            visitsRepo: VisitsRepository.getInstance()));
  }
}
