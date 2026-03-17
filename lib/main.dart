import 'package:bloclogin/features/auth/data/firebase_auth_repo.dart';
import 'package:bloclogin/features/auth/presentation/components/loading.dart';
import 'package:bloclogin/features/auth/presentation/cubits/auth_cubits.dart';
import 'package:bloclogin/features/auth/presentation/cubits/auth_states.dart';
import 'package:bloclogin/features/auth/presentation/pages/auth_page.dart';
import 'package:bloclogin/features/auth/themes/dark_mode.dart';
import 'package:bloclogin/features/auth/themes/light_mode.dart';
import 'package:bloclogin/features/home/presentation/pages/home_page.dart';
import 'package:bloclogin/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  //firebase setup
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // run app
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final firebaseAuthrepo = FirebaseAuthRepo();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<AuthCubit>(
              create: (context) =>
                  AuthCubit(authRepo: firebaseAuthrepo)..checkAuth())
        ],
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: lightMode,
            darkTheme: darkMode,
            home: BlocConsumer<AuthCubit, AuthState>(builder: (context, state) {
              if (state is UnAuthenticated) {
                return const AuthPage();
              }

              if (state is Authenticated) {
                return const HomePage();
              } else {
                return const LoadingScreen();
              }
            }, listener: (context, state) {
              if (state is AuthError) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(state.message)));
              }
            })));
  }
}
