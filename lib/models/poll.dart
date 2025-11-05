class Poll {
  final int? id;
  final String title;
  final List<String> options;
  final Map<String, int> votes;

  Poll({
    this.id,
    required this.title,
    required this.options,
    required this.votes,
  });

  Poll copyWith({
    int? id,
    String? title,
    List<String>? options,
    Map<String, int>? votes,
  }) {
    return Poll(
      id: id ?? this.id,
      title: title ?? this.title,
      options: options ?? this.options,
      votes: votes ?? this.votes,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'options': options.join(','),
      'votes': votes.toString(),
    };
  }

  factory Poll.fromMap(Map<String, dynamic> map) {
    return Poll(
      id: map['id'],
      title: map['title'],
      options: (map['options'] as String).split(','),
      votes: _parseVotes(map['votes']),
    );
  }

  static Map<String, int> _parseVotes(String votesString) {
    // Example input: {Option 1: 5, Option 2: 3}
    votesString = votesString.replaceAll('{', '').replaceAll('}', '');
    List<String> votePairs = votesString.split(', ');
    Map<String, int> votes = {};
    for (var pair in votePairs) {
      List<String> keyValue = pair.split(': ');
      if (keyValue.length == 2) {
        String key = keyValue[0];
        int value = int.tryParse(keyValue[1]) ?? 0;
        votes[key] = value;
      }
    }
    return votes;
  }

}