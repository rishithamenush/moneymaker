import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/dimensions.dart';
import '../../../core/utils/theme_colors.dart';
import '../../providers/theme_provider.dart';
import '../../providers/language_provider.dart';
import '../../providers/category_provider.dart';
import '../../providers/pin_auth_provider.dart';
import '../../../domain/entities/category.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/common/settings_popup.dart';
import '../../widgets/common/modern_popup.dart';
import '../../navigation/bottom_nav_bar.dart';
import '../../../app/routes.dart';
import '../auth/pin_setup_page.dart';
import '../auth/pin_verification_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
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
            Consumer<PinAuthProvider>(
              builder: (context, pinProvider, child) {
                return _buildSettingsItem(
                  icon: Icons.security,
                  title: 'Authentication',
                  subtitle: pinProvider.isEnabled 
                    ? 'PIN protection enabled' 
                    : 'PIN protection disabled',
                  trailing: Switch(
                    value: pinProvider.isEnabled,
                    onChanged: (value) => _togglePinAuth(value),
                    activeColor: ThemeColors.getAccentColor(context, context.read<ThemeProvider>().accentColor),
                  ),
                );
              },
            ),
            Consumer<PinAuthProvider>(
              builder: (context, pinProvider, child) {
                if (!pinProvider.isEnabled) return const SizedBox.shrink();
                return Column(
                  children: [
                    _buildDivider(),
                    _buildSettingsItem(
                      icon: Icons.lock_reset,
                      title: 'Change PIN',
                      subtitle: 'Update your PIN',
                      onTap: () => _changePin(),
                    ),
                  ],
                );
              },
            ),
          ]),
          
          const SizedBox(height: AppDimensions.paddingXL),
        ],
      ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 2),
      ),
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
    PopupUtils.showInfo(
      context: context,
      title: 'Coming Soon',
      message: l10n.exportFeatureComingSoon,
    );
  }

  void _importData() {
    final l10n = AppLocalizations.of(context)!;
    PopupUtils.showInfo(
      context: context,
      title: 'Coming Soon',
      message: l10n.importFeatureComingSoon,
    );
  }

  void _showClearDataDialog() {
    final l10n = AppLocalizations.of(context)!;
    SettingsPopup.show(
      context: context,
      title: l10n.clearAllData,
      content: Text(
        l10n.clearAllDataConfirmation,
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
    PopupUtils.showWarning(
      context: context,
      title: 'Coming Soon',
      message: l10n.clearDataFeatureComingSoon,
    );
  }

  void _toggleBudgetAlerts(bool value) {
    final l10n = AppLocalizations.of(context)!;
    PopupUtils.showInfo(
      context: context,
      title: 'Settings Updated',
      message: value ? l10n.budgetAlertsEnabled : l10n.budgetAlertsDisabled,
    );
  }

  void _toggleDailyReminders(bool value) {
    final l10n = AppLocalizations.of(context)!;
    PopupUtils.showInfo(
      context: context,
      title: 'Settings Updated',
      message: value ? l10n.dailyRemindersEnabled : l10n.dailyRemindersDisabled,
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
              l10n.appDescription,
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
              l10n.features,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: ThemeColors.getTextPrimary(context),
              ),
            ),
            const SizedBox(height: 12),
            _buildFeatureItem(l10n.trackIncomeExpenses, Icons.trending_up, accentColor),
            _buildFeatureItem(l10n.monthlyDailyViews, Icons.calendar_month, accentColor),
            _buildFeatureItem(l10n.categoryManagement, Icons.category, accentColor),
            _buildFeatureItem(l10n.budgetTracking, Icons.account_balance, accentColor),
            _buildFeatureItem(l10n.dataVisualization, Icons.bar_chart, accentColor),
            _buildFeatureItem(l10n.multiCurrencySupport, Icons.attach_money, accentColor),
            _buildFeatureItem(l10n.darkLightThemeSupport, Icons.palette, accentColor),
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
      content: SingleChildScrollView(
        child: Text(
          l10n.privacyPolicyContent,
          style: TextStyle(
            fontSize: 14,
            color: ThemeColors.getTextSecondary(context),
            height: 1.5,
          ),
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
      content: SingleChildScrollView(
        child: Text(
          l10n.termsOfServiceContent,
          style: TextStyle(
            fontSize: 14,
            color: ThemeColors.getTextSecondary(context),
            height: 1.5,
          ),
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
              // Logout functionality removed - replaced with PIN authentication
            },
          ),
        ),
      ],
    );
  }

  void _togglePinAuth(bool enable) async {
    final pinProvider = context.read<PinAuthProvider>();
    
    if (enable) {
      // Enable PIN auth - navigate to PIN setup
      final result = await Navigator.push<bool>(
        context,
        MaterialPageRoute(
          builder: (context) => const PinSetupPage(),
        ),
      );
      
      if (result == true && mounted) {
        PopupUtils.showSuccess(
          context: context,
          title: 'Success',
          message: 'PIN authentication has been enabled',
        );
      }
    } else {
      // Disable PIN auth - show confirmation dialog
      _showDisablePinDialog();
    }
  }

  void _showDisablePinDialog() {
    final themeProvider = context.read<ThemeProvider>();
    final accentColor = ThemeColors.getAccentColor(context, themeProvider.accentColor);
    
    SettingsPopup.show(
      context: context,
      title: 'Disable PIN Authentication',
      subtitle: 'Enter your PIN to disable authentication',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Warning Icon
          Container(
            width: 64,
            height: 64,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: AppColors.warning.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.warning.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Icon(
              Icons.security,
              color: AppColors.warning,
              size: 32,
            ),
          ),
          
          // Confirmation Message
          Text(
            'Enter your current PIN to disable authentication',
            style: TextStyle(
              fontSize: 16,
              color: ThemeColors.getTextPrimary(context),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'This will remove PIN protection from your app.',
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
          child: SettingsPopupActions.cancelButton(
            context: context,
            text: 'Cancel',
            onPressed: () => Navigator.pop(context),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: SettingsPopupActions.confirmButton(
            context: context,
            text: 'Enter PIN',
            onPressed: () {
              Navigator.pop(context);
              _showPinVerificationForDisable();
            },
          ),
        ),
      ],
    );
  }

  void _showPinVerificationForDisable() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _PinVerificationDialog(
        onVerified: (pin) async {
          final pinProvider = context.read<PinAuthProvider>();
          final success = await pinProvider.disablePinAuth(pin);
          
          if (success && mounted) {
            Navigator.pop(context);
            PopupUtils.showSuccess(
              context: context,
              title: 'Success',
              message: 'PIN authentication has been disabled',
            );
          } else {
            PopupUtils.showError(
              context: context,
              title: 'Error',
              message: 'Incorrect PIN. Please try again.',
            );
          }
        },
        onCancel: () => Navigator.pop(context),
      ),
    );
  }

  void _changePin() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => const PinSetupPage(isChangingPin: true),
      ),
    );
    
    if (result == true && mounted) {
      PopupUtils.showSuccess(
        context: context,
        title: 'Success',
        message: 'PIN has been changed successfully',
      );
    }
  }
}

