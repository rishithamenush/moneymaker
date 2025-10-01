import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/utils/theme_colors.dart';
import '../../../domain/entities/income.dart';
import '../../providers/theme_provider.dart';

class DeleteConfirmationDialog extends StatelessWidget {
  final dynamic transaction;
  final VoidCallback onConfirm;

  const DeleteConfirmationDialog({
    super.key,
    required this.transaction,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final isIncome = transaction is Income;
    final transactionType = isIncome ? 'Income' : 'Expense';
    final accentColor = ThemeColors.getAccentColor(context, context.read<ThemeProvider>().accentColor);
    final color = isIncome ? accentColor : AppColors.error;
    final icon = isIncome ? Icons.trending_up_rounded : Icons.trending_down_rounded;
    
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: ThemeColors.getSurface(context),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: ThemeColors.getBorder(context).withOpacity(0.1),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: accentColor.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Icon(
                Icons.delete_outline_rounded,
                color: accentColor,
                size: 32,
              ),
            ),
            const SizedBox(height: 20),
            
            // Title
            Text(
              'Delete $transactionType?',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: ThemeColors.getTextPrimary(context),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            
            // Description
            Text(
              'Are you sure you want to delete this $transactionType transaction?',
              style: TextStyle(
                fontSize: 14,
                color: ThemeColors.getTextSecondary(context),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            
            // Transaction Details Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: color.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      icon,
                      color: color,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          transaction.description,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: ThemeColors.getTextPrimary(context),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          Formatters.formatCurrency(transaction.amount, currencyCode: context.read<ThemeProvider>().currency),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: color,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: ThemeColors.getSurface(context),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: ThemeColors.getBorder(context).withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => Navigator.of(context).pop(),
                        borderRadius: BorderRadius.circular(12),
                        child: Center(
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: ThemeColors.getTextSecondary(context),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: accentColor,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: accentColor.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                          onConfirm();
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: const Center(
                          child: Text(
                            'Delete',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static void show(BuildContext context, {
    required dynamic transaction,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return DeleteConfirmationDialog(
          transaction: transaction,
          onConfirm: onConfirm,
        );
      },
    );
  }
}
