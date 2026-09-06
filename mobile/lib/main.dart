import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'config/routes.dart';
import 'config/theme.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/home/home_screen.dart';
import 'services/api_service.dart';
import 'services/auth_service.dart';
import 'services/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<StorageService>(
          create: (_) => StorageService(),
        ),
        ProxyProvider<StorageService, ApiService>(
          update: (_, storage, _) => ApiService(storage),
          dispose: (_, api) => api.dispose(),
        ),
        ChangeNotifierProxyProvider2<ApiService, StorageService, AuthService>(
          create: (context) => AuthService(
            context.read<ApiService>(),
            context.read<StorageService>(),
          ),
          update: (_, api, storage, auth) {
            if (auth != null) return auth;
            return AuthService(api, storage);
          },
        ),
      ],
      child: Consumer<AuthService>(
        builder: (context, auth, _) {
          return MaterialApp(
            title: 'SI2 Auth App',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.darkTheme,
            home: const AuthWrapper(),
            routes: {
              AppRoutes.login: (context) => const LoginScreen(),
              AppRoutes.register: (context) => const RegisterScreen(),
              AppRoutes.home: (context) => const HomeScreen(),
            },
          );
        },
      ),
    );
  }
}

/// Widget envoltorio para determinar la pantalla inicial según estado de auth
class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<AuthService>().initialize();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthService>(
      builder: (context, auth, _) {
        if (auth.isLoading && !auth.isAuthenticated) {
          return Scaffold(
            body: Container(
              decoration: const BoxDecoration(gradient: AppTheme.backgroundGradient),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: AppTheme.primaryColor),
                    SizedBox(height: 20),
                    Text(
                      'Cargando...',
                      style: TextStyle(color: AppTheme.textSecondary),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        if (auth.isAuthenticated) {
          return const HomeScreen();
        }

        return const LoginScreen();
      },
    );
  }
}
