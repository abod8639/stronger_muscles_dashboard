
  import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/config/responsive.dart';
import 'package:stronger_muscles_dashboard/config/theme.dart';

Widget buildActionButtons( {
  required Function() onEdit, 
  required Function() onDelete,
  required bool isHovered,
  }) {
    
    return Builder(
      builder: (context) {
        final responsive = context.responsive;
        return AnimatedOpacity(
          opacity: isHovered ? 1 : 0.5,
          duration: const Duration(milliseconds: 300),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // زر التعديل
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withValues(alpha: 0.2),
                      blurRadius: 8,
                      spreadRadius: isHovered ? 2 : 0,
                    ),
                  ],
                ),
                child: Material(
                  shape: const CircleBorder(),
                  color: Colors.blue.withValues(alpha: 0.1),
                  child: IconButton(
                    onPressed: onEdit,
                    icon: Icon(
                      Icons.edit_outlined,
                      size: responsive.iconSize,
                      color: Colors.blue,
                    ),
                    padding: EdgeInsets.all(responsive.itemSpacing / 2),
                  ),
                ),
              ),
              SizedBox(height: responsive.itemSpacing / 2),
        
              // زر الحذف
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.danger.withValues(alpha: 0.2),
                      blurRadius: 8,
                      spreadRadius: isHovered ? 2 : 0,
                    ),
                  ],
                ),
                child: Material(
                  shape: const CircleBorder(),
                  color: AppColors.danger.withValues(alpha: 0.1),
                  child: IconButton(
                    onPressed: onDelete,
                    icon: Icon(
                      Icons.delete_outline,
                      size: responsive.iconSize,
                      color: AppColors.danger,
                    ),
                    padding: EdgeInsets.all(responsive.itemSpacing / 2),
                  ),
                ),
              ),
            ],
          ),
        );
      }
    );
  }

