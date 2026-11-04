/// Pure Dart Domain Entity representing a structured, human-readable section in an AI Copilot response.
class AiCopilotSectionEntity {
  final String title;
  final String icon; // 'analytics' | 'action' | 'warning' | 'info'
  final List<String> points;

  const AiCopilotSectionEntity({
    required this.title,
    this.icon = 'info',
    required this.points,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AiCopilotSectionEntity &&
          runtimeType == other.runtimeType &&
          title == other.title &&
          icon == other.icon;

  @override
  int get hashCode => title.hashCode ^ icon.hashCode;
}

/// Pure Dart Domain Entity representing a complete, clean, structured AI Copilot answer.
class AiCopilotAnswerEntity {
  final String directAnswer;
  final List<AiCopilotSectionEntity> sections;

  const AiCopilotAnswerEntity({
    required this.directAnswer,
    required this.sections,
  });

  /// Formats the answer into clean, human-readable plain text without any raw markdown symbols
  String toPlainText() {
    final buffer = StringBuffer();
    if (directAnswer.isNotEmpty) {
      buffer.writeln(directAnswer);
      buffer.writeln();
    }
    for (final section in sections) {
      buffer.writeln('■ ${section.title}:');
      for (final pt in section.points) {
        buffer.writeln('  • $pt');
      }
      buffer.writeln();
    }
    return buffer.toString().trim();
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AiCopilotAnswerEntity &&
          runtimeType == other.runtimeType &&
          directAnswer == other.directAnswer;

  @override
  int get hashCode => directAnswer.hashCode;
}
