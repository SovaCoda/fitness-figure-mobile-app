import 'package:ffapp/pages/home/chat.dart';
import 'package:ffapp/pages/home/subscribe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/web.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:ffapp/services/flutterUser.dart';
import 'package:ffapp/main.dart';
import 'package:ffapp/pages/home/dashboard.dart';
import 'package:ffapp/services/auth.dart';
import 'package:ffapp/services/routes.pb.dart';
import 'package:ffapp/components/robot_image_holder.dart';
import 'package:fixnum/fixnum.dart';
import 'package:mockito/annotations.dart';
import 'package:ffapp/components/legacy_charge_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:ffapp/components/utils/chat_model.dart';
import 'package:logger/logger.dart';

// if an update was made to any of these models, you can run the command below in the ffapp directory to regenerate the mocks
// dart run build_runner build
@GenerateMocks([
  AuthService,
  FlutterUser,
  AppBarAndBottomNavigationBarModel,
  CurrencyModel,
  UserModel,
  FigureModel,
  InventoryModel,
  ChatModel
])
import 'dashboard_test.mocks.dart';

Logger logger = Logger();

void main() {
  group('Dashboard Widget Tests', () {
    late MockAuthService mockAuthService;
    late MockFlutterUser mockFlutterUser;
    late MockAppBarAndBottomNavigationBarModel mockAppBarModel;
    late MockCurrencyModel mockCurrencyModel;
    late MockUserModel mockUserModel;
    late MockFigureModel mockFigureModel;
    late MockInventoryModel mockInventoryModel;
    late MockChatModel mockChatModel;

    setUp(() {
      mockAuthService = MockAuthService();
      mockFlutterUser = MockFlutterUser();
      mockAppBarModel = MockAppBarAndBottomNavigationBarModel();
      mockCurrencyModel = MockCurrencyModel();
      mockUserModel = MockUserModel();
      mockFigureModel = MockFigureModel();
      mockInventoryModel = MockInventoryModel();
      mockChatModel = MockChatModel();

      // Set up mock data
      final mockUser = User(
        weekComplete: Int64(3),
        weekGoal: Int64(5),
        workoutMinTime: Int64(30),
        streak: Int64(2),
        email: 'test@example.com',
        curFigure: 'robot1',
      );

      final mockFigure = FigureInstance(
        figureName: 'robot1',
        curSkin: '0',
        evLevel: 1,
        evPoints: 50,
        charge: 75,
      );

      when(mockCurrencyModel.currency).thenReturn('1000');
      when(mockUserModel.user).thenReturn(mockUser);
      when(mockFigureModel.figure).thenReturn(mockFigure);
      when(mockFigureModel.EVLevel).thenReturn(1);
      when(mockAppBarModel.appBarKey).thenReturn(GlobalKey());
      when(mockAppBarModel.bottomNavBarKey).thenReturn(GlobalKey());

      // Mock AuthService methods
      when(mockAuthService.getUserDBInfo())
          .thenAnswer((_) => Future.value(mockUser));
      when(mockAuthService.updateUserDBInfo(any))
          .thenAnswer((_) => Future.value(mockUser));
      when(mockAuthService.getFigureInstance(any))
          .thenAnswer((_) => Future.value(mockFigure));

      // Mock ChatModel methods
      when(mockChatModel.messages).thenReturn(<ChatMessage>[]);
    });

    Widget createWidgetUnderTest() {
      return MaterialApp(
        home: MultiProvider(
          providers: [
            Provider<AuthService>.value(value: mockAuthService),
            Provider<FlutterUser>.value(value: mockFlutterUser),
            ChangeNotifierProvider<AppBarAndBottomNavigationBarModel>.value(
                value: mockAppBarModel),
            ChangeNotifierProvider<CurrencyModel>.value(
                value: mockCurrencyModel),
            ChangeNotifierProvider<UserModel>.value(value: mockUserModel),
            ChangeNotifierProvider<FigureModel>.value(value: mockFigureModel),
            ChangeNotifierProvider<InventoryModel>.value(
                value: mockInventoryModel),
            ChangeNotifierProvider<ChatModel>.value(value: mockChatModel),
          ],
          child: const Dashboard(),
        ),
      );
    }

    testWidgets('Dashboard initializes correctly', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Wait for all animations to complete
      for (int i = 0; i < 5; i++) {
        await tester.pump(const Duration(seconds: 1));
      }

      // Verify that the Dashboard widget is present
      expect(find.byType(Dashboard), findsOneWidget);
      // Verify that the weekly completed workouts are displayed
      expect(find.textContaining('3'), findsWidgets);
      // Verify that the weekly goal is displayed
      expect(find.textContaining('5'), findsWidgets);
      // Verify that the streak is displayed
      expect(find.textContaining('2'), findsWidgets);

      expect(find.byType(RobotImageHolder), findsOneWidget);
    });

    testWidgets('Dashboard adapts layout for small screens',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(320, 568);
      tester.view.devicePixelRatio = 2.0;

      await tester.pumpWidget(createWidgetUnderTest());
      for (int i = 0; i < 5; i++) {
        await tester.pump(const Duration(seconds: 1));
      }

      // Check if ChargeBar has appropriate size
      final chargeBarFinder = find.byType(ChargeBar);
      expect(chargeBarFinder, findsOneWidget);
      final chargeBarSize = tester.getSize(chargeBarFinder);
      expect(chargeBarSize.width, lessThan(300));

      // Check if RobotImageHolder is scaled appropriately
      final robotImageFinder = find.byType(RobotImageHolder);
      expect(robotImageFinder, findsOneWidget);
      final robotImageSize = tester.getSize(robotImageFinder);
      expect(robotImageSize.height, lessThan(200));
      // Add more specific checks for small screen layout
    });

    testWidgets('Dashboard adapts layout for large screens',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1024, 1366);
      tester.view.devicePixelRatio = 2.0;

      await tester.pumpWidget(createWidgetUnderTest());
      for (int i = 0; i < 5; i++) {
        await tester.pump(const Duration(seconds: 1));
      }

      // Check if ChargeBar has appropriate size
      final chargeBarFinder = find.byType(ChargeBar);
      expect(chargeBarFinder, findsOneWidget);
      final chargeBarSize = tester.getSize(chargeBarFinder);
      expect(chargeBarSize.width, greaterThan(480));

      // Check if RobotImageHolder is scaled appropriately
      final robotImageFinder = find.byType(RobotImageHolder);
      expect(robotImageFinder, findsOneWidget);
      final robotImageSize = tester.getSize(robotImageFinder);
      expect(robotImageSize.height, greaterThan(220));
    });
  });

  group('Premium Features test', () {
    late MockAuthService mockAuthService;
    late MockFlutterUser mockFlutterUser;
    late MockAppBarAndBottomNavigationBarModel mockAppBarModel;
    late MockCurrencyModel mockCurrencyModel;
    late MockUserModel mockUserModel;
    late MockFigureModel mockFigureModel;
    late MockInventoryModel mockInventoryModel;
    late MockChatModel mockChatModel;

    setUp(() {
      mockAuthService = MockAuthService();
      mockFlutterUser = MockFlutterUser();
      mockAppBarModel = MockAppBarAndBottomNavigationBarModel();
      mockCurrencyModel = MockCurrencyModel();
      mockUserModel = MockUserModel();
      mockFigureModel = MockFigureModel();
      mockInventoryModel = MockInventoryModel();
      mockChatModel = MockChatModel();

      // Set up mock data
      final mockUser = User(
        weekComplete: Int64(3),
        weekGoal: Int64(5),
        workoutMinTime: Int64(30),
        streak: Int64(2),
        email: 'test@example.com',
        curFigure: 'robot1',
        premium: Int64(0), // Start as non-premium user
      );

      final mockFigure = FigureInstance(
        figureName: 'robot1',
        curSkin: '0',
        evLevel: 1,
        evPoints: 50,
        charge: 75,
      );

      when(mockCurrencyModel.currency).thenReturn('1000');
      when(mockUserModel.user).thenReturn(mockUser);
      when(mockFigureModel.figure).thenReturn(mockFigure);
      when(mockFigureModel.EVLevel).thenReturn(1);
      when(mockAppBarModel.appBarKey).thenReturn(GlobalKey());
      when(mockAppBarModel.bottomNavBarKey).thenReturn(GlobalKey());
      when(mockFigureModel.composeFigureUrl())
          .thenReturn('robot1/robot1_skin0_evo1_cropped_happy');

      // Mock AuthService methods
      when(mockAuthService.getUserDBInfo())
          .thenAnswer((_) => Future.value(mockUser));
      when(mockAuthService.updateUserDBInfo(any))
          .thenAnswer((_) => Future.value(mockUser));
      when(mockAuthService.getFigureInstance(any))
          .thenAnswer((_) => Future.value(mockFigure));

      // Mock ChatModel methods
      when(mockChatModel.messages).thenReturn(<ChatMessage>[
        ChatMessage("Welcome to Fitness Figure! Let's start an exercise!",
            "assistant", "robot1")
      ]);
      when(mockChatModel.isRobotTyping).thenReturn(false);
    });

    Widget createWidgetUnderTest() {
      final GoRouter goRouter = GoRouter(
        routes: [
          GoRoute(
            name: 'Home',
            path: '/',
            builder: (context, state) => const Dashboard(),
          ),
          GoRoute(
            name: 'Chat',
            path: '/chat',
            builder: (context, state) => const ChatPage(),
          ),
          GoRoute(
            name: 'Subscribe',
            path: '/subscribe',
            builder: (context, state) => const SubscribePage(),
          )
        ],
      );

      return MaterialApp.router(
        routerConfig: goRouter,
        builder: (context, child) {
          return MultiProvider(
            providers: [
              Provider<AuthService>.value(value: mockAuthService),
              Provider<FlutterUser>.value(value: mockFlutterUser),
              ChangeNotifierProvider<AppBarAndBottomNavigationBarModel>.value(
                  value: mockAppBarModel),
              ChangeNotifierProvider<CurrencyModel>.value(
                  value: mockCurrencyModel),
              ChangeNotifierProvider<UserModel>.value(value: mockUserModel),
              ChangeNotifierProvider<FigureModel>.value(value: mockFigureModel),
              ChangeNotifierProvider<InventoryModel>.value(
                  value: mockInventoryModel),
              ChangeNotifierProvider<ChatModel>.value(value: mockChatModel),
            ],
            child: child!,
          );
        },
      );
    }

    testWidgets('Chat icon behavior based on premium status',
        (WidgetTester tester) async {
      // Set up for non-premium user
      when(mockUserModel.isPremium()).thenReturn(false);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Find and tap the chat icon
      final chatIcon = find.byIcon(Icons.chat);
      expect(chatIcon, findsOneWidget);
      await tester.tap(chatIcon);
      await tester.pumpAndSettle();

      // Verify that the dialog for non-premium users is shown
      expect(find.text("FF+ Premium Feature"), findsOneWidget);
      expect(
          find.text(
              "Subscribe now to FF+ to gain access to chatting with your figure. Your figure can help you with all your fitness goals as well as assist in managing your growth! \n \nAdditionally, you earn extra rewards and cosmetics while you're subscribed!"),
          findsOneWidget);

      // Dismiss the dialog
      await tester.ensureVisible(find.text("Subscribe Now \$1.99"));
      await tester.tap(find.text("Subscribe Now \$1.99"));
      await tester.pumpAndSettle();
      expect(find.byType(SubscribePage), findsOneWidget);

      // Warns if 'Toggle Premium Status' button is found
      if (find
          .text("Toggle Premium Status", skipOffstage: false)
          .evaluate()
          .isNotEmpty) {
        logger.w(
            "Debug feature detected: 'Toggle Premium Status' button present. Remove before production release.");
      }

      await tester.ensureVisible(find.text("Maybe Later"));
      await tester.tap(find.text("Maybe Later"));
      await tester.pumpAndSettle();
      expect(find.byType(Dashboard), findsOneWidget);

      await tester.tap(chatIcon);
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.text("No Thanks"));
      await tester.tap(find.text("No Thanks"));
      await tester.pumpAndSettle();

      // Set up for premium user
      when(mockUserModel.isPremium()).thenReturn(true);
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Find and tap the chat icon again
      await tester.tap(chatIcon);
      await tester.pumpAndSettle();

      // Verify that the app navigates to the Chat page
      expect(find.byType(ChatPage), findsOneWidget);
    });
  });

  group('RobotImageHolder URL Tests', () {
    late MockAuthService mockAuthService;
    late MockFlutterUser mockFlutterUser;
    late MockAppBarAndBottomNavigationBarModel mockAppBarModel;
    late MockCurrencyModel mockCurrencyModel;
    late MockUserModel mockUserModel;
    late MockFigureModel mockFigureModel;
    late MockInventoryModel mockInventoryModel;
    late MockChatModel mockChatModel;

    setUp(() {
      mockAuthService = MockAuthService();
      mockFlutterUser = MockFlutterUser();
      mockAppBarModel = MockAppBarAndBottomNavigationBarModel();
      mockCurrencyModel = MockCurrencyModel();
      mockUserModel = MockUserModel();
      mockFigureModel = MockFigureModel();
      mockInventoryModel = MockInventoryModel();
      mockChatModel = MockChatModel();

      // Set up mock data
      final mockUser = User(
        weekComplete: Int64(3),
        weekGoal: Int64(5),
        workoutMinTime: Int64(30),
        streak: Int64(2),
        email: 'test@example.com',
        curFigure: 'robot1',
      );

      final mockFigure = FigureInstance(
        figureName: 'robot1',
        curSkin: '0',
        evLevel: 1,
        evPoints: 50,
        charge: 49,
      );

      when(mockCurrencyModel.currency).thenReturn('1000');
      when(mockUserModel.user).thenReturn(mockUser);
      when(mockFigureModel.figure).thenReturn(mockFigure);
      when(mockFigureModel.EVLevel).thenReturn(1);
      when(mockAppBarModel.appBarKey).thenReturn(GlobalKey());
      when(mockAppBarModel.bottomNavBarKey).thenReturn(GlobalKey());

      // Mock AuthService methods
      when(mockAuthService.getUserDBInfo())
          .thenAnswer((_) => Future.value(mockUser));
      when(mockAuthService.updateUserDBInfo(any))
          .thenAnswer((_) => Future.value(mockUser));
      when(mockAuthService.getFigureInstance(any))
          .thenAnswer((_) => Future.value(mockFigure));

      // Mock ChatModel methods
      when(mockChatModel.messages).thenReturn(<ChatMessage>[
        ChatMessage("Welcome to Fitness Figure! Let's start an exercise!",
            "assistant", "robot1")
      ]);
    });

    Widget createWidgetUnderTest() {
      return MaterialApp(
        home: MultiProvider(
          providers: [
            Provider<AuthService>.value(value: mockAuthService),
            Provider<FlutterUser>.value(value: mockFlutterUser),
            ChangeNotifierProvider<AppBarAndBottomNavigationBarModel>.value(
                value: mockAppBarModel),
            ChangeNotifierProvider<CurrencyModel>.value(
                value: mockCurrencyModel),
            ChangeNotifierProvider<UserModel>.value(value: mockUserModel),
            ChangeNotifierProvider<FigureModel>.value(value: mockFigureModel),
            ChangeNotifierProvider<InventoryModel>.value(
                value: mockInventoryModel),
            ChangeNotifierProvider<ChatModel>.value(value: mockChatModel),
          ],
          child: const Dashboard(),
        ),
      );
    }

    testWidgets('RobotImageHolder uses happy URL when charge is 50 or greater',
        (WidgetTester tester) async {
      when(mockFigureModel.figure).thenReturn(FigureInstance(
        figureName: 'robot1',
        curSkin: '0',
        evLevel: 1,
        charge: 50,
      ));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      final robotImageHolder = find.byType(RobotImageHolder);
      expect(robotImageHolder, findsOneWidget);

      final RobotImageHolder widget = tester.widget(robotImageHolder);
      expect(widget.url, 'robot1/robot1_skin0_evo1_cropped_happy');
    });

    testWidgets('RobotImageHolder uses sad URL when charge is less than 50',
        (WidgetTester tester) async {
      when(mockFigureModel.figure).thenReturn(FigureInstance(
        figureName: 'robot1',
        curSkin: '0',
        evLevel: 1,
        charge: 49,
      ));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      await tester.pumpAndSettle();

      final robotImageHolder = find.byType(RobotImageHolder);
      expect(robotImageHolder, findsOneWidget);

      final RobotImageHolder widget = tester.widget(robotImageHolder);
      expect(widget.url, 'robot1/robot1_skin0_evo1_cropped_sad');
    });
  });
}