class _PinVerificationDialog extends StatefulWidget {
  final Function(String) onVerified;
  final VoidCallback onCancel;

  const _PinVerificationDialog({
    required this.onVerified,
    required this.onCancel,
  });

  @override
  State<_PinVerificationDialog> createState() => _PinVerificationDialogState();
}

class _PinVerificationDialogState extends State<_PinVerificationDialog> {
  final List<TextEditingController> _controllers = List.generate(
    4,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(
    4,
    (index) => FocusNode(),
  );
  
  String _pin = '';
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _focusNodes[0].requestFocus();
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _onDigitEntered(String digit, int index) {
    if (digit.isEmpty) return;
    
    setState(() {
      _pin += digit;
      _errorMessage = null;
    });

    if (index < 3) {
      _focusNodes[index + 1].requestFocus();
    } else {
      _focusNodes[index].unfocus();
      if (_pin.length == 4) {
        widget.onVerified(_pin);
      }
    }
  }

  void _onDigitDeleted(int index) {
    if (index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
    
    setState(() {
      if (_pin.isNotEmpty) {
        _pin = _pin.substring(0, _pin.length - 1);
      }
      _errorMessage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.read<ThemeProvider>();
    final accentColor = ThemeColors.getAccentColor(context, themeProvider.accentColor);
    
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title
            Text(
              'Enter PIN',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: ThemeColors.getTextPrimary(context),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // PIN Input Fields
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(4, (index) {
                final isFilled = index < _pin.length;
                
                return Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: _errorMessage != null 
                        ? AppColors.error
                        : isFilled 
                          ? accentColor 
                          : ThemeColors.getTextSecondary(context),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(10),
                    color: isFilled 
                      ? accentColor.withOpacity(0.1)
                      : Colors.transparent,
                  ),
                  child: Center(
                    child: Text(
                      isFilled ? '●' : '',
                      style: TextStyle(
                        fontSize: 20,
                        color: _errorMessage != null 
                          ? AppColors.error
                          : accentColor,
                      ),
                    ),
                  ),
                );
              }),
            ),
            
            if (_errorMessage != null) ...[
              const SizedBox(height: 16),
              Text(
                _errorMessage!,
                style: TextStyle(
                  color: AppColors.error,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            
            const SizedBox(height: 24),
            
            // Number Pad
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 3,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.5,
              children: [
                // Numbers 1-9
                ...List.generate(9, (index) {
                  final number = (index + 1).toString();
                  return _buildNumberButton(number, accentColor);
                }),
                
                // Empty space
                const SizedBox(),
                
                // Number 0
                _buildNumberButton('0', accentColor),
                
                // Delete button
                _buildDeleteButton(accentColor),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Cancel button
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: widget.onCancel,
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: ThemeColors.getTextSecondary(context),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNumberButton(String number, Color accentColor) {
    return GestureDetector(
      onTap: () {
        if (_pin.length < 4) {
          _onDigitEntered(number, _pin.length);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: ThemeColors.getCardBackground(context),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: ThemeColors.getBorderColor(context),
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            number,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: ThemeColors.getTextPrimary(context),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDeleteButton(Color accentColor) {
    return GestureDetector(
      onTap: () {
        if (_pin.isNotEmpty) {
          _onDigitDeleted(_pin.length - 1);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: ThemeColors.getCardBackground(context),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: ThemeColors.getBorderColor(context),
            width: 1,
          ),
        ),
        child: Center(
          child: Icon(
            Icons.backspace_outlined,
            size: 20,
            color: ThemeColors.getTextPrimary(context),
          ),
        ),
      ),
    );
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
