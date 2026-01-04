import 'package:flutter/material.dart';
import '../config/theme.dart';

class ConnectionStatusBar extends StatelessWidget {
  final bool isConnected;
  final String? errorMessage;
  final VoidCallback? onRetry;

  const ConnectionStatusBar({
    super.key,
    required this.isConnected,
    this.errorMessage,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    if (isConnected && (errorMessage == null || errorMessage!.isEmpty)) {
      return const SizedBox.shrink();
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(12),
      color: isConnected ? AppColors.warning.withValues(alpha: 0.1) : AppColors.danger.withValues(alpha: 0.1),
      child: Row(
        children: [
          Icon(
            isConnected ? Icons.warning_amber : Icons.error_outline,
            color: isConnected ? AppColors.warning : AppColors.danger,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isConnected ? 'تحذير' : 'خطأ في الاتصال',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isConnected ? AppColors.warning : AppColors.danger,
                    fontSize: 13,
                  ),
                ),
                if (errorMessage != null && errorMessage!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    errorMessage!,
                    style: TextStyle(
                      color: isConnected ? AppColors.warning : AppColors.danger,
                      fontSize: 12,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          if (onRetry != null) ...[
            const SizedBox(width: 12),
            GestureDetector(
              onTap: onRetry,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isConnected ? AppColors.warning : AppColors.danger,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'إعادة محاولة',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class ErrorScreen extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback onRetry;
  final IconData icon;

  const ErrorScreen({
    super.key,
    required this.title,
    required this.message,
    required this.onRetry,
    this.icon = Icons.error_outline,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 64,
              color: AppColors.danger,
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textLight,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('إعادة محاولة'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NoDataScreen extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;

  const NoDataScreen({
    super.key,
    required this.title,
    required this.message,
    this.icon = Icons.inbox_outlined,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 64,
              color: AppColors.textMuted,
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textLight,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
