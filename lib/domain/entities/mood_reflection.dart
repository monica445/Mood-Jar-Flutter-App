class MoodReflection {
  final List<String>? factors;
  final String? note;

  const MoodReflection({
    this.factors,
    this.note,
  });

  Map<String, dynamic> toMap() {
    return {
      'factors': factors ?? [], 
      'note': note ?? '', 
    };
  }

  factory MoodReflection.fromMap(Map<String, dynamic> map) {
    return MoodReflection(
      factors: map['factors'] is List 
          ? List<String>.from(map['factors'])
          : [],
      note: map['note'] as String?,
    );
  }
}