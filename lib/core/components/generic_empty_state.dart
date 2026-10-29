import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/core/theme/theme.dart';

class GenericEmptyState extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final VoidCallback? onAction;
  final String? actionLabel;
  final IconData actionIcon;
  final bool showGradient;

  const GenericEmptyState({
    super.key,
    required this.title,
    required this.message,
    this.icon = Icons.inbox_outlined,
    this.onAction,
    this.actionLabel,
    this.actionIcon = Icons.clear_rounded,
    this.showGradient = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDesignTokens.space32),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(AppDesignTokens.space32),
                decoration: BoxDecoration(
                  gradient: showGradient
                      ? LinearGradient(
                          colors: [
                            colorScheme.onSurface.withValues(alpha: 0.08),
                            colorScheme.onSurface.withValues(alpha: 0.02),
                          ],
                        )
                      : null,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 80,
                  color: colorScheme.onSurface.withValues(alpha: 0.3),
                ),
              ),
              const SizedBox(height: AppDesignTokens.space24),
              Text(
                title,
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: AppDesignTokens.space12),
              Text(
                message,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              if (onAction != null && actionLabel != null) ...[
                const SizedBox(height: AppDesignTokens.space24),
                TextButton.icon(
                  onPressed: onAction,
                  icon: Icon(actionIcon),
                  label: Text(actionLabel!),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
