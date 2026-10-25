enum HitType {
  none,
  hit,
  partial,
  miss,
}

typedef CategoryResult = ({String category, dynamic value, HitType type, dynamic clue});
typedef CategoryInfo = ({String category, String? value});