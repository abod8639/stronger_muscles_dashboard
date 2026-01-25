import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/components/glass_container.dart';
import 'package:stronger_muscles_dashboard/config/responsive.dart';
import 'package:stronger_muscles_dashboard/config/theme.dart';

class CustomSearchBar extends StatefulWidget {
  final Function(String) onSearch;
  final String hintText;
  final EdgeInsets? padding;

  const CustomSearchBar({
    super.key,
    required this.onSearch,
    this.hintText = "ابحث هنا...",
    this.padding,
  });

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _textController.addListener(() {
      setState(() => _hasText = _textController.text.isNotEmpty);
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: widget.padding ?? EdgeInsets.all(responsive.defaultPadding.left),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          boxShadow: _focusNode.hasFocus
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.1),
                    blurRadius: 15,
                    spreadRadius: 2,
                  ),
                ]
              : [],
        ),
        child: GlassContainer(
          opacity: 0.08,
          blur: 15,
          borderRadius: BorderRadius.circular(16),
          child: TextField(
            controller: _textController,
            focusNode: _focusNode,
            onChanged: widget.onSearch,
            cursorColor: AppColors.primary,
            style: TextStyle(
              color: isDark ? Colors.white : AppColors.textMuted,
              fontSize: responsive.getBodyFontSize(),
            ),
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: TextStyle(
                color: isDark ? Colors.white54 : Colors.grey.shade500,
                fontSize: responsive.getBodyFontSize(),
              ),
              prefixIcon: Icon(
                Icons.search_rounded,
                color: _focusNode.hasFocus ? AppColors.primary : Colors.grey,
                size: responsive.iconSize,
              ),
              suffixIcon: _hasText
                  ? IconButton(
                      icon: const Icon(Icons.close_rounded, size: 20),
                      onPressed: () {
                        _textController.clear();
                        widget.onSearch('');
                      },
                    )
                  : null,
              filled: true,
              fillColor: Colors.transparent,
              border: InputBorder.none, // نعتمد على GlassContainer في الشكل
              contentPadding: const EdgeInsets.symmetric(
                vertical: 15,
                horizontal: 20,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.white.withOpacity(0.05)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: AppColors.primary.withOpacity(0.5),
                  width: 1.5,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
