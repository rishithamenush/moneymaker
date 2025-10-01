import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/dimensions.dart';
import '../../../core/utils/theme_colors.dart';
import '../../providers/theme_provider.dart';
import '../../providers/language_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/category_provider.dart';
import '../../../domain/entities/category.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/common/settings_popup.dart';
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
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      backgroundColor: ThemeColors.getBackground(context),
      appBar: CustomAppBar(
        title: l10n.settings,
        showBackButton: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppDimensions.paddingM),
        children: [
          // Categories Section
          _buildSectionHeader(l10n.category),
          _buildSettingsCard([
            _buildSettingsItem(
              icon: Icons.category,
              title: l10n.customizeCategories,
              subtitle: l10n.addRenameDeleteCategories,
              onTap: () => _openCategoryManager(),
            ),
          ]),

          const SizedBox(height: AppDimensions.paddingL),

          // Appearance Section
          _buildSectionHeader(l10n.appearance),
          _buildSettingsCard([
            _buildThemeToggle(),
            _buildDivider(),
            Consumer<ThemeProvider>(
              builder: (context, themeProvider, child) {
                return _buildSettingsItem(
                  icon: Icons.palette,
                  title: l10n.accentColor,
                  subtitle: themeProvider.accentColor,
                  onTap: () => _showAccentColorDialog(),
                );
              },
            ),
            _buildDivider(),
            Consumer<LanguageProvider>(
              builder: (context, languageProvider, child) {
                return _buildSettingsItem(
                  icon: Icons.language,
                  title: l10n.language,
                  subtitle: languageProvider.currentLanguageName,
                  onTap: () => _showLanguageDialog(),
                );
              },
            ),
          ]),
          
          const SizedBox(height: AppDimensions.paddingL),
          
          // Currency & Formatting Section
          _buildSectionHeader(l10n.currencyFormatting),
          _buildSettingsCard([
            Consumer<ThemeProvider>(
              builder: (context, themeProvider, child) {
                return _buildSettingsItem(
                  icon: Icons.attach_money,
                  title: l10n.currency,
                  subtitle: '${themeProvider.currency} (${CurrencyOptions.getCurrencyName(themeProvider.currency)})',
                  onTap: () => _showCurrencyDialog(),
                );
              },
            ),
            _buildDivider(),
            _buildSettingsItem(
              icon: Icons.format_list_numbered,
              title: l10n.numberFormat,
              subtitle: l10n.decimalPlacesSeparators,
              onTap: () => _showNumberFormatDialog(),
            ),
          ]),
          
          const SizedBox(height: AppDimensions.paddingL),
          
          // Data Management Section
          _buildSectionHeader(l10n.dataManagement),
          _buildSettingsCard([
            _buildSettingsItem(
              icon: Icons.download,
              title: l10n.exportData,
              subtitle: l10n.exportTransactionsCSV,
              onTap: () => _exportData(),
            ),
            _buildDivider(),
            _buildSettingsItem(
              icon: Icons.upload,
              title: l10n.importData,
              subtitle: l10n.importTransactionsCSV,
              onTap: () => _importData(),
            ),
            _buildDivider(),
            _buildSettingsItem(
              icon: Icons.delete_forever,
              title: l10n.clearAllData,
              subtitle: l10n.permanentlyDeleteTransactions,
              onTap: () => _showClearDataDialog(),
              isDestructive: true,
            ),
          ]),
          
          const SizedBox(height: AppDimensions.paddingL),
          
          // Notifications Section
          _buildSectionHeader(l10n.notifications),
          _buildSettingsCard([
            _buildSettingsItem(
              icon: Icons.notifications,
              title: l10n.budgetAlerts,
              subtitle: l10n.notifiedApproachingBudget,
              trailing: Switch(
                value: true,
                onChanged: (value) => _toggleBudgetAlerts(value),
                activeColor: ThemeColors.getAccentColor(context, context.read<ThemeProvider>().accentColor),
              ),
            ),
            _buildDivider(),
            _buildSettingsItem(
              icon: Icons.schedule,
              title: l10n.dailyReminders,
              subtitle: l10n.remindLogDailyExpenses,
              trailing: Switch(
                value: false,
                onChanged: (value) => _toggleDailyReminders(value),
                activeColor: ThemeColors.getAccentColor(context, context.read<ThemeProvider>().accentColor),
              ),
            ),
          ]),
          
          const SizedBox(height: AppDimensions.paddingL),
          
          // About Section
          _buildSectionHeader(l10n.about),
          _buildSettingsCard([
            _buildSettingsItem(
              icon: Icons.info,
              title: l10n.appVersion,
              subtitle: '1.0.0',
              onTap: () => _showAboutDialog(),
            ),
            _buildDivider(),
            _buildSettingsItem(
              icon: Icons.privacy_tip,
              title: l10n.privacyPolicy,
              subtitle: l10n.howWeHandleData,
              onTap: () => _showPrivacyPolicy(),
            ),
            _buildDivider(),
            _buildSettingsItem(
              icon: Icons.description,
              title: l10n.termsOfService,
              subtitle: l10n.termsAndConditions,
              onTap: () => _showTermsOfService(),
            ),
          ]),
          
          const SizedBox(height: AppDimensions.paddingL),
          
          // Account Section (moved to bottom)
          _buildSectionHeader(l10n.account),
          _buildSettingsCard([
            _buildSettingsItem(
              icon: Icons.logout,
              title: l10n.signOut,
              subtitle: l10n.signOutAccount,
              onTap: () => _showLogoutDialog(),
              isDestructive: true,
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
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: ThemeColors.getTextPrimary(context),
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
        color: isDestructive ? AppColors.error : ThemeColors.getAccentColor(context, context.read<ThemeProvider>().accentColor),
        size: 24,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: isDestructive ? AppColors.error : ThemeColors.getTextPrimary(context),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: ThemeColors.getTextSecondary(context),
          fontSize: 12,
        ),
      ),
      trailing: trailing ?? Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: ThemeColors.getTextSecondary(context),
      ),
      onTap: onTap,
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      indent: 56,
      color: ThemeColors.getSurfaceLight(context),
    );
  }

  Widget _buildThemeToggle() {
    final l10n = AppLocalizations.of(context)!;
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return ListTile(
          leading: Icon(
            themeProvider.themeMode == ThemeMode.dark
                ? Icons.dark_mode
                : Icons.light_mode,
            color: ThemeColors.getAccentColor(context, context.read<ThemeProvider>().accentColor),
            size: 24,
          ),
          title: Text(
            l10n.theme,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: ThemeColors.getTextPrimary(context),
            ),
          ),
          subtitle: Text(
            themeProvider.themeMode == ThemeMode.dark
                ? l10n.darkMode
                : themeProvider.themeMode == ThemeMode.light
                    ? l10n.lightMode
                    : l10n.systemDefault,
            style: TextStyle(
              color: ThemeColors.getTextSecondary(context),
              fontSize: 12,
            ),
          ),
          trailing: DropdownButton<ThemeMode>(
            value: themeProvider.themeMode,
            underline: const SizedBox(),
            items: [
              DropdownMenuItem(
                value: ThemeMode.light,
                child: Text(l10n.light),
              ),
              DropdownMenuItem(
                value: ThemeMode.dark,
                child: Text(l10n.dark),
              ),
              DropdownMenuItem(
                value: ThemeMode.system,
                child: Text(l10n.system),
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
    final l10n = AppLocalizations.of(context)!;
    SettingsSelectionPopup.show(
      context: context,
      title: l10n.chooseAccentColor,
      options: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return ListView(
            shrinkWrap: true,
            children: AccentColors.options.keys.map((colorName) {
              final color = AccentColors.options[colorName]!;
              final isSelected = themeProvider.accentColor == colorName;
              
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      themeProvider.setAccentColor(colorName);
                      Navigator.pop(context);
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isSelected 
                            ? color.withOpacity(0.1) 
                            : ThemeColors.getSurfaceLight(context),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected 
                              ? color 
                              : ThemeColors.getBorder(context).withOpacity(0.1),
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: isSelected ? Colors.white : Colors.transparent,
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: color.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: isSelected
                                ? const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 20,
                                  )
                                : null,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              colorName,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                color: ThemeColors.getTextPrimary(context),
                              ),
                            ),
                          ),
                          if (isSelected)
                            Icon(
                              Icons.check_circle,
                              color: color,
                              size: 20,
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        },
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

  void _showLanguageDialog() {
    final l10n = AppLocalizations.of(context)!;
    SettingsSelectionPopup.show(
      context: context,
      title: l10n.selectLanguage,
      maxHeight: 300,
      options: Consumer<LanguageProvider>(
        builder: (context, languageProvider, child) {
          return ListView(
            shrinkWrap: true,
            children: LanguageProvider.supportedLocales.map((locale) {
              final languageName = LanguageProvider.getLanguageName(locale.languageCode);
              final isSelected = languageProvider.currentLanguageCode == locale.languageCode;
              
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      languageProvider.setLanguage(locale.languageCode);
                      Navigator.pop(context);
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isSelected 
                            ? ThemeColors.getAccentColor(context, context.read<ThemeProvider>().accentColor).withOpacity(0.1) 
                            : ThemeColors.getSurfaceLight(context),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected 
                              ? ThemeColors.getAccentColor(context, context.read<ThemeProvider>().accentColor) 
                              : ThemeColors.getBorder(context).withOpacity(0.1),
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: ThemeColors.getAccentColor(context, context.read<ThemeProvider>().accentColor).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.language,
                              color: ThemeColors.getAccentColor(context, context.read<ThemeProvider>().accentColor),
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  languageName,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: ThemeColors.getTextPrimary(context),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  locale.languageCode.toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: ThemeColors.getTextSecondary(context),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (isSelected)
                            Icon(
                              Icons.check_circle,
                              color: ThemeColors.getAccentColor(context, context.read<ThemeProvider>().accentColor),
                              size: 20,
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }

  void _showCurrencyDialog() {
    final l10n = AppLocalizations.of(context)!;
    SettingsSelectionPopup.show(
      context: context,
      title: l10n.chooseCurrency,
      maxHeight: 400,
      options: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return ListView(
            shrinkWrap: true,
            children: CurrencyOptions.options.keys.map((currencyCode) {
              final currencySymbol = CurrencyOptions.options[currencyCode]!;
              final currencyName = CurrencyOptions.getCurrencyName(currencyCode);
              final isSelected = themeProvider.currency == currencyCode;
              
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      themeProvider.setCurrency(currencyCode);
                      Navigator.pop(context);
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isSelected 
                            ? ThemeColors.getAccentColor(context, themeProvider.accentColor).withOpacity(0.1) 
                            : ThemeColors.getSurfaceLight(context),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected 
                              ? ThemeColors.getAccentColor(context, themeProvider.accentColor) 
                              : ThemeColors.getBorder(context).withOpacity(0.1),
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: ThemeColors.getAccentColor(context, themeProvider.accentColor).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                currencySymbol,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: ThemeColors.getAccentColor(context, themeProvider.accentColor),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  currencyCode,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: ThemeColors.getTextPrimary(context),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  currencyName,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: ThemeColors.getTextSecondary(context),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (isSelected)
                            Icon(
                              Icons.check_circle,
                              color: ThemeColors.getAccentColor(context, themeProvider.accentColor),
                              size: 20,
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }

  void _showNumberFormatDialog() {
    final l10n = AppLocalizations.of(context)!;
    SettingsPopup.show(
      context: context,
      title: l10n.numberFormat,
      content: Text(l10n.numberFormattingComingSoon),
      actions: [
        SettingsPopupActions.cancelButton(
          context: context,
          text: l10n.ok,
        ),
      ],
    );
  }

  void _exportData() {
    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.exportFeatureComingSoon),
        backgroundColor: ThemeColors.getAccentColor(context, context.read<ThemeProvider>().accentColor),
      ),
    );
  }

  void _importData() {
    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.importFeatureComingSoon),
        backgroundColor: ThemeColors.getAccentColor(context, context.read<ThemeProvider>().accentColor),
      ),
    );
  }

  void _showClearDataDialog() {
    final l10n = AppLocalizations.of(context)!;
    SettingsPopup.show(
      context: context,
      title: l10n.clearAllData,
      content: Text(
        'This will permanently delete all your transactions, budgets, and categories. This action cannot be undone.',
      ),
      actions: [
        SettingsPopupActions.cancelButton(context: context),
        SettingsPopupActions.destructiveButton(
          context: context,
          text: l10n.deleteAll,
          onPressed: () {
            Navigator.pop(context);
            _clearAllData();
          },
        ),
      ],
    );
  }

  void _clearAllData() {
    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.clearDataFeatureComingSoon),
          backgroundColor: AppColors.warning,
        ),
    );
  }

  void _toggleBudgetAlerts(bool value) {
    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(value ? l10n.budgetAlertsEnabled : l10n.budgetAlertsDisabled),
        backgroundColor: ThemeColors.getAccentColor(context, context.read<ThemeProvider>().accentColor),
      ),
    );
  }

  void _toggleDailyReminders(bool value) {
    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(value ? l10n.dailyRemindersEnabled : l10n.dailyRemindersDisabled),
        backgroundColor: ThemeColors.getAccentColor(context, context.read<ThemeProvider>().accentColor),
      ),
    );
  }

  void _showAboutDialog() {
    final l10n = AppLocalizations.of(context)!;
    final themeProvider = context.read<ThemeProvider>();
    final accentColor = ThemeColors.getAccentColor(context, themeProvider.accentColor);
    
    SettingsPopup.show(
      context: context,
      title: 'Money Maker',
      subtitle: 'Version 1.0.0',
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App Icon
            Center(
              child: Container(
                width: 80,
                height: 80,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: accentColor.withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: Icon(
                  Icons.account_balance_wallet,
                  size: 48,
                  color: accentColor,
                ),
              ),
            ),
            
            // Description
            Text(
              'A simple and elegant money management app to help you track your income and expenses.',
              style: TextStyle(
                fontSize: 14,
                color: ThemeColors.getTextSecondary(context),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            
            // Features
            Text(
              'Features:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: ThemeColors.getTextPrimary(context),
              ),
            ),
            const SizedBox(height: 12),
            _buildFeatureItem('Track income and expenses', Icons.trending_up, accentColor),
            _buildFeatureItem('Monthly and daily views', Icons.calendar_month, accentColor),
            _buildFeatureItem('Category management', Icons.category, accentColor),
            _buildFeatureItem('Budget tracking', Icons.account_balance, accentColor),
            _buildFeatureItem('Data visualization', Icons.bar_chart, accentColor),
            _buildFeatureItem('Multi-currency support', Icons.attach_money, accentColor),
            _buildFeatureItem('Dark/Light theme support', Icons.palette, accentColor),
          ],
        ),
      ),
      actions: [
        SettingsPopupActions.confirmButton(
          context: context,
          text: l10n.close,
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }

  Widget _buildFeatureItem(String text, IconData icon, Color accentColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 16, color: accentColor),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: ThemeColors.getTextSecondary(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showPrivacyPolicy() {
    final l10n = AppLocalizations.of(context)!;
    SettingsPopup.show(
      context: context,
      title: l10n.privacyPolicy,
      content: const SingleChildScrollView(
        child: Text(
          'Your privacy is important to us. All your data is stored locally on your device and is not shared with any third parties.\n\n'
          'We do not collect, store, or transmit any personal information. Your financial data remains private and secure on your device.',
        ),
      ),
      actions: [
        SettingsPopupActions.cancelButton(
          context: context,
          text: l10n.close,
        ),
      ],
    );
  }

  void _showTermsOfService() {
    final l10n = AppLocalizations.of(context)!;
    SettingsPopup.show(
      context: context,
      title: l10n.termsOfService,
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
        SettingsPopupActions.cancelButton(
          context: context,
          text: l10n.close,
        ),
      ],
    );
  }

  void _showLogoutDialog() {
    final l10n = AppLocalizations.of(context)!;
    final themeProvider = context.read<ThemeProvider>();
    final accentColor = ThemeColors.getAccentColor(context, themeProvider.accentColor);
    
    SettingsPopup.show(
      context: context,
      title: l10n.logout,
      subtitle: l10n.signOutAccount,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Warning Icon
          Container(
            width: 64,
            height: 64,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: AppColors.error.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.error.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Icon(
              Icons.logout_rounded,
              color: AppColors.error,
              size: 32,
            ),
          ),
          
          // Confirmation Message
          Text(
            l10n.sureWantLogout,
            style: TextStyle(
              fontSize: 16,
              color: ThemeColors.getTextPrimary(context),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'You will need to sign in again to access your data.',
            style: TextStyle(
              fontSize: 14,
              color: ThemeColors.getTextSecondary(context),
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      actions: [
        Expanded(
          child: SettingsPopupActions.cancelButton(context: context),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: SettingsPopupActions.destructiveButton(
            context: context,
            text: l10n.logout,
            onPressed: () {
              Navigator.pop(context);
              _logout();
            },
          ),
        ),
      ],
    );
  }

  void _logout() async {
    final l10n = AppLocalizations.of(context)!;
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
          SnackBar(
            content: Text(l10n.loggedOutSuccessfully),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${l10n.logoutFailed}: ${e.toString()}'),
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
            color: ThemeColors.getBackground(context),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            children: [
              Container(
                width: 36,
                height: 4,
                margin: const EdgeInsets.only(top: 8, bottom: 12),
                decoration: BoxDecoration(
                  color: ThemeColors.getSurfaceLight(context),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                child: Text(
                  'Customize Categories',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: ThemeColors.getTextPrimary(context)),
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
                          title: Text(category.name, style: TextStyle(color: ThemeColors.getTextPrimary(context))),
                          subtitle: Text(isIncome ? 'Income' : 'Expense', style: TextStyle(color: ThemeColors.getTextSecondary(context), fontSize: 12)),
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
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Create new category',
                style: TextStyle(fontWeight: FontWeight.w700, color: ThemeColors.getTextPrimary(context)),
              ),
              const SizedBox(height: 10),
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 12,
                runSpacing: 12,
                children: [
                  // Type selector (modern chips)
                  StatefulBuilder(
                    builder: (context, setStateChips) {
                      return Wrap(
                        spacing: 8,
                        children: [
                          ChoiceChip(
                            label: const Text('Expense'),
                            selected: !_isIncome,
                            onSelected: (v) {
                              setState(() { _isIncome = false; });
                              setStateChips(() {});
                            },
                            selectedColor: ThemeColors.getAccentColor(context, context.read<ThemeProvider>().accentColor),
                            labelStyle: TextStyle(color: !_isIncome ? Colors.white : ThemeColors.getTextPrimary(context)),
                          ),
                          ChoiceChip(
                            label: const Text('Income'),
                            selected: _isIncome,
                            onSelected: (v) {
                              setState(() { _isIncome = true; });
                              setStateChips(() {});
                            },
                            selectedColor: ThemeColors.getAccentColor(context, context.read<ThemeProvider>().accentColor),
                            labelStyle: TextStyle(color: _isIncome ? Colors.white : ThemeColors.getTextPrimary(context)),
                          ),
                        ],
                      );
                    },
                  ),
                  // Name field (take available width)
                  ConstrainedBox(
                    constraints: const BoxConstraints(minWidth: 200, maxWidth: 280),
                    child: TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        hintText: 'Category name',
                        filled: true,
                        fillColor: ThemeColors.getSurface(context),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: ThemeColors.getSurfaceLight(context)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: ThemeColors.getSurfaceLight(context)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: ThemeColors.getAccentColor(context, context.read<ThemeProvider>().accentColor)),
                        ),
                      ),
                    ),
                  ),
                  // Color picker
                  OutlinedButton.icon(
                    onPressed: () async {
                      final color = await showDialog<Color>(
                        context: context,
                        builder: (context) => _SimpleColorPicker(initial: _selectedColor),
                      );
                      if (color != null) {
                        setState(() { _selectedColor = color; });
                      }
                    },
                    icon: Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(color: _selectedColor, shape: BoxShape.circle),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: ThemeColors.getSurfaceLight(context)),
                      foregroundColor: ThemeColors.getTextPrimary(context),
                    ),
                    label: const Text('Pick color'),
                  ),
                  // Add button
                  ElevatedButton.icon(
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
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Add'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ThemeColors.getAccentColor(context, context.read<ThemeProvider>().accentColor),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SimpleColorPicker extends StatelessWidget {
  final Color initial;
  const _SimpleColorPicker({required this.initial});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
    
    return SettingsPopup(
      title: l10n.pickColor,
      content: StatefulBuilder(
        builder: (context, setState) {
          return Wrap(
            spacing: 12,
            runSpacing: 12,
            children: colors.map((c) {
              final isSel = c.value == selected.value;
              return GestureDetector(
                onTap: () => setState(() => selected = c),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: c,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSel ? Colors.white : Colors.transparent, 
                      width: 3,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: c.withOpacity(0.3), 
                        blurRadius: 8, 
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: isSel
                      ? const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 20,
                        )
                      : null,
                ),
              );
            }).toList(),
          );
        },
      ),
      actions: [
        SettingsPopupActions.cancelButton(context: context),
        SettingsPopupActions.confirmButton(
          context: context,
          text: l10n.select,
          onPressed: () => Navigator.pop(context, selected),
        ),
      ],
    );
  }
}
