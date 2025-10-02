import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/dimensions.dart';
import '../../../core/utils/theme_colors.dart';
import '../../providers/pin_auth_provider.dart';
import '../../providers/theme_provider.dart';
import '../../../app/routes.dart';

class PinVerificationPage extends StatefulWidget {
  const PinVerificationPage({super.key});

  @override
  State<PinVerificationPage> createState() => _PinVerificationPageState();
}

class _PinVerificationPageState extends State<PinVerificationPage> {
  final List<TextEditingController> _controllers = List.generate(
    4,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(
    4,
    (index) => FocusNode(),
  );
  
  String _pin = '';
  int _attempts = 0;
  bool _isLoading = false;
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
      _verifyPin();
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

  void _verifyPin() async {
    if (_pin.length != 4) return;

    setState(() {
      _isLoading = true;
    });

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    final pinProvider = context.read<PinAuthProvider>();
    final isValid = pinProvider.verifyPin(_pin);

    setState(() {
      _isLoading = false;
    });

    if (isValid) {
      // PIN is correct, navigate to home
      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.home);
      }
    } else {
      // PIN is incorrect
      setState(() {
        _attempts++;
        _errorMessage = AppLocalizations.of(context)!.incorrectPin;
        _pin = '';
      });
      
      // Clear controllers and focus first one
      for (var controller in _controllers) {
        controller.clear();
      }
      _focusNodes[0].requestFocus();

      // Show error message
      if (_attempts >= 3) {
        _showMaxAttemptsDialog();
      }
    }
  }

  void _showMaxAttemptsDialog() {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(l10n.tooManyAttempts),
        content: Text(l10n.tooManyAttemptsMessage),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Exit the app or restart
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.splash,
                (route) => false,
              );
            },
            child: Text(l10n.ok),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.read<ThemeProvider>();
    final accentColor = ThemeColors.getAccentColor(context, themeProvider.accentColor);
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenHeight < 700;
    
    return Scaffold(
      backgroundColor: ThemeColors.getBackground(context),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingL,
            vertical: isSmallScreen ? AppDimensions.paddingM : AppDimensions.paddingL,
          ),
          child: Column(
            children: [
              // Header Section
              Expanded(
                flex: 2,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    // App Logo/Icon
                    Container(
                      width: isSmallScreen ? 80 : 100,
                      height: isSmallScreen ? 80 : 100,
                      decoration: BoxDecoration(
                        color: accentColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(isSmallScreen ? 20 : 25),
                      ),
                      child: Icon(
                        Icons.account_balance_wallet,
                        size: isSmallScreen ? 40 : 50,
                        color: accentColor,
                      ),
                    ),
                    
                    SizedBox(height: isSmallScreen ? AppDimensions.paddingL : AppDimensions.paddingXL),
                    
                    // App Name
                    Text(
                      'Money Maker',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 24 : 28,
                        fontWeight: FontWeight.bold,
                        color: ThemeColors.getTextPrimary(context),
                      ),
                    ),
                    
                    SizedBox(height: AppDimensions.paddingS),
                    
                    // Title
                    Text(
                      'Enter your PIN',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 18 : 20,
                        fontWeight: FontWeight.w600,
                        color: ThemeColors.getTextPrimary(context),
                      ),
                    ),
                    
                    SizedBox(height: AppDimensions.paddingS),
                    
                    // Subtitle
                    Text(
                      'Enter your 4-digit PIN to continue',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 14 : 16,
                        color: ThemeColors.getTextSecondary(context),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    SizedBox(height: isSmallScreen ? AppDimensions.paddingL : AppDimensions.paddingXL),
                    
                    // PIN Input Fields
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(4, (index) {
                        final isFilled = index < _pin.length;
                        
                        return Container(
                          width: isSmallScreen ? 50 : 60,
                          height: isSmallScreen ? 50 : 60,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: _errorMessage != null 
                                ? AppColors.error
                                : isFilled 
                                  ? accentColor 
                                  : ThemeColors.getTextSecondary(context),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(isSmallScreen ? 10 : 12),
                            color: isFilled 
                              ? accentColor.withOpacity(0.1)
                              : Colors.transparent,
                          ),
                          child: Center(
                            child: _isLoading && index == 3
                              ? SizedBox(
                                  width: isSmallScreen ? 16 : 20,
                                  height: isSmallScreen ? 16 : 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(accentColor),
                                  ),
                                )
                              : Text(
                                  isFilled ? '●' : '',
                                  style: TextStyle(
                                    fontSize: isSmallScreen ? 20 : 24,
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
                      SizedBox(height: AppDimensions.paddingM),
                      Text(
                        _errorMessage!,
                        style: TextStyle(
                          color: AppColors.error,
                          fontSize: isSmallScreen ? 12 : 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                    ],
                  ),
                ),
              ),
              
              // Number Pad Section
              Expanded(
                flex: 3,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isSmallScreen ? AppDimensions.paddingM : AppDimensions.paddingL,
                  ),
                  child: GridView.count(
                    crossAxisCount: 3,
                    mainAxisSpacing: isSmallScreen ? 12 : 16,
                    crossAxisSpacing: isSmallScreen ? 12 : 16,
                    childAspectRatio: isSmallScreen ? 1.0 : 1.1,
                    children: [
                      // Numbers 1-9
                      ...List.generate(9, (index) {
                        final number = (index + 1).toString();
                        return _buildNumberButton(number, accentColor, isSmallScreen);
                      }),
                      
                      // Empty space
                      const SizedBox(),
                      
                      // Number 0
                      _buildNumberButton('0', accentColor, isSmallScreen),
                      
                      // Delete button
                      _buildDeleteButton(accentColor, isSmallScreen),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNumberButton(String number, Color accentColor, bool isSmallScreen) {
    return GestureDetector(
      onTap: _isLoading ? null : () {
        if (_pin.length < 4) {
          _onDigitEntered(number, _pin.length);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: ThemeColors.getCardBackground(context),
          borderRadius: BorderRadius.circular(isSmallScreen ? 8 : 12),
          border: Border.all(
            color: ThemeColors.getBorderColor(context),
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            number,
            style: TextStyle(
              fontSize: isSmallScreen ? 20 : 24,
              fontWeight: FontWeight.w600,
              color: ThemeColors.getTextPrimary(context),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDeleteButton(Color accentColor, bool isSmallScreen) {
    return GestureDetector(
      onTap: _isLoading ? null : () {
        if (_pin.isNotEmpty) {
          _onDigitDeleted(_pin.length - 1);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: ThemeColors.getCardBackground(context),
          borderRadius: BorderRadius.circular(isSmallScreen ? 8 : 12),
          border: Border.all(
            color: ThemeColors.getBorderColor(context),
            width: 1,
          ),
        ),
        child: Center(
          child: Icon(
            Icons.backspace_outlined,
            size: isSmallScreen ? 20 : 24,
            color: ThemeColors.getTextPrimary(context),
          ),
        ),
      ),
    );
  }
}
