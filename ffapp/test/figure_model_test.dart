import 'package:flutter_test/flutter_test.dart';
import 'package:ffapp/main.dart';
import 'package:ffapp/services/routes.pb.dart' as routes;

void main() {
  group('FigureModel Tests', () {
    late FigureModel figureModel;

    setUp(() {
      figureModel = FigureModel();
    });

    test('Initial values are set correctly', () {
      expect(figureModel.EVLevel, 0);
      expect(figureModel.figure?.figureName, "robot1");
      expect(figureModel.figure?.curSkin, "0");
    });

    test('setFigure updates figure correctly', () {
      final newFigure = routes.FigureInstance(
        figureName: "robot2",
        curSkin: "1",
        evLevel: 2,
      );
      figureModel.setFigure(newFigure);
      expect(figureModel.figure?.figureName, "robot2");
      expect(figureModel.figure?.curSkin, "1");
      expect(figureModel.EVLevel, 2);
    });

    test('composeFigureUrl returns correct URL', () {
      expect(figureModel.composeFigureUrl(), "robot1/robot1_skin0_evo0_cropped_happy");
      
      figureModel.setFigure(routes.FigureInstance(
        figureName: "robot2",
        curSkin: "1",
        evLevel: 3,
      ));
      expect(figureModel.composeFigureUrl(), "robot2/robot2_skin1_evo3_cropped_happy");
    });
  });
}