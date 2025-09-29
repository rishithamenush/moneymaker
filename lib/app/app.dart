import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../presentation/providers/theme_provider.dart';
import '../presentation/providers/language_provider.dart';
import '../presentation/providers/auth_provider.dart';
import '../presentation/providers/expense_provider.dart';
import '../presentation/providers/budget_provider.dart';
import '../presentation/providers/category_provider.dart';
import '../presentation/providers/income_provider.dart';
import '../presentation/navigation/app_router.dart';
import '../core/theme/app_theme.dart';
import 'routes.dart';
import '../domain/usecases/expense/get_expenses.dart';
import '../domain/usecases/expense/add_expense.dart';
import '../domain/usecases/expense/update_expense.dart';
import '../domain/usecases/expense/delete_expense.dart';
import '../domain/usecases/budget/get_budget.dart';
import '../domain/usecases/budget/create_budget.dart';
import '../domain/usecases/budget/update_budget.dart';
import '../domain/usecases/category/get_categories.dart';
import '../domain/usecases/category/add_category.dart';
import '../domain/usecases/category/delete_category.dart';
import '../domain/usecases/income/get_incomes.dart';
import '../domain/usecases/income/add_income.dart';
import '../domain/usecases/income/update_income.dart';
import '../domain/usecases/income/delete_income.dart';
import '../data/repositories/expense_repository_impl.dart';
import '../data/repositories/budget_repository_impl.dart';
import '../data/repositories/category_repository_impl.dart';
import '../data/repositories/income_repository_impl.dart';

class MoneyMakerApp extends StatelessWidget {
  const MoneyMakerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
              ChangeNotifierProvider(
                create: (_) => ExpenseProvider(
                  getExpenses: GetExpenses(ExpenseRepositoryImpl()),
                  addExpense: AddExpense(ExpenseRepositoryImpl()),
                  updateExpense: UpdateExpense(ExpenseRepositoryImpl()),
                  deleteExpense: DeleteExpense(ExpenseRepositoryImpl()),
                ),
              ),
              ChangeNotifierProvider(
                create: (_) => BudgetProvider(
                  getBudget: GetBudget(BudgetRepositoryImpl()),
                  createBudget: CreateBudget(BudgetRepositoryImpl()),
                  updateBudget: UpdateBudget(BudgetRepositoryImpl()),
                ),
              ),
              ChangeNotifierProvider(
                create: (_) => CategoryProvider(
                  getCategories: GetCategories(CategoryRepositoryImpl()),
                  addCategory: AddCategory(CategoryRepositoryImpl()),
                  deleteCategory: DeleteCategory(CategoryRepositoryImpl()),
                ),
              ),
              ChangeNotifierProvider(
                create: (_) => IncomeProvider(
                  getIncomes: GetIncomes(IncomeRepositoryImpl()),
                  addIncome: AddIncome(IncomeRepositoryImpl()),
                  updateIncome: UpdateIncome(IncomeRepositoryImpl()),
                  deleteIncome: DeleteIncome(IncomeRepositoryImpl()),
                ),
              ),
      ],
      child: Consumer2<ThemeProvider, LanguageProvider>(
        builder: (context, themeProvider, languageProvider, child) {
          // Show loading screen while providers are initializing
          if (!themeProvider.isInitialized || !languageProvider.isInitialized) {
            return MaterialApp(
              title: 'Money Maker',
              theme: AppTheme.lightTheme('Orange'),
              darkTheme: AppTheme.darkTheme('Orange'),
              home: const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
              debugShowCheckedModeBanner: false,
            );
          }
          
          return MaterialApp(
            title: 'Money Maker',
            theme: AppTheme.lightTheme(themeProvider.accentColor),
            darkTheme: AppTheme.darkTheme(themeProvider.accentColor),
            themeMode: themeProvider.themeMode,
            locale: languageProvider.locale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: LanguageProvider.supportedLocales,
            initialRoute: AppRoutes.splash,
            onGenerateRoute: AppRouter.generateRoute,
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}

