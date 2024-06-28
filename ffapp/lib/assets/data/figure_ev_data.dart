class figureEvData {
  List<int> EvCutoffs = [];
  String figureName = "";
  int numberOfEvolutions = 0;
  int baseEvRequired = 0;
  int evRequirementGainPerLevel = 0;
  int levelScaleFactor = 0;

  figureEvData(
      {required this.figureName,
      this.numberOfEvolutions = 0,
      this.baseEvRequired = 0,
      this.evRequirementGainPerLevel = 0,
      this.levelScaleFactor = 0}) {
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
);

figureEvData figure2 = figureEvData(
  numberOfEvolutions: 8,
  baseEvRequired: 100,
  evRequirementGainPerLevel: 100,
  levelScaleFactor: 2,
  figureName: "robot2",
);
