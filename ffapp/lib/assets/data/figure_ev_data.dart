class figureEvData {
  List<int> EvCutoffs = [];
  String figureName = "";
  int numberOfEvolutions = 0;
  int baseEvRequired = 0;
  int evRequirementGainPerLevel = 0;
  int levelScaleFactor = 0;
  List<List<String>> figureEvUpgrades = [];

  figureEvData({
    required this.figureName,
    this.numberOfEvolutions = 0,
    this.baseEvRequired = 0,
    this.evRequirementGainPerLevel = 0,
    this.levelScaleFactor = 0,
    this.figureEvUpgrades = const [],
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
  evRequirementGainPerLevel: 200,
  levelScaleFactor: 2,
  figureName: "robot1",
  figureEvUpgrades: [
    ["\$0.05/Sec"],
    ["\$0.10/Sec", "Research Unlocked"],
    ["\$0.25/Sec", "Research 20% Faster"],
    ["\$0.50/Sec", "Task EV +20%"],
    ["\$0.75/Sec", "Dual Tasking"],
    ["\$1.00/Sec", "Upgrade 12"],
    ["Upgrade 13", "Upgrade 14"],
    ["Upgrade 15", "Halve Research Time"],
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