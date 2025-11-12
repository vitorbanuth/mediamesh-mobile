class Activity {
  final int id;
  final String text;
  final String sub;
  final String actor;
  final DateTime date;
  final String kind;
  final String target;
  final Map<String, dynamic> raw;

  Activity({
    required this.id,
    required this.text,
    required this.sub,
    required this.actor,
    required this.date,
    required this.kind,
    required this.target,
    required this.raw,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    // A API pode devolver os campos em root ou dentro de "activity"
    final Map<String, dynamic> root = Map<String, dynamic>.from(json);
    final Map<String, dynamic> activity =
        (root['activity'] is Map) ? Map<String, dynamic>.from(root['activity']) : root;

    final idVal = root['id'] ?? activity['id'] ?? 0;
    final id = idVal is int ? idVal : int.tryParse(idVal?.toString() ?? '') ?? 0;
    final text = activity['text'] ?? root['text'] ?? '';
    final sub = activity['sub'] ?? root['sub'] ?? '';
    final actor = activity['actor'] ?? root['actor'] ?? '';
    final dateStr = activity['date'] ?? root['date'] ?? '';
    final date = DateTime.tryParse(dateStr.toString()) ?? DateTime.now();
    final kind = activity['kind'] ?? root['kind'] ?? '';
    final target = activity['target'] ?? root['target'] ?? '';

    return Activity(
      id: id,
      text: text.toString(),
      sub: sub.toString(),
      actor: actor.toString(),
      date: date.toUtc(),
      kind: kind.toString(),
      target: target.toString(),
      raw: root,
    );
  }

  String timeAgo() {
    final now = DateTime.now().toUtc();
    final diff = now.difference(date);
    if (diff.inSeconds < 60) return '${diff.inSeconds}s atrás';
    if (diff.inMinutes < 60) return '${diff.inMinutes} minutos atrás';
    if (diff.inHours < 24) return '${diff.inHours} hora${diff.inHours > 1 ? 's' : ''} atrás';
    if (diff.inDays < 30) return '${diff.inDays} dias atrás';
    final months = (diff.inDays / 30).floor();
    if (months < 12) return '$months mês(es) atrás';
    final years = (diff.inDays / 365).floor();
    return '$years ano(s) atrás';
  }
}