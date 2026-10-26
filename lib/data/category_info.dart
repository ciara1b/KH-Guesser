enum HitType {
  none,
  hit,
  partial,
  miss,
}

typedef CategoryResult = ({String category, dynamic value, HitType type, dynamic clue});
typedef CategoryInfo = ({String category, String? value});

const String gamesIncluded = 'Games included:\n • Kingdom Hearts\n • Kingdom Hearts Final Mix\n • Kingdom Hearts: Chain of Memories\n • Kingdom Hearts II\n • Kingdom Hearts II Final Mix\n • Kingdom Hearts 358/2 Days\n • Kingdom Hearts Birth By Sleep\n • Kingdom Hearts Birth By Sleep Final Mix\n • Kingdom Hearts Re:Coded\n • Kingdom Hearts 3D: Dream Drop Distance\n • Kingdom Hearts χ[chi]\n • Kingdom Hearts Union χ[Cross]\n • Kingdom Hearts Dark Road\n • Kingdom Hearts III + Re Mind';