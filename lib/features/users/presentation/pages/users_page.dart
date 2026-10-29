import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles_dashboard/core/components/base_app_bar.dart';
import 'package:stronger_muscles_dashboard/core/components/custom_search_bar.dart';
import 'package:stronger_muscles_dashboard/core/components/enhanced_error_widget.dart';
import 'package:stronger_muscles_dashboard/core/components/enhanced_loading_widget.dart';
import 'package:stronger_muscles_dashboard/core/components/generic_empty_state.dart';
import 'package:stronger_muscles_dashboard/core/components/my_refresh_indicator.dart';
import 'package:stronger_muscles_dashboard/core/components/top_section.dart';
import 'package:stronger_muscles_dashboard/core/theme/responsive.dart';
import '../controllers/users_providers.dart';
import '../widgets/user_card.dart';
import '../widgets/users_stats_header.dart';

/// شاشة المستخدمين: بحث + إحصائيات + قائمة بطاقات قابلة للتوسيع
class UsersPage extends ConsumerWidget {
  const UsersPage({super.key});

  /// البطاقات تتوسع بارتفاع متغير، لذا تبقى عموداً واحداً بعرض مريح للقراءة
  static const double _maxContentWidth = 1100;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final responsive = context.responsive;
    final usersAsync = ref.watch(usersNotifierProvider);
    final filteredUsers = ref.watch(filteredUsersProvider);
    final searchQuery = ref.watch(usersSearchQueryProvider);
    Future<void> refresh() =>
        ref.read(usersNotifierProvider.notifier).refresh();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: BaseAppBar(title: 'المستخدمون', onPressed: refresh),
      body: usersAsync.when(
        loading: () => const EnhancedLoadingWidget(
          message: 'جاري تحميل بيانات المستخدمين...',
        ),
        error: (error, _) => EnhancedErrorWidget.fromError(
          error,
          fallbackTitle: 'خطأ في تحميل المستخدمين',
          onRetry: refresh,
        ),
        data: (_) => Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: _maxContentWidth),
            child: Column(
              children: [
                TopSection(
                  children: [
                    CustomSearchBar(
                      hintText:
                          'ابحث عن المستخدم بالاسم أو البريد الإلكتروني...',
                      padding: responsive.defaultPadding,
                      onSearch: ref
                          .read(usersSearchQueryProvider.notifier)
                          .setQuery,
                    ),
                    const UsersStatsHeader(),
                  ],
                ),
                Expanded(
                  child: filteredUsers.isEmpty
                      ? GenericEmptyState(
                          title: 'لا يوجد مستخدمون',
                          message: searchQuery.isEmpty
                              ? 'لم يتم العثور على أي مستخدمين مسجلين'
                              : 'لا توجد نتائج لبحثك: "$searchQuery"',
                          icon: searchQuery.isEmpty
                              ? Icons.people_outline
                              : Icons.search_off_rounded,
                        )
                      : MyRefreshIndicator(
                          onRefresh: refresh,
                          child: ListView.separated(
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: responsive.defaultPadding,
                            itemCount: filteredUsers.length,
                            separatorBuilder: (_, _) =>
                                SizedBox(height: responsive.itemSpacing),
                            itemBuilder: (context, index) {
                              final user = filteredUsers[index];
                              return UserCard(
                                key: ValueKey(user.id),
                                user: user,
                              );
                            },
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
