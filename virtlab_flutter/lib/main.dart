import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/splash_screen.dart';
import 'state/app_state.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Requiere que google-services.json esté en android/app/ (ver
  // README del proyecto) y, para iOS, GoogleService-Info.plist.
  await Firebase.initializeApp();
  runApp(const VirtLabApp());
}

class VirtLabApp extends StatelessWidget {
  const VirtLabApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppState(),
      child: MaterialApp(
        title: 'VirtLab',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        // Splash decide, según SharedPreferences, si va a Bienvenida
        // (sin sesión) o directo al Menú (con sesión activa) — así
        // nunca se vuelve a mostrar Registro/Login/Personalización
        // salvo que el usuario cierre sesión, desinstale o borre datos.
        home: const SplashScreen(),
      ),
    );
  }
}
