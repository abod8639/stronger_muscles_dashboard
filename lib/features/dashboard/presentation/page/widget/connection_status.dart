import 'package:flutter/material.dart';
import '../../../config/theme.dart';

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
      color: isConnected
          ? AppColors.warning.withValues(alpha: 0.1)
          : AppColors.error.withValues(alpha: 0.1),
      child: Row(
        children: [
          Icon(
            isConnected ? Icons.warning_amber : Icons.error_outline,
            color: isConnected ? AppColors.warning : AppColors.error,
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
                    color: isConnected ? AppColors.warning : AppColors.error,
                    fontSize: 13,
                  ),
                ),
                if (errorMessage != null && errorMessage!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    errorMessage!,
                    style: TextStyle(
                      color: isConnected ? AppColors.warning : AppColors.error,
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isConnected ? AppColors.warning : AppColors.error,
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
