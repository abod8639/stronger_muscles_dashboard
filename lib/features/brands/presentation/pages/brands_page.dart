import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/brands_providers.dart';
import '../controllers/brands_state.dart';
import '../widgets/brand_card.dart';
import '../widgets/brand_error_view.dart';
import '../widgets/brand_search_bar.dart';

/// Dumb Presentation Page for Browsing and Searching Brands.
/// Employs selective listening via `.select()` to prevent whole-screen rebuilds.
class BrandsPage extends ConsumerStatefulWidget {
  const BrandsPage({super.key});

  @override
  ConsumerState<BrandsPage> createState() => _BrandsPageState();
}

class _BrandsPageState extends ConsumerState<BrandsPage> {
  late final TextEditingController _searchController;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      ref.read(brandsNotifierProvider.notifier).searchBrands(query);
    });
  }

  void _onClearSearch() {
    _searchController.clear();
    ref.read(brandsNotifierProvider.notifier).clearSearch();
  }

  @override
  Widget build(BuildContext context) {
    // final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('العلامات التجارية'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'تحديث',
            onPressed: () {
              ref.read(brandsNotifierProvider.notifier).loadBrands(forceRefresh: true);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: BrandSearchBar(
              controller: _searchController,
              onChanged: _onSearchChanged,
              onClear: _onClearSearch,
            ),
          ),

          // Main Content with selective status listening
          Expanded(
            child: Consumer(
              builder: (context, ref, child) {
                final status = ref.watch(
                  brandsNotifierProvider.select((s) => s.status),
                );

                if (status == BrandsStatus.loading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (status == BrandsStatus.failure) {
                  final failure = ref.watch(
                    brandsNotifierProvider.select((s) => s.failure),
                  );
                  if (failure != null) {
                    return BrandErrorView(
                      failure: failure,
                      onRetry: () {
                        ref
                            .read(brandsNotifierProvider.notifier)
                            .loadBrands(forceRefresh: true);
                      },
                    );
                  }
                }

                return const _BrandsGridSection();
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Selective grid rendering only rebuilding when the filtered list or selection changes
class _BrandsGridSection extends ConsumerWidget {
  const _BrandsGridSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final brands = ref.watch(
      brandsNotifierProvider.select((s) => s.filteredBrands),
    );
    final selectedId = ref.watch(
      brandsNotifierProvider.select((s) => s.selectedBrandId),
    );
    final isRefreshing = ref.watch(
      brandsNotifierProvider.select((s) => s.isRefreshing),
    );

    if (brands.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 54,
              color: Colors.grey.withValues(alpha: 0.6),
            ),
            const SizedBox(height: 12),
            const Text(
              'لا توجد علامات تجارية مطابقة',
              style: TextStyle(fontSize: 15, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        await ref
            .read(brandsNotifierProvider.notifier)
            .loadBrands(forceRefresh: true);
      },
      child: Stack(
        children: [
          GridView.builder(
            padding: const EdgeInsets.all(16),
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 220,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.9,
            ),
            itemCount: brands.length,
            itemBuilder: (context, index) {
              final brand = brands[index];
              final isSelected = brand.id == selectedId;

              return BrandCard(
                brand: brand,
                isSelected: isSelected,
                onTap: () {
                  ref
                      .read(brandsNotifierProvider.notifier)
                      .selectBrand(isSelected ? null : brand.id);
                },
              );
            },
          ),
          if (isRefreshing)
            const Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: LinearProgressIndicator(minHeight: 2),
            ),
        ],
      ),
    );
  }
}
