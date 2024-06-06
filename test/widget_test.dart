import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:real_time_chat/main.dart';
import 'package:real_time_chat/websocket_service.dart';
import 'package:real_time_chat/auth_service.dart';

class MockWebSocketService extends Mock implements WebSocketService {}

class MockAuthService extends Mock implements AuthService {
  @override
  Future<String> getCurrentUser() async {
    return 'testUser';
  }

  @override
  Future<String> authenticate(String username, String password) async {
    if (username == 'testUser' && password == 'password') {
      return 'testUser';
    } else {
      throw Exception('Invalid credentials');
    }
  }

  @override
  Future<String> register(String username, String password) async {
    return 'testUser';
  }
}

void main() {
  testWidgets('MyApp starts at the login screen', (WidgetTester tester) async {
    final mockWebSocketService = MockWebSocketService();
    final mockAuthService = MockAuthService();

    await tester.pumpWidget(MyApp(
      webSocketService: mockWebSocketService,
      authService: mockAuthService,
    ));

    expect(find.text('Login'), findsOneWidget);
  });

  testWidgets('Send a message', (WidgetTester tester) async {
    final mockWebSocketService = MockWebSocketService();
    final mockAuthService = MockAuthService();

    await tester.pumpWidget(MyApp(
      webSocketService: mockWebSocketService,
      authService: mockAuthService,
    ));

    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle();

    expect(find.text('Enter message'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'Hello World');
    await tester.tap(find.byIcon(Icons.send));
    await tester.pump();

    expect(find.text('Hello World'), findsOneWidget);
  });
}
