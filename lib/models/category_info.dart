enum HitType {
  none,
  hit,
  partial,
  miss,
}

typedef CategoryResult = ({String category, dynamic value, HitType type, dynamic clue});
typedef CategoryInfo = ({String category, String? value});

const List<String> games = [
  'Kingdom Hearts',
  'Kingdom Hearts Final Mix',
  'Kingdom Hearts Re:Chain of Memories',
  'Kingdom Hearts II',
  'Kingdom Hearts II Final Mix',
  'Kingdom Hearts 358/2 Days',
  'Kingdom Hearts Birth By Sleep',
  'Kingdom Hearts Birth By Sleep Final Mix',
  'Kingdom Hearts Re:Coded',
  'Kingdom Hearts 3D: Dream Drop Distance',
  'Kingdom Hearts χ[chi]',
  'Kingdom Hearts Union χ[Cross]',
  'Kingdom Hearts 0.2 Birth by Sleep -A fragmentary passage-',
  'Kingdom Hearts Dark Road',
  'Kingdom Hearts III + Re Mind'
];

const List<String> canonicalGames = [
  'Kingdom Hearts Final Mix',
  'Kingdom Hearts Re:Chain of Memories',
  'Kingdom Hearts II Final Mix',
  'Kingdom Hearts 358/2 Days',
  'Kingdom Hearts Birth By Sleep Final Mix',
  'Kingdom Hearts Re:Coded',
  'Kingdom Hearts 3D: Dream Drop Distance',
  'Kingdom Hearts χ[chi]',
  'Kingdom Hearts Union χ[Cross]',
  'Kingdom Hearts 0.2 Birth by Sleep -A fragmentary passage-',
  'Kingdom Hearts Dark Road',
  'Kingdom Hearts III + Re Mind'
];