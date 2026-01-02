import 'dart:convert';

class MoodReflection {
  final List<String>? factors;
  final String? note;

  const MoodReflection({
    this.factors,
    this.note,
  });

  Map<String, dynamic> toMap() {
    return {
      'factors': factors != null ? jsonEncode(factors) : null,
      'note': note,
    };
  }

  factory MoodReflection.fromMap(Map<String, dynamic> map) {
    return MoodReflection(
      factors: map['factors'] != null
          ? List<String>.from(jsonDecode(map['factors']))
          : null,
      note: map['note'] as String?,
    );
  }
}
