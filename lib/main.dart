import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'auth_bloc.dart';
import 'auth_service.dart';
import 'chat_bloc.dart';
import 'chat_screen.dart';
import 'login_screen.dart';
import 'signup_screen.dart';
import 'websocket_service.dart';

void main() async {
  // Initialize Hive for local storage
  await Hive.initFlutter();
  await Hive.openBox('chat');

  // Initialize services
  WebSocketService webSocketService = WebSocketService();
  AuthService authService = AuthService();

  runApp(MyApp(webSocketService: webSocketService, authService: authService));
}

class MyApp extends StatelessWidget {
  final WebSocketService webSocketService;
  final AuthService authService;

  const MyApp({Key? key, required this.webSocketService, required this.authService}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(authService: authService),
        ),
        BlocProvider<ChatBloc>(
          create: (context) => ChatBloc(webSocketService),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Real-Time Chat',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => LoginScreen(),
          '/signup': (context) => SignupScreen(),
          '/chat': (context) => ChatScreen(
                username: ModalRoute.of(context)?.settings.arguments as String? ?? 'Unknown',
                recipient: 'recipientName', // Modify as needed
              ),
        },
      ),
    );
  }
}
