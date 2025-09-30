import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/dimensions.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/utils/theme_colors.dart';
import '../../../domain/entities/expense.dart';
import '../../../domain/entities/income.dart';
import '../../../domain/entities/category.dart';
import '../../providers/expense_provider.dart';
import '../../providers/income_provider.dart';
import '../../providers/category_provider.dart';
import '../../providers/theme_provider.dart';

enum TransactionType { income, expense }

class AddTransactionPage extends StatefulWidget {
  const AddTransactionPage({super.key});

  @override
  State<AddTransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  TransactionType _selectedType = TransactionType.expense;
  Category? _selectedCategory;
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CategoryProvider>().loadCategories();
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.getBackground(context),
      appBar: AppBar(
        title: const Text('Add Transaction'),
        backgroundColor: ThemeColors.getAccentColor(context, context.read<ThemeProvider>().accentColor),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.paddingM),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Transaction Type Selection
              _buildTypeSelector(),
              const SizedBox(height: AppDimensions.paddingL),
              
              // Amount Field
              _buildAmountField(),
              const SizedBox(height: AppDimensions.paddingM),
              
              // Category Field
              _buildCategoryField(),
              const SizedBox(height: AppDimensions.paddingM),
              
              // Date Field
              _buildDateField(),
              const SizedBox(height: AppDimensions.paddingM),
              
              // Description Field
              _buildDescriptionField(),
              const SizedBox(height: AppDimensions.paddingXL),
              
