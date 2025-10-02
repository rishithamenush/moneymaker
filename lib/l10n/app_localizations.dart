import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_si.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('ja'),
    Locale('si'),
    Locale('zh')
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'MoneyMaker'**
  String get appTitle;

  /// Home page title
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// Overview page title
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get overview;

  /// Summary tab title
  ///
  /// In en, this message translates to:
  /// **'Summary'**
  String get summary;

  /// Charts tab title
  ///
  /// In en, this message translates to:
  /// **'Charts'**
  String get charts;

  /// Trends tab title
  ///
  /// In en, this message translates to:
  /// **'Trends'**
  String get trends;

  /// Appearance section title
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// Customize categories title
  ///
  /// In en, this message translates to:
  /// **'Customize Categories'**
  String get customizeCategories;

  /// Customize categories subtitle
  ///
  /// In en, this message translates to:
  /// **'Add, rename, or delete your own categories'**
  String get addRenameDeleteCategories;

  /// Theme setting label
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// Dark mode option
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// Light mode option
  ///
  /// In en, this message translates to:
  /// **'Light Mode'**
  String get lightMode;

  /// System default theme option
  ///
  /// In en, this message translates to:
  /// **'System Default'**
  String get systemDefault;

  /// Light theme option
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// Dark theme option
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// System theme option
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get system;

  /// Accent color dialog title
  ///
  /// In en, this message translates to:
  /// **'Choose Accent Color'**
  String get chooseAccentColor;

  /// Currency dialog title
  ///
  /// In en, this message translates to:
  /// **'Choose Currency'**
  String get chooseCurrency;

  /// Currency formatting section title
  ///
  /// In en, this message translates to:
  /// **'Currency & Formatting'**
  String get currencyFormatting;

  /// Number format setting title
  ///
  /// In en, this message translates to:
  /// **'Number Format'**
  String get numberFormat;

  /// Number format subtitle
  ///
  /// In en, this message translates to:
  /// **'Decimal places and separators'**
  String get decimalPlacesSeparators;

  /// Data management section title
  ///
  /// In en, this message translates to:
  /// **'Data Management'**
  String get dataManagement;

  /// Export data subtitle
  ///
  /// In en, this message translates to:
  /// **'Export your transactions to CSV'**
  String get exportTransactionsCSV;

  /// Import data subtitle
  ///
  /// In en, this message translates to:
  /// **'Import transactions from CSV'**
  String get importTransactionsCSV;

  /// Clear all data title
  ///
  /// In en, this message translates to:
  /// **'Clear All Data'**
  String get clearAllData;

  /// Clear all data subtitle
  ///
  /// In en, this message translates to:
  /// **'Permanently delete all transactions'**
  String get permanentlyDeleteTransactions;

  /// Notifications section title
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// Budget alerts setting title
  ///
  /// In en, this message translates to:
  /// **'Budget Alerts'**
  String get budgetAlerts;

  /// Budget alerts subtitle
  ///
  /// In en, this message translates to:
  /// **'Get notified when approaching budget limits'**
  String get notifiedApproachingBudget;

  /// Daily reminders setting title
  ///
  /// In en, this message translates to:
  /// **'Daily Reminders'**
  String get dailyReminders;

  /// Daily reminders subtitle
  ///
  /// In en, this message translates to:
  /// **'Remind me to log daily expenses'**
  String get remindLogDailyExpenses;

  /// About section title
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// App version setting title
  ///
  /// In en, this message translates to:
  /// **'App Version'**
  String get appVersion;

  /// Privacy policy title
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// Privacy policy subtitle
  ///
  /// In en, this message translates to:
  /// **'How we handle your data'**
  String get howWeHandleData;

  /// Terms of service title
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// Terms of service subtitle
  ///
  /// In en, this message translates to:
  /// **'Terms and conditions'**
  String get termsAndConditions;

  /// Sign out subtitle
  ///
  /// In en, this message translates to:
  /// **'Sign out of your account'**
  String get signOutAccount;

  /// Logout title
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// Logout confirmation message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get sureWantLogout;

  /// Delete all button
  ///
  /// In en, this message translates to:
  /// **'Delete All'**
  String get deleteAll;

  /// Close button
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// OK button text
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// Select button
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get select;

  /// Color picker title
  ///
  /// In en, this message translates to:
  /// **'Pick a color'**
  String get pickColor;

  /// Create new category title
  ///
  /// In en, this message translates to:
  /// **'Create new category'**
  String get createNewCategory;

  /// Category name field hint
  ///
  /// In en, this message translates to:
  /// **'Category name'**
  String get categoryName;

  /// Pick color button
  ///
  /// In en, this message translates to:
  /// **'Pick color'**
  String get pickColorButton;

  /// Add button
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// Expense transaction type
  ///
  /// In en, this message translates to:
  /// **'Expense'**
  String get expense;

  /// Income transaction type
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get income;

  /// Export feature message
  ///
  /// In en, this message translates to:
  /// **'Export feature coming soon!'**
  String get exportFeatureComingSoon;

  /// Import feature message
  ///
  /// In en, this message translates to:
  /// **'Import feature coming soon!'**
  String get importFeatureComingSoon;

  /// Number formatting message
  ///
  /// In en, this message translates to:
  /// **'Number formatting options coming soon!'**
  String get numberFormattingComingSoon;

  /// Clear data feature message
  ///
  /// In en, this message translates to:
  /// **'Clear data feature coming soon!'**
  String get clearDataFeatureComingSoon;

  /// Budget alerts enabled message
  ///
  /// In en, this message translates to:
  /// **'Budget alerts enabled'**
  String get budgetAlertsEnabled;

  /// Budget alerts disabled message
  ///
  /// In en, this message translates to:
  /// **'Budget alerts disabled'**
  String get budgetAlertsDisabled;

  /// Daily reminders enabled message
  ///
  /// In en, this message translates to:
  /// **'Daily reminders enabled'**
  String get dailyRemindersEnabled;

  /// Daily reminders disabled message
  ///
  /// In en, this message translates to:
  /// **'Daily reminders disabled'**
  String get dailyRemindersDisabled;

  /// Logout success message
  ///
  /// In en, this message translates to:
  /// **'Logged out successfully'**
  String get loggedOutSuccessfully;

  /// Logout failed message
  ///
  /// In en, this message translates to:
  /// **'Logout failed'**
  String get logoutFailed;

  /// Monthly summary title
  ///
  /// In en, this message translates to:
  /// **'Monthly Summary'**
  String get monthlySummary;

  /// Total spent label
  ///
  /// In en, this message translates to:
  /// **'Total Spent'**
  String get totalSpent;

  /// Remaining label
  ///
  /// In en, this message translates to:
  /// **'Remaining'**
  String get remaining;

  /// Budget progress label
  ///
  /// In en, this message translates to:
  /// **'Budget Progress'**
  String get budgetProgress;

  /// Budget exceeded message
  ///
  /// In en, this message translates to:
  /// **'You\'ve exceeded your budget by'**
  String get budgetExceeded;

  /// Set budget button text
  ///
  /// In en, this message translates to:
  /// **'Set Budget'**
  String get setBudget;

  /// Update budget button text
  ///
  /// In en, this message translates to:
  /// **'Update Budget'**
  String get updateBudget;

  /// Set monthly budget dialog title
  ///
  /// In en, this message translates to:
  /// **'Set Monthly Budget'**
  String get setMonthlyBudget;

  /// Set monthly budget dialog description
  ///
  /// In en, this message translates to:
  /// **'Set your monthly spending limit to track your expenses better.'**
  String get setMonthlyBudgetDescription;

  /// Budget amount input label
  ///
  /// In en, this message translates to:
  /// **'Budget Amount'**
  String get budgetAmount;

  /// Budget set success message
  ///
  /// In en, this message translates to:
  /// **'Budget set successfully!'**
  String get budgetSetSuccessfully;

  /// Invalid amount error message
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid amount'**
  String get pleaseEnterValidAmount;

  /// Edit budget button tooltip
  ///
  /// In en, this message translates to:
  /// **'Edit Budget'**
  String get editBudget;

  /// Edit monthly budget dialog title
  ///
  /// In en, this message translates to:
  /// **'Edit Monthly Budget'**
  String get editMonthlyBudget;

  /// Edit monthly budget dialog description
  ///
  /// In en, this message translates to:
  /// **'Update your monthly spending limit.'**
  String get editMonthlyBudgetDescription;

  /// Budget updated success message
  ///
  /// In en, this message translates to:
  /// **'Budget updated successfully!'**
  String get budgetUpdatedSuccessfully;

  /// Add transaction page title
  ///
  /// In en, this message translates to:
  /// **'Add Transaction'**
  String get addTransaction;

  /// Settings page title
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Account section title
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// Login page title
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// Register page title
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// Email field label
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// Password field label
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// Confirm password field label
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// Sign in button text
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// Sign up button text
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// Sign out button text
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOut;

  /// Forgot password link text
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// Don't have account text
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// Already have account text
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// Amount field label
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// Description field label
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// Category field label
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// Date field label
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// Type field label
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// Save button text
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Cancel button text
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Delete button text
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Edit button text
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// Total income label
  ///
  /// In en, this message translates to:
  /// **'Total Income'**
  String get totalIncome;

  /// Total expenses label
  ///
  /// In en, this message translates to:
  /// **'Total Expenses'**
  String get totalExpenses;

  /// Net amount label
  ///
  /// In en, this message translates to:
  /// **'Net Amount'**
  String get netAmount;

  /// Recent transactions label
  ///
  /// In en, this message translates to:
  /// **'Recent Transactions'**
  String get recentTransactions;

  /// No transactions message
  ///
  /// In en, this message translates to:
  /// **'No transactions found'**
  String get noTransactions;

  /// Accent color setting label
  ///
  /// In en, this message translates to:
  /// **'Accent Color'**
  String get accentColor;

  /// Currency setting label
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get currency;

  /// Language setting label
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Export data button text
  ///
  /// In en, this message translates to:
  /// **'Export Data'**
  String get exportData;

  /// Import data button text
  ///
  /// In en, this message translates to:
  /// **'Import Data'**
  String get importData;

  /// Version label
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// Delete transaction dialog title
  ///
  /// In en, this message translates to:
  /// **'Delete Transaction'**
  String get deleteTransaction;

  /// Delete transaction confirmation message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this transaction?'**
  String get deleteTransactionMessage;

  /// Transaction deleted success message
  ///
  /// In en, this message translates to:
  /// **'Transaction deleted successfully'**
  String get transactionDeleted;

  /// Transaction saved success message
  ///
  /// In en, this message translates to:
  /// **'Transaction saved successfully'**
  String get transactionSaved;

  /// Validation error message
  ///
  /// In en, this message translates to:
  /// **'Please fill all fields'**
  String get pleaseFillAllFields;

  /// Email validation error
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get invalidEmail;

  /// Password validation error
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordTooShort;

  /// Password confirmation error
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// Login error message
  ///
  /// In en, this message translates to:
  /// **'Login failed. Please check your credentials.'**
  String get loginFailed;

  /// Registration error message
  ///
  /// In en, this message translates to:
  /// **'Registration failed. Please try again.'**
  String get registrationFailed;

  /// Welcome back message
  ///
  /// In en, this message translates to:
  /// **'Welcome back!'**
  String get welcomeBack;

  /// Welcome message
  ///
  /// In en, this message translates to:
  /// **'Welcome!'**
  String get welcome;

  /// Loading indicator text
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// Error title
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// Success title
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// Yes button text
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No button text
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// Food category
  ///
  /// In en, this message translates to:
  /// **'Food'**
  String get food;

  /// Transport category
  ///
  /// In en, this message translates to:
  /// **'Transport'**
  String get transport;

  /// Entertainment category
  ///
  /// In en, this message translates to:
  /// **'Entertainment'**
  String get entertainment;

  /// Shopping category
  ///
  /// In en, this message translates to:
  /// **'Shopping'**
  String get shopping;

  /// Health category
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get health;

  /// Education category
  ///
  /// In en, this message translates to:
  /// **'Education'**
  String get education;

  /// Other category
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// Salary income type
  ///
  /// In en, this message translates to:
  /// **'Salary'**
  String get salary;

  /// Freelance income type
  ///
  /// In en, this message translates to:
  /// **'Freelance'**
  String get freelance;

  /// Investment income type
  ///
  /// In en, this message translates to:
  /// **'Investment'**
  String get investment;

  /// Gift income type
  ///
  /// In en, this message translates to:
  /// **'Gift'**
  String get gift;

  /// Business income type
  ///
  /// In en, this message translates to:
  /// **'Business'**
  String get business;

  /// Rent income type
  ///
  /// In en, this message translates to:
  /// **'Rent'**
  String get rent;

  /// Budget label
  ///
  /// In en, this message translates to:
  /// **'Budget'**
  String get budget;

  /// Spent label
  ///
  /// In en, this message translates to:
  /// **'Spent'**
  String get spent;

  /// Over budget label
  ///
  /// In en, this message translates to:
  /// **'Over Budget'**
  String get overBudget;

  /// Spending trends title
  ///
  /// In en, this message translates to:
  /// **'Spending Trends'**
  String get spendingTrends;

  /// Weekly breakdown title
  ///
  /// In en, this message translates to:
  /// **'Weekly Breakdown'**
  String get weeklyBreakdown;

  /// Monthly comparison title
  ///
  /// In en, this message translates to:
  /// **'Monthly Comparison'**
  String get monthlyComparison;

  /// This month label
  ///
  /// In en, this message translates to:
  /// **'This Month'**
  String get thisMonth;

  /// Last month label
  ///
  /// In en, this message translates to:
  /// **'Last Month'**
  String get lastMonth;

  /// Daily average label
  ///
  /// In en, this message translates to:
  /// **'Daily Average'**
  String get dailyAverage;

  /// Insights title
  ///
  /// In en, this message translates to:
  /// **'Insights'**
  String get insights;

  /// Category totals title
  ///
  /// In en, this message translates to:
  /// **'Category Totals'**
  String get categoryTotals;

  /// No data message
  ///
  /// In en, this message translates to:
  /// **'No data available'**
  String get noData;

  /// Language selection dialog title
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// English language option
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// Spanish language option
  ///
  /// In en, this message translates to:
  /// **'Spanish'**
  String get spanish;

  /// French language option
  ///
  /// In en, this message translates to:
  /// **'French'**
  String get french;

  /// German language option
  ///
  /// In en, this message translates to:
  /// **'German'**
  String get german;

  /// Chinese language option
  ///
  /// In en, this message translates to:
  /// **'Chinese'**
  String get chinese;

  /// Japanese language option
  ///
  /// In en, this message translates to:
  /// **'Japanese'**
  String get japanese;

  /// Sinhala language option
  ///
  /// In en, this message translates to:
  /// **'සිංහල'**
  String get sinhala;

  /// App description in about dialog
  ///
  /// In en, this message translates to:
  /// **'A simple and elegant money management app to help you track your income and expenses.'**
  String get appDescription;

  /// Features section title in about dialog
  ///
  /// In en, this message translates to:
  /// **'Features:'**
  String get features;

  /// Feature: Track income and expenses
  ///
  /// In en, this message translates to:
  /// **'Track income and expenses'**
  String get trackIncomeExpenses;

  /// Feature: Monthly and daily views
  ///
  /// In en, this message translates to:
  /// **'Monthly and daily views'**
  String get monthlyDailyViews;

  /// Feature: Category management
  ///
  /// In en, this message translates to:
  /// **'Category management'**
  String get categoryManagement;

  /// Feature: Budget tracking
  ///
  /// In en, this message translates to:
  /// **'Budget tracking'**
  String get budgetTracking;

  /// Feature: Data visualization
  ///
  /// In en, this message translates to:
  /// **'Data visualization'**
  String get dataVisualization;

  /// Feature: Multi-currency support
  ///
  /// In en, this message translates to:
  /// **'Multi-currency support'**
  String get multiCurrencySupport;

  /// Feature: Dark/Light theme support
  ///
  /// In en, this message translates to:
  /// **'Dark/Light theme support'**
  String get darkLightThemeSupport;

  /// Privacy policy dialog content
  ///
  /// In en, this message translates to:
  /// **'Your privacy is important to us. All your data is stored locally on your device and is not shared with any third parties.\n\nWe do not collect, store, or transmit any personal information. Your financial data remains private and secure on your device.'**
  String get privacyPolicyContent;

  /// Terms of service dialog content
  ///
  /// In en, this message translates to:
  /// **'By using Money Maker, you agree to the following terms:\n\n1. This app is provided \"as is\" without warranties.\n2. You are responsible for backing up your data.\n3. We are not liable for any data loss.\n4. You may not reverse engineer or redistribute this app.\n\nThese terms may be updated from time to time.'**
  String get termsOfServiceContent;

  /// Clear all data confirmation message
  ///
  /// In en, this message translates to:
  /// **'This will permanently delete all your transactions, budgets, and categories. This action cannot be undone.'**
  String get clearAllDataConfirmation;

  /// Delete all data button text
  ///
  /// In en, this message translates to:
  /// **'Delete All Data'**
  String get deleteAllData;

  /// Authentication settings title
  ///
  /// In en, this message translates to:
  /// **'Authentication'**
  String get authentication;

  /// PIN protection enabled status
  ///
  /// In en, this message translates to:
  /// **'PIN protection enabled'**
  String get pinProtectionEnabled;

  /// PIN protection disabled status
  ///
  /// In en, this message translates to:
  /// **'PIN protection disabled'**
  String get pinProtectionDisabled;

  /// Change PIN title
  ///
  /// In en, this message translates to:
  /// **'Change PIN'**
  String get changePin;

  /// Change PIN subtitle
  ///
  /// In en, this message translates to:
  /// **'Update your PIN'**
  String get updateYourPin;

  /// Set PIN title
  ///
  /// In en, this message translates to:
  /// **'Set PIN'**
  String get setPin;

  /// Enter new PIN instruction
  ///
  /// In en, this message translates to:
  /// **'Enter your new 4-digit PIN'**
  String get enterNewPin;

  /// Confirm new PIN instruction
  ///
  /// In en, this message translates to:
  /// **'Confirm your new PIN'**
  String get confirmNewPin;

  /// Enter current PIN instruction
  ///
  /// In en, this message translates to:
  /// **'Enter your current PIN'**
  String get enterCurrentPin;

  /// PIN mismatch error
  ///
  /// In en, this message translates to:
  /// **'PINs do not match. Please try again.'**
  String get pinsDoNotMatch;

  /// PIN length error
  ///
  /// In en, this message translates to:
  /// **'PIN must be 4 digits.'**
  String get pinMustBe4Digits;

  /// Incorrect PIN error
  ///
  /// In en, this message translates to:
  /// **'Incorrect PIN. Please try again.'**
  String get incorrectPin;

  /// PIN enabled success message
  ///
  /// In en, this message translates to:
  /// **'PIN authentication has been enabled'**
  String get pinAuthenticationEnabled;

  /// PIN disabled success message
  ///
  /// In en, this message translates to:
  /// **'PIN authentication has been disabled'**
  String get pinAuthenticationDisabled;

  /// PIN changed success message
  ///
  /// In en, this message translates to:
  /// **'PIN has been changed successfully'**
  String get pinChangedSuccessfully;

  /// Disable PIN auth dialog title
  ///
  /// In en, this message translates to:
  /// **'Disable PIN Authentication'**
  String get disablePinAuth;

  /// Disable PIN auth confirmation message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to disable PIN authentication? You will need to enter your current PIN to confirm.'**
  String get disablePinAuthMessage;

  /// Enter PIN button text
  ///
  /// In en, this message translates to:
  /// **'Enter PIN'**
  String get enterPin;

  /// Too many PIN attempts title
  ///
  /// In en, this message translates to:
  /// **'Too Many Attempts'**
  String get tooManyAttempts;

  /// Too many PIN attempts message
  ///
  /// In en, this message translates to:
  /// **'You have entered the wrong PIN too many times. Please restart the app and try again.'**
  String get tooManyAttemptsMessage;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
        'de',
        'en',
        'es',
        'fr',
        'ja',
        'si',
        'zh'
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'ja':
      return AppLocalizationsJa();
    case 'si':
      return AppLocalizationsSi();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
