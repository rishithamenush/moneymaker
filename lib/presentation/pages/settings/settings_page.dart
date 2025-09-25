import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/dimensions.dart';
import '../../providers/theme_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/category_provider.dart';
import '../../../domain/entities/category.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../navigation/bottom_nav_bar.dart';
import '../../../app/routes.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(
        title: 'Settings',
        showBackButton: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppDimensions.paddingM),
        children: [
          // Account Section
          _buildSectionHeader('Account'),
          _buildSettingsCard([
            _buildSettingsItem(
              icon: Icons.logout,
              title: 'Logout',
              subtitle: 'Sign out of your account',
              onTap: () => _showLogoutDialog(),
              isDestructive: true,
            ),
          ]),
          
          const SizedBox(height: AppDimensions.paddingL),
          
          // Categories Section
          _buildSectionHeader('Categories'),
          _buildSettingsCard([
            _buildSettingsItem(
              icon: Icons.category,
              title: 'Customize Categories',
              subtitle: 'Add, rename, or delete your own categories',
              onTap: () => _openCategoryManager(),
            ),
          ]),

          const SizedBox(height: AppDimensions.paddingL),

          // Appearance Section
          _buildSectionHeader('Appearance'),
          _buildSettingsCard([
            _buildThemeToggle(),
            _buildDivider(),
            _buildSettingsItem(
              icon: Icons.palette,
              title: 'Accent Color',
              subtitle: 'Choose your preferred accent color',
              onTap: () => _showAccentColorDialog(),
            ),
          ]),
          
          const SizedBox(height: AppDimensions.paddingL),
          
          // Currency & Formatting Section
          _buildSectionHeader('Currency & Formatting'),
          _buildSettingsCard([
            _buildSettingsItem(
              icon: Icons.attach_money,
              title: 'Currency',
              subtitle: 'LKR (Sri Lankan Rupee)',
              onTap: () => _showCurrencyDialog(),
            ),
            _buildDivider(),
            _buildSettingsItem(
              icon: Icons.format_list_numbered,
              title: 'Number Format',
              subtitle: 'Decimal places and separators',
              onTap: () => _showNumberFormatDialog(),
            ),
          ]),
          
          const SizedBox(height: AppDimensions.paddingL),
          
          // Data Management Section
          _buildSectionHeader('Data Management'),
          _buildSettingsCard([
            _buildSettingsItem(
              icon: Icons.download,
              title: 'Export Data',
              subtitle: 'Export your transactions to CSV',
              onTap: () => _exportData(),
            ),
            _buildDivider(),
            _buildSettingsItem(
              icon: Icons.upload,
              title: 'Import Data',
              subtitle: 'Import transactions from CSV',
              onTap: () => _importData(),
            ),
            _buildDivider(),
            _buildSettingsItem(
              icon: Icons.delete_forever,
              title: 'Clear All Data',
              subtitle: 'Permanently delete all transactions',
              onTap: () => _showClearDataDialog(),
              isDestructive: true,
            ),
          ]),
          
          const SizedBox(height: AppDimensions.paddingL),
          
          // Notifications Section
          _buildSectionHeader('Notifications'),
          _buildSettingsCard([
            _buildSettingsItem(
              icon: Icons.notifications,
              title: 'Budget Alerts',
              subtitle: 'Get notified when approaching budget limits',
              trailing: Switch(
                value: true,
                onChanged: (value) => _toggleBudgetAlerts(value),
                activeColor: AppColors.primary,
              ),
            ),
            _buildDivider(),
            _buildSettingsItem(
              icon: Icons.schedule,
              title: 'Daily Reminders',
              subtitle: 'Remind me to log daily expenses',
              trailing: Switch(
                value: false,
                onChanged: (value) => _toggleDailyReminders(value),
                activeColor: AppColors.primary,
              ),
            ),
          ]),
          
          const SizedBox(height: AppDimensions.paddingL),
          
          // About Section
          _buildSectionHeader('About'),
          _buildSettingsCard([
            _buildSettingsItem(
              icon: Icons.info,
              title: 'App Version',
              subtitle: '1.0.0',
              onTap: () => _showAboutDialog(),
            ),
            _buildDivider(),
            _buildSettingsItem(
              icon: Icons.privacy_tip,
              title: 'Privacy Policy',
              subtitle: 'How we handle your data',
              onTap: () => _showPrivacyPolicy(),
            ),
            _buildDivider(),
            _buildSettingsItem(
              icon: Icons.description,
              title: 'Terms of Service',
              subtitle: 'Terms and conditions',
              onTap: () => _showTermsOfService(),
            ),
          ]),
          
          const SizedBox(height: AppDimensions.paddingXL),
        ],
      ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 2),
    );
  }

  bool _isIncomeCategory(Category category) {
    // Heuristic: ids we seeded for income start with 'salary' or 'income_' prefix
    return category.id == 'salary' || category.id.startsWith('income_');
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.paddingS),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildSettingsCard(List<Widget> children) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
    Widget? trailing,
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive ? AppColors.error : AppColors.primary,
        size: 24,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: isDestructive ? AppColors.error : AppColors.textPrimary,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 12,
        ),
      ),
      trailing: trailing ?? const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: AppColors.textSecondary,
      ),
      onTap: onTap,
    );
  }

  Widget _buildDivider() {
    return const Divider(
      height: 1,
      thickness: 1,
      indent: 56,
      color: AppColors.surfaceLight,
    );
  }

  Widget _buildThemeToggle() {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return ListTile(
          leading: Icon(
            themeProvider.themeMode == ThemeMode.dark
                ? Icons.dark_mode
                : Icons.light_mode,
            color: AppColors.primary,
            size: 24,
          ),
          title: const Text(
            'Theme',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          subtitle: Text(
            themeProvider.themeMode == ThemeMode.dark
                ? 'Dark Mode'
                : themeProvider.themeMode == ThemeMode.light
                    ? 'Light Mode'
                    : 'System Default',
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
          trailing: DropdownButton<ThemeMode>(
            value: themeProvider.themeMode,
            underline: const SizedBox(),
            items: const [
              DropdownMenuItem(
                value: ThemeMode.light,
                child: Text('Light'),
              ),
              DropdownMenuItem(
                value: ThemeMode.dark,
                child: Text('Dark'),
              ),
              DropdownMenuItem(
                value: ThemeMode.system,
                child: Text('System'),
              ),
            ],
            onChanged: (ThemeMode? newValue) {
              if (newValue != null) {
                themeProvider.setThemeMode(newValue);
              }
            },
          ),
        );
      },
    );
  }

  void _showAccentColorDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose Accent Color'),
        content: const Text('Accent color selection coming soon!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _openCategoryManager() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return const _CategoryManagerSheet();
      },
    );
  }

  void _showCurrencyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Currency Settings'),
        content: const Text('Currency selection coming soon! Currently using LKR.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showNumberFormatDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Number Format'),
        content: const Text('Number formatting options coming soon!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _exportData() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Export feature coming soon!'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _importData() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Import feature coming soon!'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _showClearDataDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Data'),
        content: const Text(
          'This will permanently delete all your transactions, budgets, and categories. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _clearAllData();
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Delete All'),
          ),
        ],
      ),
    );
  }

  void _clearAllData() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Clear data feature coming soon!'),
        backgroundColor: AppColors.warning,
      ),
    );
  }

  void _toggleBudgetAlerts(bool value) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Budget alerts ${value ? 'enabled' : 'disabled'}'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _toggleDailyReminders(bool value) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Daily reminders ${value ? 'enabled' : 'disabled'}'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _showAboutDialog() {
    showAboutDialog(
      context: context,
      applicationName: 'Money Maker',
      applicationVersion: '1.0.0',
      applicationIcon: const Icon(
        Icons.account_balance_wallet,
        size: 48,
        color: AppColors.primary,
      ),
      children: [
        const Text('A simple and elegant money management app to help you track your income and expenses.'),
        const SizedBox(height: 16),
        const Text('Features:'),
        const Text('• Track income and expenses'),
        const Text('• Monthly and daily views'),
        const Text('• Category management'),
        const Text('• Dark/Light theme support'),
      ],
    );
  }

  void _showPrivacyPolicy() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Privacy Policy'),
        content: const SingleChildScrollView(
          child: Text(
            'Your privacy is important to us. All your data is stored locally on your device and is not shared with any third parties.\n\n'
            'We do not collect, store, or transmit any personal information. Your financial data remains private and secure on your device.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showTermsOfService() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Terms of Service'),
        content: const SingleChildScrollView(
          child: Text(
            'By using Money Maker, you agree to the following terms:\n\n'
            '1. This app is provided "as is" without warranties.\n'
            '2. You are responsible for backing up your data.\n'
            '3. We are not liable for any data loss.\n'
            '4. You may not reverse engineer or redistribute this app.\n\n'
            'These terms may be updated from time to time.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _logout();
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  void _logout() async {
    try {
      final authProvider = context.read<AuthProvider>();
      await authProvider.logout();
      
      if (mounted) {
        // Navigate to login screen and clear all previous routes
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.login,
          (route) => false,
        );
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Logged out successfully'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Logout failed: ${e.toString()}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }
}

class _CategoryManagerSheet extends StatefulWidget {
  const _CategoryManagerSheet();

  @override
  State<_CategoryManagerSheet> createState() => _CategoryManagerSheetState();
}

class _CategoryManagerSheetState extends State<_CategoryManagerSheet> {
  final TextEditingController _nameController = TextEditingController();
  Color _selectedColor = const Color(0xFFFF6B35);
  bool _isIncome = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.6,
      maxChildSize: 0.95,
      builder: (context, controller) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            children: [
              Container(
                width: 36,
                height: 4,
                margin: const EdgeInsets.only(top: 8, bottom: 12),
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                child: Text(
                  'Customize Categories',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                ),
              ),
              Expanded(
                child: Consumer<CategoryProvider>(
                  builder: (context, provider, _) {
                    final categories = provider.categories;
                    return ListView.builder(
                      controller: controller,
                      itemCount: categories.length + 1,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return _buildAddRow(context);
                        }
                        final category = categories[index - 1];
                        final isIncome = _isIncomeCategory(category);
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Color(category.colorValue),
                            child: const Icon(Icons.label, color: Colors.white, size: 18),
                          ),
                          title: Text(category.name, style: const TextStyle(color: AppColors.textPrimary)),
                          subtitle: Text(isIncome ? 'Income' : 'Expense', style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline, color: AppColors.error),
                            onPressed: () => context.read<CategoryProvider>().deleteCategory(category.id),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Determine if a category is an income category
  bool _isIncomeCategory(Category category) {
    return category.id == 'salary' || category.id.startsWith('income_');
  }

  Widget _buildAddRow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: Row(
        children: [
          ToggleButtons(
            isSelected: [_isIncome == false, _isIncome == true],
            borderRadius: BorderRadius.circular(8),
            constraints: const BoxConstraints(minHeight: 36, minWidth: 72),
            selectedColor: Colors.white,
            fillColor: AppColors.primary,
            onPressed: (index) {
              setState(() {
                _isIncome = index == 1;
              });
            },
            children: const [
              Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: Text('Expense')),
              Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: Text('Income')),
            ],
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                hintText: 'New category name',
              ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 32,
            height: 32,
            child: GestureDetector(
            onTap: () async {
              final color = await showDialog<Color>(
                context: context,
                builder: (context) => _SimpleColorPicker(initial: _selectedColor),
              );
              if (color != null) {
                setState(() {
                  _selectedColor = color;
                });
              }
            },
            child: Container(
              decoration: BoxDecoration(
                color: _selectedColor,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: AppColors.surfaceLight),
              ),
            ),
          )),
          const SizedBox(width: 8),
          SizedBox(
            height: 40,
            width: 72,
            child: ElevatedButton(
              onPressed: () {
              final name = _nameController.text.trim();
              if (name.isEmpty) return;
              final prefix = _isIncome ? 'income_' : 'expense_';
              final category = Category(
                id: '${prefix}${DateTime.now().millisecondsSinceEpoch}',
                name: name,
                iconName: 'label',
                colorValue: _selectedColor.value,
                isDefault: false,
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
              );
              context.read<CategoryProvider>().addCategory(category);
              _nameController.clear();
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(72, 40),
                padding: EdgeInsets.zero,
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: const Text('Add'),
            ),
          ),
        ],
      ),
    );
  }
}

class _SimpleColorPicker extends StatelessWidget {
  final Color initial;
  const _SimpleColorPicker({required this.initial});

  @override
  Widget build(BuildContext context) {
    final colors = [
      const Color(0xFFFF6B35),
      const Color(0xFFFF8E53),
      const Color(0xFF4CAF50),
      const Color(0xFF2196F3),
      const Color(0xFF9C27B0),
      const Color(0xFFE91E63),
      const Color(0xFF00BCD4),
      const Color(0xFF795548),
      const Color(0xFF607D8B),
    ];
    Color selected = initial;
    return AlertDialog(
      title: const Text('Pick a color'),
      content: StatefulBuilder(
        builder: (context, setState) {
          return Wrap(
            spacing: 8,
            runSpacing: 8,
            children: colors.map((c) {
              final isSel = c.value == selected.value;
              return GestureDetector(
                onTap: () => setState(() => selected = c),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: c,
                    shape: BoxShape.circle,
                    border: Border.all(color: isSel ? Colors.white : Colors.transparent, width: 2),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 2)),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        TextButton(onPressed: () => Navigator.pop(context, selected), child: const Text('Select')),
      ],
    );
  }
}