              // Save Button
              _buildSaveButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeSelector() {
    final l10n = AppLocalizations.of(context)!;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.type,
          style: AppTheme.lightTheme('Orange').textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: ThemeColors.getTextPrimary(context),
          ),
        ),
        const SizedBox(height: AppDimensions.paddingS),
        Row(
          children: [
            Expanded(
              child: _buildTypeOption(
                type: TransactionType.expense,
                title: l10n.expense,
                icon: Icons.trending_down,
                color: AppColors.error,
              ),
            ),
            const SizedBox(width: AppDimensions.paddingM),
            Expanded(
              child: _buildTypeOption(
                type: TransactionType.income,
                title: l10n.income,
                icon: Icons.trending_up,
                color: AppColors.success,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTypeOption({
    required TransactionType type,
    required String title,
    required IconData icon,
    required Color color,
  }) {
    final isSelected = _selectedType == type;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedType = type;
          _selectedCategory = null; // Reset category when type changes
        });
      },
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.paddingM),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : ThemeColors.getSurface(context),
          border: Border.all(
            color: isSelected ? color : ThemeColors.getSurfaceLight(context),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? color : ThemeColors.getTextSecondary(context),
              size: 32,
            ),
            const SizedBox(height: AppDimensions.paddingS),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? color : ThemeColors.getTextSecondary(context),
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountField() {
    final l10n = AppLocalizations.of(context)!;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${l10n.amount} (${context.read<ThemeProvider>().currency})',
          style: AppTheme.lightTheme('Orange').textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: ThemeColors.getTextPrimary(context),
          ),
        ),
        const SizedBox(height: AppDimensions.paddingS),
        TextFormField(
          controller: _amountController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: 'Enter amount',
            prefixText: '${CurrencyOptions.getCurrencySymbol(context.read<ThemeProvider>().currency)} ',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              borderSide: BorderSide(color: ThemeColors.getAccentColor(context, context.read<ThemeProvider>().accentColor)),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter an amount';
            }
            if (double.tryParse(value) == null) {
              return 'Please enter a valid amount';
            }
            if (double.parse(value) <= 0) {
              return 'Amount must be greater than 0';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildCategoryField() {
    final l10n = AppLocalizations.of(context)!;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.category,
          style: AppTheme.lightTheme('Orange').textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: ThemeColors.getTextPrimary(context),
          ),
        ),
        const SizedBox(height: AppDimensions.paddingS),
        Consumer<CategoryProvider>(
          builder: (context, categoryProvider, child) {
            return DropdownButtonFormField<Category>(
              value: _selectedCategory,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                  borderSide: BorderSide(color: ThemeColors.getAccentColor(context, context.read<ThemeProvider>().accentColor)),
                ),
              ),
              hint: const Text('Select category'),
              items: _getFilteredCategories(categoryProvider.categories).map((category) {
                return DropdownMenuItem<Category>(
                  value: category,
                  child: Row(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: Color(category.colorValue),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: AppDimensions.paddingS),
                      Text(category.name),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (Category? newValue) {
                setState(() {
                  _selectedCategory = newValue;
                });
              },
              validator: (value) {
                if (value == null) {
                  return 'Please select a category';
                }
                return null;
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildDateField() {
    final l10n = AppLocalizations.of(context)!;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.date,
          style: AppTheme.lightTheme('Orange').textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: ThemeColors.getTextPrimary(context),
          ),
        ),
        const SizedBox(height: AppDimensions.paddingS),
        GestureDetector(
          onTap: _selectDate,
          child: Container(
            padding: const EdgeInsets.all(AppDimensions.paddingM),
            decoration: BoxDecoration(
              border: Border.all(color: ThemeColors.getSurfaceLight(context)),
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: ThemeColors.getAccentColor(context, context.read<ThemeProvider>().accentColor),
                ),
                const SizedBox(width: AppDimensions.paddingS),
                Text(
                  Formatters.formatDate(_selectedDate),
                  style: const TextStyle(fontSize: 16),
                ),
                const Spacer(),
                Icon(
                  Icons.arrow_drop_down,
                  color: ThemeColors.getTextSecondary(context),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionField() {
    final l10n = AppLocalizations.of(context)!;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.description,
          style: AppTheme.lightTheme('Orange').textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: ThemeColors.getTextPrimary(context),
          ),
        ),
        const SizedBox(height: AppDimensions.paddingS),
        TextFormField(
          controller: _descriptionController,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'Enter transaction details',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              borderSide: BorderSide(color: ThemeColors.getAccentColor(context, context.read<ThemeProvider>().accentColor)),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter transaction details';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    final l10n = AppLocalizations.of(context)!;
    
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _saveTransaction,
        style: ElevatedButton.styleFrom(
          backgroundColor: ThemeColors.getAccentColor(context, context.read<ThemeProvider>().accentColor),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          ),
        ),
        child: _isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : Text(
                '${l10n.save} ${_selectedType == TransactionType.income ? l10n.income : l10n.expense}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _saveTransaction() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final amount = double.parse(_amountController.text);
      final description = _descriptionController.text;
      final category = _selectedCategory!;

      if (_selectedType == TransactionType.income) {
        // Save income
        final income = Income(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          amount: amount,
          description: description,
          categoryId: category.id,
          categoryName: category.name,
          date: _selectedDate,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        await context.read<IncomeProvider>().addIncome(income);
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Income added successfully!'),
            backgroundColor: AppColors.success,
          ),
        );
        
        Navigator.pop(context);
      } else {
        // Save expense
        final expense = Expense(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          amount: amount,
          description: description,
          categoryId: category.id,
          categoryName: category.name,
          date: _selectedDate,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        await context.read<ExpenseProvider>().addExpense(expense);
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Expense added successfully!'),
            backgroundColor: AppColors.success,
          ),
        );
        
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<Category> _getFilteredCategories(List<Category> allCategories) {
    if (_selectedType == TransactionType.income) {
      // Treat categories with id prefix 'income_' or specific defaults as income
      return allCategories.where((category) =>
        category.id == 'salary' || category.id.startsWith('income_')
      ).toList();
    } else {
      // Everything else is expense (exclude income prefixed ones)
      return allCategories.where((category) =>
        category.id != 'salary' && !category.id.startsWith('income_')
      ).toList();
    }
  }
}
