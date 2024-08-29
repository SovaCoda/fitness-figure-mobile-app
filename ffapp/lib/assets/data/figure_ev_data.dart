class figureEvData {
  List<int> EvCutoffs = [];
  String figureName = "";
  int numberOfEvolutions = 0;
  int baseEvRequired = 0;
  int evRequirementGainPerLevel = 0;
  int levelScaleFactor = 0;
  List<List<String>> figureEvUpgrades = [];
  List<double> figureCurrencyGens = [];

  figureEvData({
    required this.figureName,
    this.numberOfEvolutions = 0,
    this.baseEvRequired = 0,
    this.evRequirementGainPerLevel = 0,
    this.levelScaleFactor = 0,
    this.figureEvUpgrades = const [],
    this.figureCurrencyGens = const [],
  }) {
    EvCutoffs = _generateEvCutoffs;
  }

  List<int> get _generateEvCutoffs {
    return List.generate(
      numberOfEvolutions,
      (index) => baseEvRequired + evRequirementGainPerLevel * index,
    );
  }
}

figureEvData figure1 = figureEvData(
  numberOfEvolutions: 8,
  baseEvRequired: 100,
  evRequirementGainPerLevel: 800,
  levelScaleFactor: 2,
  figureName: "robot1",
  figureCurrencyGens: [0.05, 0.10, 0.25, 0.50, 0.75, 1.00, 1.25, 1.50],
  figureEvUpgrades: [
    ["\$0.05/Sec"],
    ["\$0.25/Sec", "Research Unlocked"],
    ["Upgrade 5", "Upgrade 6"],
    ["Upgrade 7", "Upgrade 8"],
    ["Upgrade 9", "Upgrade 10"],
    ["Upgrade 11", "Upgrade 12"],
    ["Upgrade 13", "Upgrade 14"],
    ["Upgrade 15", "Upgrade 16"],
    // Add more lists for each evolution
  ],
);

figureEvData figure2 = figureEvData(
  numberOfEvolutions: 8,
  baseEvRequired: 100,
  evRequirementGainPerLevel: 100,
  levelScaleFactor: 2,
  figureName: "robot2",
  figureEvUpgrades: [
    ["Upgrade A", "Upgrade B"],
    ["Upgrade C", "Upgrade D"],
    ["Upgrade E", "Upgrade F"],
    ["Upgrade G", "Upgrade H"],
    ["Upgrade I", "Upgrade J"],
    ["Upgrade K", "Upgrade L"],
    ["Upgrade M", "Upgrade N"],
    ["Upgrade O", "Upgrade P"],
    // Add more lists for each evolution
  ],
);
