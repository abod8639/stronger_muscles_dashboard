import '../../domain/entities/support_stats_entity.dart';
import '../../domain/entities/support_ticket_entity.dart';

/// Immutable State object representing the UI state of the Support & Complaints module.
/// Enforces Rule 4: State Management & Performance with strict immutability.
class SupportState {
  final bool isLoading;
  final bool isLoadingMore;
  final bool isLoadingDetail;
  final bool isSendingReply;
  final bool isUpdating;
  final bool isDeleting;

  final List<SupportTicketEntity> tickets;
  final List<SupportTicketEntity> filteredTickets;
  final SupportTicketEntity? selectedTicket;
  final SupportStatsEntity stats;

  final String selectedStatus;
  final String selectedPriority;
  final String selectedCategory;
  final String searchQuery;

  final bool isInternalNote;
  final String replyStatus;

  final int currentPage;
  final bool hasMore;

  final String? errorMessage;
  final String? successMessage;

  const SupportState({
    this.isLoading = false,
    this.isLoadingMore = false,
    this.isLoadingDetail = false,
    this.isSendingReply = false,
    this.isUpdating = false,
    this.isDeleting = false,
    this.tickets = const [],
    this.filteredTickets = const [],
    this.selectedTicket,
    this.stats = const SupportStatsEntity(),
    this.selectedStatus = 'all',
    this.selectedPriority = 'all',
    this.selectedCategory = 'all',
    this.searchQuery = '',
    this.isInternalNote = false,
    this.replyStatus = 'waiting_user',
    this.currentPage = 1,
    this.hasMore = false,
    this.errorMessage,
    this.successMessage,
  });

  SupportState copyWith({
    bool? isLoading,
    bool? isLoadingMore,
    bool? isLoadingDetail,
    bool? isSendingReply,
    bool? isUpdating,
    bool? isDeleting,
    List<SupportTicketEntity>? tickets,
    List<SupportTicketEntity>? filteredTickets,
    SupportTicketEntity? Function()? selectedTicket,
    SupportStatsEntity? stats,
    String? selectedStatus,
    String? selectedPriority,
    String? selectedCategory,
    String? searchQuery,
    bool? isInternalNote,
    String? replyStatus,
    int? currentPage,
    bool? hasMore,
    String? Function()? errorMessage,
    String? Function()? successMessage,
  }) {
    return SupportState(
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isLoadingDetail: isLoadingDetail ?? this.isLoadingDetail,
      isSendingReply: isSendingReply ?? this.isSendingReply,
      isUpdating: isUpdating ?? this.isUpdating,
      isDeleting: isDeleting ?? this.isDeleting,
      tickets: tickets ?? this.tickets,
      filteredTickets: filteredTickets ?? this.filteredTickets,
      selectedTicket:
          selectedTicket != null ? selectedTicket() : this.selectedTicket,
      stats: stats ?? this.stats,
      selectedStatus: selectedStatus ?? this.selectedStatus,
      selectedPriority: selectedPriority ?? this.selectedPriority,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      searchQuery: searchQuery ?? this.searchQuery,
      isInternalNote: isInternalNote ?? this.isInternalNote,
      replyStatus: replyStatus ?? this.replyStatus,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
      successMessage:
          successMessage != null ? successMessage() : this.successMessage,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SupportState &&
        other.isLoading == isLoading &&
        other.isLoadingMore == isLoadingMore &&
        other.isLoadingDetail == isLoadingDetail &&
        other.isSendingReply == isSendingReply &&
        other.isUpdating == isUpdating &&
        other.isDeleting == isDeleting &&
        other.selectedTicket == selectedTicket &&
        other.stats == stats &&
        other.selectedStatus == selectedStatus &&
        other.selectedPriority == selectedPriority &&
        other.selectedCategory == selectedCategory &&
        other.searchQuery == searchQuery &&
        other.isInternalNote == isInternalNote &&
        other.replyStatus == replyStatus &&
        other.currentPage == currentPage &&
        other.hasMore == hasMore &&
        other.errorMessage == errorMessage &&
        other.successMessage == successMessage &&
        _listEquals(other.tickets, tickets) &&
        _listEquals(other.filteredTickets, filteredTickets);
  }

  static bool _listEquals(
      List<SupportTicketEntity> a, List<SupportTicketEntity> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  @override
  int get hashCode => Object.hash(
        isLoading,
        isLoadingMore,
        isLoadingDetail,
        isSendingReply,
        isUpdating,
        isDeleting,
        selectedTicket,
        stats,
        selectedStatus,
        selectedPriority,
        selectedCategory,
        searchQuery,
        isInternalNote,
        replyStatus,
        currentPage,
        hasMore,
        errorMessage,
        successMessage,
      );

  @override
  String toString() =>
      'SupportState(loading: $isLoading, tickets: ${tickets.length}, selected: ${selectedTicket?.ticketNumber})';
}
