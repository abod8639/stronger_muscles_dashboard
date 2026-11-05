import '../../domain/entities/ai_copilot_answer_entity.dart';

class AiCopilotSectionModel {
  final String title;
  final String icon;
  final List<String> points;

  const AiCopilotSectionModel({
    required this.title,
    this.icon = 'info',
    required this.points,
  });

  factory AiCopilotSectionModel.fromJson(Map<String, dynamic> json) {
    final rawPoints = json['points'] ?? json['items'] ?? [];
    return AiCopilotSectionModel(
      title: _cleanSymbols(json['title']?.toString() ?? 'تفاصيل إضافية'),
      icon: json['icon']?.toString() ?? 'info',
      points: (rawPoints as List<dynamic>?)
              ?.map((e) => _cleanSymbols(e.toString()))
              .where((e) => e.isNotEmpty)
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'icon': icon,
      'points': points,
    };
  }

  AiCopilotSectionEntity toEntity() {
    return AiCopilotSectionEntity(
      title: title,
      icon: icon,
      points: points,
    );
  }

  factory AiCopilotSectionModel.fromEntity(AiCopilotSectionEntity entity) {
    return AiCopilotSectionModel(
      title: entity.title,
      icon: entity.icon,
      points: entity.points,
    );
  }
}

class AiCopilotAnswerModel {
  final String directAnswer;
  final List<AiCopilotSectionModel> sections;

  const AiCopilotAnswerModel({
    required this.directAnswer,
    required this.sections,
  });

  factory AiCopilotAnswerModel.fromJson(Map<String, dynamic> json) {
    final rawSections = json['sections'];
    return AiCopilotAnswerModel(
      directAnswer: _cleanSymbols(
        json['direct_answer']?.toString() ??
            json['summary']?.toString() ??
            'إليك التحليل التنفيذي المطلوب:',
      ),
      sections: (rawSections as List<dynamic>?)
              ?.filter((e) => e is Map)
              .map((e) => AiCopilotSectionModel.fromJson(
                    Map<String, dynamic>.from(e as Map),
                  ))
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'direct_answer': directAnswer,
      'sections': sections.map((s) => s.toJson()).toList(),
    };
  }

  AiCopilotAnswerEntity toEntity() {
    return AiCopilotAnswerEntity(
      directAnswer: directAnswer,
      sections: sections.map((s) => s.toEntity()).toList(),
    );
  }

  factory AiCopilotAnswerModel.fromEntity(AiCopilotAnswerEntity entity) {
    return AiCopilotAnswerModel(
      directAnswer: entity.directAnswer,
      sections: entity.sections
          .map((s) => AiCopilotSectionModel.fromEntity(s))
          .toList(),
    );
  }

  /// Robust fallback parser that cleans raw text / markdown and converts it into structured human-readable sections.
  factory AiCopilotAnswerModel.fromRawText(String rawText) {
    var cleaned = rawText.trim();

    // Remove greetings and conversational filler
    final greetingRegex = RegExp(
      r'^(أهلاً بك|مرحباً بك|بصفتي مساعدك|إليك الإجابة)[^\n]*\n+',
      multiLine: true,
    );
    cleaned = cleaned.replaceAll(greetingRegex, '');

    final lines = cleaned.split('\n');
    String directAnswer = '';
    final List<AiCopilotSectionModel> sections = [];
    String? currentSectionTitle;
    String currentIcon = 'info';
    List<String> currentPoints = [];

    for (var line in lines) {
      var trimmed = _cleanSymbols(line);
      if (trimmed.isEmpty) continue;

      // Check if line looks like a header (e.g. starts with icon, or ends with colon)
      final isHeader = line.trim().startsWith('#') ||
          line.trim().startsWith('###') ||
          (trimmed.endsWith(':') && trimmed.length < 60) ||
          trimmed.contains('نسب توزيع') ||
          trimmed.contains('مؤشرات') ||
          trimmed.contains('خطوات عملية') ||
          trimmed.contains('توصيات') ||
          trimmed.contains('المخزون');

      if (isHeader && !trimmed.startsWith('•') && !trimmed.startsWith('-')) {
        if (currentSectionTitle != null && currentPoints.isNotEmpty) {
          sections.add(
            AiCopilotSectionModel(
              title: currentSectionTitle,
              icon: currentIcon,
              points: List.from(currentPoints),
            ),
          );
          currentPoints.clear();
        }

        var headerTitle = trimmed;
        if (headerTitle.endsWith(':')) {
          headerTitle = headerTitle.substring(0, headerTitle.length - 1).trim();
        }

        if (headerTitle.contains('مبيعات') || headerTitle.contains('مؤشر') || headerTitle.contains('نسب')) {
          currentIcon = 'analytics';
        } else if (headerTitle.contains('خطوات') || headerTitle.contains('عملية') || headerTitle.contains('توصي')) {
          currentIcon = 'action';
        } else if (headerTitle.contains('خطر') || headerTitle.contains('تحذير')) {
          currentIcon = 'warning';
        } else {
          currentIcon = 'info';
        }

        currentSectionTitle = headerTitle;
      } else {
        // Bullet or content line
        if (currentSectionTitle == null) {
          if (directAnswer.isEmpty) {
            directAnswer = trimmed;
          } else {
            directAnswer += ' $trimmed';
          }
        } else {
          // Clean bullet prefix if any
          var point = trimmed;
          if (point.startsWith('- ') || point.startsWith('• ')) {
            point = point.substring(2).trim();
          } else if (RegExp(r'^\d+[\.\)]\s*').hasMatch(point)) {
            point = point.replaceFirst(RegExp(r'^\d+[\.\)]\s*'), '').trim();
          }
          if (point.isNotEmpty) {
            currentPoints.add(point);
          }
        }
      }
    }

    if (currentSectionTitle != null && currentPoints.isNotEmpty) {
      sections.add(
        AiCopilotSectionModel(
          title: currentSectionTitle,
          icon: currentIcon,
          points: currentPoints,
        ),
      );
    }

    if (directAnswer.isEmpty && sections.isNotEmpty) {
      directAnswer = 'إليك ملخص التحليل التشغيلي الدقيق:';
    }

    return AiCopilotAnswerModel(
      directAnswer: directAnswer.isNotEmpty
          ? directAnswer
          : 'إليك التحليل المطلوب للمؤشرات التشغيلية:',
      sections: sections,
    );
  }
}

/// Strictly eliminates all raw markdown formatting symbols (asterisks, hashes, raw brackets)
String _cleanSymbols(String text) {
  var result = text;
  // Remove markdown bold and italic asterisks
  result = result.replaceAll('***', '');
  result = result.replaceAll('**', '');
  result = result.replaceAll('*', '');
  // Remove markdown headers
  result = result.replaceAll('###', '');
  result = result.replaceAll('##', '');
  result = result.replaceAll('#', '');
  // Remove horizontal rules
  result = result.replaceAll('---', '');
  result = result.replaceAll('___', '');
  // Remove backticks
  result = result.replaceAll('`', '');
  return result.trim();
}

extension _IterableFilter<T> on Iterable<T> {
  Iterable<T> filter(bool Function(T) test) sync* {
    for (final element in this) {
      if (test(element)) yield element;
    }
  }
}

