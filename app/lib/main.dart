import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/common/routes/routes.dart';
import 'package:whatsapp_clone/common/utils/coloors.dart';
import 'package:whatsapp_clone/feature/auth/controller/auth_controller.dart';
import 'package:whatsapp_clone/feature/home/pages/home_page.dart';
import 'package:whatsapp_clone/feature/welcome/pages/welcome_page.dart';

import 'common/theme/dark_theme.dart';
import 'common/theme/light_theme.dart';
import 'firebase_options.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'WhatsApp Clone',
      theme: lightTheme(),
      darkTheme: darkTheme(),
      themeMode: ThemeMode.system,
      home: ref.watch(userInfoAuthProvider).when(
        data: (user) {
          return user == null ? const WelcomePage() : const HomePage();
        },
        error: (error, trace) {
          return const Scaffold(
            body: Center(
              child: Text('Something went wrong'),
            ),
          );
        },
        loading: () {
          return const Scaffold(
            body: Center(
              child: SizedBox(
                width: 30,
                height: 30,
                child: CircularProgressIndicator(
                  color: Coloors.greyDark,
                ),
              ),
            ),
          );
        },
      ),
      onGenerateRoute: Routes.onGenerateRoute,
    );
  }
}
