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

const List<CategoryInfo> keybladeCategories = [
  (
    category: '',
    value: null,
  ),
  (
    category: 'Name',
    value: null,
  ),
  (
    category: 'Debut',
    value: 'The game (release order) in which the keyblade first appeared.',
  ),
  (
    category: 'Strength',
    value: "The base strength stat/boost the keyblade provides in the first game it can be used; otherwise displays as 1. Yellow indicates you are within 2 of the correct number.",
  ),
  (
    category: 'Magic',
    value: "The base magic stat/boost the keyblade provides in the first game it can be used; otherwise displays as 1. Yellow indicates you are within 2 of the correct number.",
  ),
  (
    category: 'Wielders',
    value: 'Characters that have wielded this keyblade either during gameplay or in a cutscene.',
  ),
  (
    category: 'Appearances',
    value: 'The number of games the keyblade appears in. Yellow indicates you are within 2 of the correct number.',
  )
];


const List<CategoryInfo> characterCategories = [
  (
    category: '',
    value: null,
  ),
  (
    category: 'Name',
    value: null,
  ),
  (
    category: 'Gender',
    value: null,
  ),
  (
    category: 'Species',
    value: null,
  ),
  (
    category: 'Debut',
    value: 'The game (chronological order) in which they first appeared.',
  ),
  (
    category: 'Weapon',
    value: null,
  ),
  (
    category: 'Norted',
    value: 'Whether or not they have been part Xehanort at any point throughout the series.',
  ),
  (
    category: 'Origin',
    value: 'The media they originate from, e.g. Kingdom Hearts, Toy Story, Final Fantasy VIII, etc.',
  )
];