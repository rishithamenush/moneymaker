import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/dimensions.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/utils/theme_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../../providers/theme_provider.dart';
import '../../providers/budget_provider.dart';
import '../../../domain/entities/budget.dart';

class MonthlySummary extends StatelessWidget {
  final double totalSpent;
  final double totalBudget;
  final double remainingAmount;
  final double spentPercentage;
  final DateTime selectedMonth;

  const MonthlySummary({
    super.key,
    required this.totalSpent,
    required this.totalBudget,
    required this.remainingAmount,
    required this.spentPercentage,
    required this.selectedMonth,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isOverBudget = totalSpent > totalBudget;
    final progressColor = isOverBudget ? AppColors.error : ThemeColors.getAccentColor(context, context.read<ThemeProvider>().accentColor);
    
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingL),
      decoration: BoxDecoration(
        color: ThemeColors.getSurface(context),
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.monthlySummary,
                style: TextStyle(
                  color: ThemeColors.getTextPrimary(context),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingM,
                  vertical: AppDimensions.paddingS,
                ),
                decoration: BoxDecoration(
                  color: progressColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                ),
                child: Text(
                  Formatters.formatPercentage(spentPercentage),
                  style: TextStyle(
                    color: progressColor,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: AppDimensions.paddingL),
          
          // Total Spent
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.totalSpent,
                      style: TextStyle(
                        color: ThemeColors.getTextSecondary(context),
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.paddingXS),
                    Text(
                      Formatters.formatCurrency(totalSpent, currencyCode: context.read<ThemeProvider>().currency),
                      style: TextStyle(
                        color: ThemeColors.getTextPrimary(context),
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      l10n.remaining,
                      style: TextStyle(
                        color: ThemeColors.getTextSecondary(context),
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.paddingXS),
                    Text(
                      Formatters.formatCurrency(remainingAmount, currencyCode: context.read<ThemeProvider>().currency),
                      style: TextStyle(
                        color: isOverBudget ? AppColors.error : ThemeColors.getTextPrimary(context),
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: AppDimensions.paddingL),
          
          // Progress Bar
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.budgetProgress,
                    style: TextStyle(
                      color: ThemeColors.getTextSecondary(context),
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    '${Formatters.formatCurrency(totalSpent, currencyCode: context.read<ThemeProvider>().currency)} / ${Formatters.formatCurrency(totalBudget, currencyCode: context.read<ThemeProvider>().currency)}',
                    style: TextStyle(
                      color: ThemeColors.getTextSecondary(context),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.paddingS),
              ClipRRect(
                borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                child: LinearProgressIndicator(
                  value: spentPercentage.clamp(0.0, 1.0),
                  backgroundColor: ThemeColors.getSurfaceLight(context),
                  valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                  minHeight: 8,
                ),
              ),
            ],
          ),
          
          // Set Budget Button (when no budget is set or when over budget)
          if (totalBudget == 0 || isOverBudget) ...[
            const SizedBox(height: AppDimensions.paddingM),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _showSetBudgetDialog(context),
                icon: const Icon(Icons.account_balance_wallet_outlined, size: 18),
                label: Text(
                  totalBudget == 0 ? l10n.setBudget : l10n.updateBudget,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: ThemeColors.getAccentColor(context, context.read<ThemeProvider>().accentColor),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: AppDimensions.paddingM),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                  ),
                ),
              ),
            ),
          ],

          if (isOverBudget) ...[
            const SizedBox(height: AppDimensions.paddingM),
            Container(
              padding: const EdgeInsets.all(AppDimensions.paddingM),
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                border: Border.all(
                  color: AppColors.error.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.warning,
                    color: AppColors.error,
                    size: 20,
                  ),
                  const SizedBox(width: AppDimensions.paddingS),
                  Expanded(
                    child: Text(
                      '${l10n.budgetExceeded} ${Formatters.formatCurrency(totalSpent - totalBudget, currencyCode: context.read<ThemeProvider>().currency)}',
                      style: const TextStyle(
                        color: AppColors.error,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showSetBudgetDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final budgetProvider = context.read<BudgetProvider>();
    final themeProvider = context.read<ThemeProvider>();
    final accentColor = ThemeColors.getAccentColor(context, themeProvider.accentColor);
    
    final TextEditingController amountController = TextEditingController();
    final FocusNode amountFocusNode = FocusNode();

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l10n.setMonthlyBudget,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: ThemeColors.getTextPrimary(context),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: ThemeColors.getTextSecondary(context)),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.setMonthlyBudgetDescription,
                  style: TextStyle(
                    fontSize: 14,
                    color: ThemeColors.getTextSecondary(context),
                  ),
                ),
                const SizedBox(height: 24),

                // Amount Input
                Text(
                  l10n.budgetAmount,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: ThemeColors.getTextPrimary(context),
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: amountController,
                  focusNode: amountFocusNode,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: '0.00',
                    prefixText: '${CurrencyOptions.getCurrencySymbol(themeProvider.currency)} ',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: ThemeColors.getBorder(context).withOpacity(0.3),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: accentColor, width: 2),
                    ),
                    filled: true,
                    fillColor: ThemeColors.getSurfaceLight(context),
                  ),
                  style: TextStyle(
                    color: ThemeColors.getTextPrimary(context),
                    fontSize: 16,
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
                            onTap: () => Navigator.pop(context),
                            borderRadius: BorderRadius.circular(12),
                            child: Center(
                              child: Text(
                                l10n.cancel,
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
                            onTap: () async {
                              final amount = double.tryParse(amountController.text);
                              if (amount != null && amount > 0) {
                                // Create a general monthly budget
                                final budget = Budget(
                                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                                  amount: amount,
                                  categoryId: 'general', // General monthly budget
                                  categoryName: 'Monthly Budget',
                                  month: selectedMonth,
                                  spentAmount: 0.0,
                                  createdAt: DateTime.now(),
                                  updatedAt: DateTime.now(),
                                );
                                
                                await budgetProvider.createBudget(budget);
                                if (context.mounted) {
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(l10n.budgetSetSuccessfully),
                                      backgroundColor: accentColor,
                                    ),
                                  );
                                }
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(l10n.pleaseEnterValidAmount),
                                    backgroundColor: AppColors.error,
                                  ),
                                );
                              }
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: Center(
                              child: Text(
                                l10n.setBudget,
                                style: const TextStyle(
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
      },
    );
  }
}
