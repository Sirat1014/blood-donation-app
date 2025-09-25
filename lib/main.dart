import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screen/auth/login_screen.dart';
import 'screen/home/home_screen.dart';
import 'services/auth_service.dart';
import 'package:provider/provider.dart';
import 'services/notification_service.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await NotificationService.init();// Initialize Firebase
  runApp(const BloodBridgeApp());
}

class BloodBridgeApp extends StatelessWidget {
  const BloodBridgeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthService>(create: (_) => AuthService()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.red,
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(color: Colors.grey[400]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(color: Colors.grey[400]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(color: Theme
                  .of(context)
                  .colorScheme
                  .primary, width: 2.0),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(color: Theme
                  .of(context)
                  .colorScheme
                  .error, width: 1.5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(color: Theme
                  .of(context)
                  .colorScheme
                  .error, width: 2.0),
            ),
            floatingLabelStyle: TextStyle(color: Theme
                .of(context)
                .colorScheme
                .primary),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              padding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 24.0),
              textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          colorScheme: ColorScheme
              .fromSeed(seedColor: Colors.redAccent)
              .copyWith(
          ),
          useMaterial3: true,
        ),
        home: AuthWrapper(), // Or your app's entry point
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    if (auth.user != null) {
      return const HomeScreen();
    } else {
      return const LoginScreen();
    }
  }
}
