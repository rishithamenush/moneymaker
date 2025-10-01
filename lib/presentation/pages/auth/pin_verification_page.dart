import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
        _errorMessage = 'Incorrect PIN. Please try again.';
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
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Too Many Attempts'),
        content: const Text(
          'You have entered the wrong PIN too many times. Please restart the app and try again.',
        ),
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
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.read<ThemeProvider>();
    final accentColor = ThemeColors.getAccentColor(context, themeProvider.accentColor);
    
    return Scaffold(
      backgroundColor: ThemeColors.getBackground(context),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.paddingL),
          child: Column(
            children: [
              const SizedBox(height: AppDimensions.paddingXL * 2),
              
              // App Logo/Icon
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Icon(
                  Icons.account_balance_wallet,
                  size: 50,
                  color: accentColor,
                ),
              ),
              
              const SizedBox(height: AppDimensions.paddingXL),
              
              // App Name
              Text(
                'Money Maker',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: ThemeColors.getTextPrimary(context),
                ),
              ),
              
              const SizedBox(height: AppDimensions.paddingL),
              
              // Title
              Text(
                'Enter your PIN',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: ThemeColors.getTextPrimary(context),
                ),
              ),
              
              const SizedBox(height: AppDimensions.paddingM),
              
              // Subtitle
              Text(
                'Enter your 4-digit PIN to continue',
                style: TextStyle(
                  fontSize: 16,
                  color: ThemeColors.getTextSecondary(context),
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: AppDimensions.paddingXL * 2),
              
              // PIN Input Fields
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(4, (index) {
                  final isFilled = index < _pin.length;
                  
                  return Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: _errorMessage != null 
                          ? AppColors.error
                          : isFilled 
                            ? accentColor 
                            : ThemeColors.getTextSecondary(context),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      color: isFilled 
                        ? accentColor.withOpacity(0.1)
                        : Colors.transparent,
                    ),
                    child: Center(
                      child: _isLoading && index == 3
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(accentColor),
                            ),
                          )
                        : Text(
                            isFilled ? '●' : '',
                            style: TextStyle(
                              fontSize: 24,
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
                const SizedBox(height: AppDimensions.paddingL),
                Text(
                  _errorMessage!,
                  style: TextStyle(
                    color: AppColors.error,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
              
              const SizedBox(height: AppDimensions.paddingXL * 2),
              
              // Number Pad
              Expanded(
                child: GridView.count(
                  crossAxisCount: 3,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                  childAspectRatio: 1.2,
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
              ),
              
              const SizedBox(height: AppDimensions.paddingL),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNumberButton(String number, Color accentColor) {
    return GestureDetector(
      onTap: _isLoading ? null : () {
        if (_pin.length < 4) {
          _onDigitEntered(number, _pin.length);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: ThemeColors.getCardBackground(context),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: ThemeColors.getBorderColor(context),
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            number,
            style: TextStyle(
              fontSize: 24,
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
      onTap: _isLoading ? null : () {
        if (_pin.isNotEmpty) {
          _onDigitDeleted(_pin.length - 1);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: ThemeColors.getCardBackground(context),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: ThemeColors.getBorderColor(context),
            width: 1,
          ),
        ),
        child: Center(
          child: Icon(
            Icons.backspace_outlined,
            size: 24,
            color: ThemeColors.getTextPrimary(context),
          ),
        ),
      ),
    );
  }
}
