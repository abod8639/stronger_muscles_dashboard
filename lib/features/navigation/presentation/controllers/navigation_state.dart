import 'package:stronger_muscles_dashboard/features/navigation/domain/entities/navigation_badges_entity.dart';

/// Immutable state model representing navigation selection, drawer state, and badge counters.
class NavigationState {
  final int selectedIndex;
  final bool isDrawerOpen;
  final NavigationBadgesEntity badges;
  final String userRole;

  const NavigationState({
    required this.selectedIndex,
    required this.isDrawerOpen,
    required this.badges,
    required this.userRole,
  });

  factory NavigationState.initial({String userRole = 'admin'}) =>
      NavigationState(
        selectedIndex: 0,
        isDrawerOpen: false,
        badges: const NavigationBadgesEntity.initial(),
        userRole: userRole,
      );

  NavigationState copyWith({
    int? selectedIndex,
    bool? isDrawerOpen,
    NavigationBadgesEntity? badges,
    String? userRole,
  }) {
    return NavigationState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      isDrawerOpen: isDrawerOpen ?? this.isDrawerOpen,
      badges: badges ?? this.badges,
      userRole: userRole ?? this.userRole,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NavigationState &&
          runtimeType == other.runtimeType &&
          selectedIndex == other.selectedIndex &&
          isDrawerOpen == other.isDrawerOpen &&
          badges == other.badges &&
          userRole == other.userRole;

  @override
  int get hashCode =>
      selectedIndex.hashCode ^
      isDrawerOpen.hashCode ^
      badges.hashCode ^
      userRole.hashCode;

  @override
  String toString() =>
      'NavigationState(selectedIndex: $selectedIndex, isDrawerOpen: $isDrawerOpen, badges: $badges, userRole: $userRole)';
}
