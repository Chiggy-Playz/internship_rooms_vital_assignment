import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:rooms_vital_assignment/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  
}
