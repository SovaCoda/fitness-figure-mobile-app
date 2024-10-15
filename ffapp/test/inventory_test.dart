import 'package:ffapp/components/charge_bar.dart';
import 'package:ffapp/components/ev_bar.dart';
import 'package:ffapp/pages/home/inventory.dart';
import 'package:ffapp/pages/home/store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/web.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:ffapp/services/flutterUser.dart';
import 'package:ffapp/main.dart';
import 'package:ffapp/services/auth.dart';
import 'package:ffapp/services/routes.pb.dart';
import 'package:ffapp/components/robot_image_holder.dart';
import 'package:fixnum/fixnum.dart';
import 'package:ffapp/components/utils/chat_model.dart';
import 'package:logger/logger.dart';
import 'package:mockito/annotations.dart';
import 'package:ffapp/components/skin_view.dart';

@GenerateMocks([SelectedFigureProvider, FigureInstancesProvider])

import 'dashboard_test.mocks.dart';
import 'inventory_test.mocks.dart';

Logger logger = Logger();



void main() {
  group('Inventory Widget Tests', () {
    late MockAuthService mockAuthService;
    late MockFlutterUser mockFlutterUser;
    late MockAppBarAndBottomNavigationBarModel mockAppBarModel;
    late MockCurrencyModel mockCurrencyModel;
    late MockUserModel mockUserModel;
    late MockFigureModel mockFigureModel;
    late MockInventoryModel mockInventoryModel;
    late MockChatModel mockChatModel;
    late MockSelectedFigureProvider mockSelectedFigureProvider;

    setUp(() {
      mockAuthService = MockAuthService();
      mockFlutterUser = MockFlutterUser();
      mockAppBarModel = MockAppBarAndBottomNavigationBarModel();
      mockCurrencyModel = MockCurrencyModel();
      mockUserModel = MockUserModel();
      mockFigureModel = MockFigureModel();
      mockInventoryModel = MockInventoryModel();
      mockChatModel = MockChatModel();
      mockSelectedFigureProvider = MockSelectedFigureProvider();

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
      when(mockAuthService.getFigureInstances(mockUser)).thenAnswer(
        (_) => Future.value(
          MultiFigureInstance(
            figureInstances: [mockFigure],
          ),
        ),
      );
      when(mockAuthService.getFigures()).thenAnswer(
        (_) => Future.value(
          MultiFigure(
            figures: [Figure(figureName: 'robot1', price: 300), Figure(figureName: 'robot2', price: 400), Figure(figureName: 'robot3', price: 500)],
          ),
        ),
      );
      when(mockAuthService.getSkins()).thenAnswer(
        (_) => Future.value(
          MultiSkin(
            skins: [Skin(skinName: 'robot1_skin0'), Skin(skinName: 'robot2_skin0'), Skin(skinName: 'robot3_skin0')],
          ),
        ),
      );
      when(mockAuthService.getSkinInstances(mockUser)).thenAnswer(
        (_) => Future.value(
          MultiSkinInstance(
            skinInstances: [SkinInstance(skinName: 'robot1_skin0')],
          ),
        ),
      );

      // Mock ChatModel methods
      when(mockChatModel.messages).thenReturn(<ChatMessage>[]);

      // Mock SelectedFigureProvider methods
      when(mockSelectedFigureProvider.selectedFigureIndex).thenReturn(0);
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
            ChangeNotifierProvider<SelectedFigureProvider>.value(value: mockSelectedFigureProvider),
        // ChangeNotifierProvider<FigureInstancesProvider>(
        //   create: (_) => MockFigureInstancesProvider(),
        // ),
        // Add any other providers used in SkinViewer
      ],
      child: const Inventory()
        ),
      );
    }

    testWidgets('Inventory initializes correctly', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Wait for all animations to complete
      await tester.pumpAndSettle();

      // Verify that the Inventory widget is present
      expect(find.byType(Inventory), findsOneWidget);

      // Verify that the correct widgets are present
      expect(find.byType(RobotImageHolder), findsOneWidget);
      expect(find.byType(ChargeBar), findsOneWidget);
      expect(find.byType(EvBar), findsOneWidget);
      expect(find.text('Go to Store'), findsOneWidget);
      expect(find.byIcon(Icons.swap_horiz), findsOneWidget);
      
      // Verify that the correct values are displayed
      RobotImageHolder robotImageHolder = tester.widget(find.byType(RobotImageHolder));
      expect(robotImageHolder.url, 'robot1/robot1_skin0_evo1_cropped_happy');
      ChargeBar chargeBar = tester.widget(find.byType(ChargeBar));
      expect(chargeBar.currentCharge, 75);
      EvBar evBar = tester.widget(find.byType(EvBar));
      expect(evBar.currentXp, 50);

    });

    testWidgets('Skin dialog opens correctly', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Wait for all animations to complete
      await tester.pumpAndSettle();

      // Tap the 'Go to Store' button
      await tester.tap(find.byIcon(Icons.swap_horiz));     
      await tester.pumpAndSettle();

      // Verify that the Skin dialog is present
      expect(find.byType(AlertDialog), findsOneWidget);
    });
  });
}