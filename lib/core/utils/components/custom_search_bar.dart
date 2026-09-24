import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stronger_muscles_dashboard/config/responsive.dart';

/// شريط بحث تفاعلي متوافق بالكامل مع مواصفات وتصميم Material Design 3 (M3 SearchBar)
/// يعتمد على رموز ألوان وثيمات `ColorScheme` و `TextTheme` لدعم الوضعين الفاتح والداكن تلقائياً.
class CustomSearchBar extends StatefulWidget {
  final ValueChanged<String> onSearch;
  final String hintText;
  final EdgeInsets? padding;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final Widget? leading;
  final List<Widget>? trailing;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onClear;
  final bool autofocus;

  const CustomSearchBar({
    super.key,
    required this.onSearch,
    this.hintText = "ابحث هنا...",
    this.padding,
    this.controller,
    this.focusNode,
    this.leading,
    this.trailing,
    this.onSubmitted,
    this.onClear,
    this.autofocus = false,
  });

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  late final TextEditingController _textController;
  late final FocusNode _focusNode;
  bool _ownsController = false;
  bool _ownsFocusNode = false;
  bool _hasText = false;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      _textController = widget.controller!;
    } else {
      _textController = TextEditingController();
      _ownsController = true;
    }

    if (widget.focusNode != null) {
      _focusNode = widget.focusNode!;
    } else {
      _focusNode = FocusNode();
      _ownsFocusNode = true;
    }

    _hasText = _textController.text.isNotEmpty;
    _textController.addListener(_onTextChanged);
    _focusNode.addListener(_onFocusChanged);
  }

  void _onTextChanged() {
    final hasText = _textController.text.isNotEmpty;
    if (_hasText != hasText) {
      setState(() => _hasText = hasText);
    }
  }

  void _onFocusChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    _textController.removeListener(_onTextChanged);
    _focusNode.removeListener(_onFocusChanged);
    if (_ownsController) {
      _textController.dispose();
    }
    if (_ownsFocusNode) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _clearSearch() {
    _textController.clear();
    widget.onSearch('');
    widget.onClear?.call();
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final responsive = context.responsive;

    final isFocused = _focusNode.hasFocus;

    // حاوية خلفية بألوان M3 Surface Container
    final Color containerColor = isFocused
        ? colorScheme.surfaceContainerHighest
        : (_isHovered
            ? colorScheme.surfaceContainerHigh
            : colorScheme.surfaceContainer);

    // إطار متناسق مع معايير M3
    final Border border = Border.all(
      color: isFocused
          ? colorScheme.primary
          : (_isHovered
              ? colorScheme.outline.withValues(alpha: 0.6)
              : colorScheme.outlineVariant.withValues(alpha: 0.45)),
      width: isFocused ? 1.5 : 1.0,
    );

    // ظلال وظهور ناعم عند التركيز
    final List<BoxShadow> shadows = [
      if (isFocused)
        BoxShadow(
          color: colorScheme.primary.withValues(alpha: 0.12),
          blurRadius: 14,
          offset: const Offset(0, 3),
        )
      else
        BoxShadow(
          color: colorScheme.shadow.withValues(alpha: isDark ? 0.22 : 0.04),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
    ];

    Widget content = MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        height: 52,
        decoration: BoxDecoration(
          color: containerColor,
          borderRadius: BorderRadius.circular(28), // M3 Full Pill Shape
          border: border,
          boxShadow: shadows,
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(28),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 1. Leading Search Icon
              Padding(
                padding: const EdgeInsetsDirectional.only(start: 16, end: 8),
                child: widget.leading ??
                    Icon(
                      Icons.search_rounded,
                      size: 22,
                      color: isFocused
                          ? colorScheme.primary
                          : colorScheme.onSurfaceVariant,
                    ),
              ),

              // 2. TextField Input
              Expanded(
                child: CallbackShortcuts(
                  bindings: <ShortcutActivator, VoidCallback>{
                    const SingleActivator(LogicalKeyboardKey.escape): () {
                      if (_hasText) {
                        _clearSearch();
                      } else {
                        _focusNode.unfocus();
                      }
                    },
                  },
                  child: TextField(
                    controller: _textController,
                    focusNode: _focusNode,
                    autofocus: widget.autofocus,
                    onChanged: widget.onSearch,
                    onSubmitted: widget.onSubmitted,
                    cursorColor: colorScheme.primary,
                    cursorWidth: 2,
                    cursorRadius: const Radius.circular(2),
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.normal,
                    ),
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                      hintText: widget.hintText,
                      hintStyle: theme.textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurfaceVariant.withValues(alpha: 0.70),
                        fontWeight: FontWeight.normal,
                      ),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      filled: false,
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 4,
                      ),
                    ),
                  ),
                ),
              ),

              // 3. Clear Button (Trailing)
              AnimatedScale(
                scale: _hasText ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 150),
                child: AnimatedOpacity(
                  opacity: _hasText ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 150),
                  child: _hasText
                      ? Padding(
                          padding: const EdgeInsetsDirectional.only(end: 4),
                          child: IconButton(
                            icon: const Icon(Icons.close_rounded, size: 18),
                            tooltip: 'مسح البحث',
                            color: colorScheme.onSurfaceVariant,
                            splashRadius: 18,
                            onPressed: _clearSearch,
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              ),

              // 4. Any Additional Trailing Widgets
              if (widget.trailing != null && widget.trailing!.isNotEmpty) ...[
                ...widget.trailing!,
                const SizedBox(width: 8),
              ],
            ],
          ),
        ),
      ),
    );

    if (widget.padding != null) {
      return Padding(
        padding: widget.padding!,
        child: content,
      );
    }

    return content;
  }
}
