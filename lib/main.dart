import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:aplicativo_01/src/home.dart';
import 'package:aplicativo_01/src/services/app_state.dart';
import 'package:aplicativo_01/src/services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Cargar variables de entorno
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    // Fallback si no existe el archivo .env
    print('No se pudo cargar .env: $e');
  }

  // Inicializar servicios
  // StorageService y LoggerService no requieren inicialización explícita
  await AuthService.instance.initialize();
  await AppState.instance.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rock Star Data',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const LoginPage(),
    );
  }
}
