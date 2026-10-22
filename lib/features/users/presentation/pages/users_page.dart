import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/components/base_app_bar.dart';
import '../../../../core/utils/components/custom_search_bar.dart';
import '../../../../core/utils/components/enhanced_error_widget.dart';
import '../../../../core/utils/components/enhanced_loading_widget.dart';
import '../../../../core/utils/components/my_refresh_indicator.dart';
import '../../../../core/utils/components/top_section.dart';
import '../controllers/users_providers.dart';
import '../widgets/user_card.dart';
import '../widgets/users_stats_header.dart';
import '../../../../config/responsive.dart';

class UsersPage extends ConsumerWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final responsive = context.responsive;
    final usersAsync = ref.watch(usersNotifierProvider);
    final filteredUsers = ref.watch(filteredUsersProvider);
    final searchQuery = ref.watch(usersSearchQueryProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: BaseAppBar(
        title: 'المستخدمون',
        onPressed: () => ref.read(usersNotifierProvider.notifier).refresh(),
        icon: Icons.refresh_rounded,
      ),
      body: usersAsync.when(
        loading: () => const EnhancedLoadingWidget(
          message: 'جاري تحميل بيانات المستخدمين...',
        ),
        error: (error, _) => Center(
          child: EnhancedErrorWidget(
            title: 'خطأ في تحميل المستخدمين',
            message: error.toString(),
            icon: Icons.error_outline,
            onRetry: () => ref.read(usersNotifierProvider.notifier).refresh(),
          ),
        ),
        data: (stats) {
          return Column(
            children: [
              TopSection(
                children: [
                  CustomSearchBar(
                    hintText: 'ابحث عن المستخدم بالاسم أو البريد الإلكتروني...',
                    padding: responsive.defaultPadding,
                    onSearch: (value) => ref
                        .read(usersSearchQueryProvider.notifier)
                        .setQuery(value),
                  ),
                  const UsersStatsHeader(),
                ],
              ),
              Expanded(
                child: filteredUsers.isEmpty
                    ? EnhancedErrorWidget(
                        title: 'لا يوجد مستخدمين',
                        message: searchQuery.isEmpty
                            ? 'لم يتم العثور على أي مستخدمين مسجلين'
                            : 'لا توجد نتائج لبحثك: "$searchQuery"',
                        icon: Icons.people_outline,
                        onRetry: () =>
                            ref.read(usersNotifierProvider.notifier).refresh(),
                      )
                    : MyRefreshIndicator(
                        onRefresh: () =>
                            ref.read(usersNotifierProvider.notifier).refresh(),
                        child: ListView.builder(
                          padding: responsive.defaultPadding,
                          itemCount: filteredUsers.length,
                          itemBuilder: (context, index) {
                            final user = filteredUsers[index];
                            return UserCard(user: user);
                          },
                        ),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
