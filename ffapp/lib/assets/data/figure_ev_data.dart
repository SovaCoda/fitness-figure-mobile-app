import '../../services/routes.pb.dart';

/// This class serves to encapsulate the information of each figure
///
/// It contains static information about a figure such as:
///     - The number of evolutions a figure can perform,
///     - Calculations for how much evo it takes to level up a figure
///     - The evolution upgrades for that figure
class FigureEvData {
  /// A list of the amount of required EV to c
  List<int> evCutoffs = [];

  /// The figure name as stated in the database
  String figureName = "";

  /// The number of evolutions that the figure can undergo (currently unused)
  int numberOfEvolutions = 0;

  /// The amount of evo required to evolve a figure that hasn't evolved
  ///
  /// Adds onto the [evCutoffs]
  int baseEvRequired = 0;

  /// The total price for the figure in the store page
  int price = 0;

  /// The amount of the required ev to evolve that will be multiplied by the EV level
  ///
  /// multiplies by the EV level (starting from zero) when calculating [evCutoffs]
  int evRequirementGainPerLevel = 0;

  /// The scale to increase the figure when it levels up
  int levelScaleFactor = 0;

  /// A list of upgrades from evolution for display in the evolution page
  List<List<String>> figureEvUpgrades = [];

  /// A list of the amount of currency that the figure generates based on EV level
  List<double> currencyGens = [];

  FigureEvData({
    required this.figureName,
    this.numberOfEvolutions = 0,
    this.baseEvRequired = 0,
    this.evRequirementGainPerLevel = 0,
    this.levelScaleFactor = 0,
    this.figureEvUpgrades = const [],
    this.currencyGens = const [],
  }) {
    evCutoffs = _generateEvCutoffs;
  }

  /// Calculates the EV cutoffs of the figure for all levels
  List<int> get _generateEvCutoffs {
    return List.generate(
      numberOfEvolutions,
      (index) => baseEvRequired + evRequirementGainPerLevel * index,
    );
  }

  /// Gathers data from the class to instantiate a [Figure] object
  ///
  /// Returns a figure object from figureEvData
  Figure getFigure() {
    return Figure(
      figureName: figureName,
      // ! these are hardcoded in as there are no fields for these
      baseEvGain: 10,
      baseCurrencyGain: 5,
      price: 300,
      stage1EvCutoff: evCutoffs[0],
      stage2EvCutoff: evCutoffs[1],
      stage3EvCutoff: evCutoffs[2],
      stage4EvCutoff: evCutoffs[3],
      stage5EvCutoff: evCutoffs[4],
      stage6EvCutoff: evCutoffs[5],
      stage7EvCutoff: evCutoffs[6],
      stage8EvCutoff: evCutoffs[7],
    );
  }
}

/// Static information for "robot1"
FigureEvData figure1 = FigureEvData(
  numberOfEvolutions: 8,
  baseEvRequired: 300,
  evRequirementGainPerLevel: 700,
  levelScaleFactor: 1,
  figureName: "robot1",
  currencyGens: [0.025, 0.05, 0.1, 0.25, 0.5, 0.75, 1.0, 1.5],
  figureEvUpgrades: [
    ["\$0.025/Sec" "Research Unlocked"],
    ["\$0.05/Sec", "Multi Tasking"],
    ["\$0.10/Sec", "Halve Research Time"],
    ["\$0.25/Sec", "Task EV +20%"],
    ["\$0.50/Sec", "Multi Tasking"],
    ["\$0.75/Sec"],
    ["\$1.00/Sec"],
    ["\$1.50/Sec", "Halve Research Time"],
    // Add more lists for each evolution
  ],
);

FigureEvData figure2 = FigureEvData(
  numberOfEvolutions: 8,
  baseEvRequired: 100,
  evRequirementGainPerLevel: 100,
  levelScaleFactor: 2,
  figureName: "robot2",
  figureEvUpgrades: [
    ["\$0.04/Sec"],
    ["\$0.09/Sec", "Research Unlocked"],
    ["\$0.20/Sec", "10% Power Efficiency"],
    ["\$0.45/Sec", "Research Success Rate +15%"],
    ["\$0.70/Sec", "Dual Tasking"],
    ["\$1.00/Sec", "Research Cost -25%"],
    ["\$1.40/Sec", "Overclocking - Temporarily Boost Robot's Speed by 20%"],
    ["Upgrade O", "Upgrade P"],
    // Add more lists for each evolution
  ],
);

Map<String, double> figureSizeMultipliers = {
  "11": 0.75,
  "12": 1,
  "13": 1.25,
  "21": 0.75,
  "22": 1.0,
  "23": 1.5,
};
