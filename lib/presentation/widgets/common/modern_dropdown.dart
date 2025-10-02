import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/utils/theme_colors.dart';
import '../../providers/theme_provider.dart';

class ModernDropdown<T> extends StatelessWidget {
  final T value;
  final List<ModernDropdownItem<T>> items;
  final ValueChanged<T> onChanged;
  final String? hint;
  final double? width;
  final double height;

  const ModernDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    this.hint,
    this.width,
    this.height = 38,
  });

  @override
  Widget build(BuildContext context) {
    final selectedItem = items.firstWhere((item) => item.value == value);
    
    return LayoutBuilder(
      builder: (context, constraints) {
        final dropdownWidth = width ?? constraints.maxWidth;
        
        return PopupMenuButton<T>(
          initialValue: value,
          child: Container(
            height: height,
            width: dropdownWidth,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: ThemeColors.getSurface(context),
              border: Border.all(color: ThemeColors.getBorder(context).withOpacity(0.3)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    selectedItem.label,
                    style: TextStyle(
                      fontSize: 13,
                      color: ThemeColors.getTextPrimary(context),
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down,
                  color: ThemeColors.getTextSecondary(context),
                  size: 20,
                ),
              ],
            ),
          ),
          offset: const Offset(0, 42),
          elevation: 8,
          color: ThemeColors.getSurface(context),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          constraints: BoxConstraints(
            maxHeight: 300,
            minWidth: dropdownWidth,
            maxWidth: dropdownWidth,
          ),
          itemBuilder: (context) => items.map((item) => PopupMenuItem<T>(
            value: item.value,
            child: Row(
              children: [
                if (item.icon != null) ...[
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: ThemeColors.getAccentColor(context, context.read<ThemeProvider>().accentColor).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Icon(
                      item.icon!,
                      size: 14,
                      color: ThemeColors.getAccentColor(context, context.read<ThemeProvider>().accentColor),
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        item.label,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: ThemeColors.getTextPrimary(context),
                        ),
                      ),
                      if (item.description != null) ...[
                        Text(
                          item.description!,
                          style: TextStyle(
                            fontSize: 11,
                            color: ThemeColors.getTextSecondary(context),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          )).toList(),
          onSelected: onChanged,
        );
      },
    );
  }
}

class ModernDropdownItem<T> {
  final T value;
  final String label;
  final String? description;
  final IconData? icon;

  const ModernDropdownItem({
    required this.value,
    required this.label,
    this.description,
    this.icon,
  });
}
