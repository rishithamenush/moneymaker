import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/dimensions.dart';
import '../../../core/utils/theme_colors.dart';
import '../../providers/pin_auth_provider.dart';
import '../../providers/theme_provider.dart';
import '../../widgets/common/custom_app_bar.dart';

class PinSetupPage extends StatefulWidget {
  final bool isChangingPin;
  
  const PinSetupPage({
    super.key,
    this.isChangingPin = false,
  });

  @override
  State<PinSetupPage> createState() => _PinSetupPageState();
}

class _PinSetupPageState extends State<PinSetupPage> {
  final List<TextEditingController> _controllers = List.generate(
    4,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(
    4,
    (index) => FocusNode(),
  );
  
  String _pin = '';
  String _confirmPin = '';
  bool _isConfirming = false;
  bool _isLoading = false;

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
      if (!_isConfirming) {
        _pin += digit;
      } else {
        _confirmPin += digit;
      }
    });

    if (index < 3) {
      _focusNodes[index + 1].requestFocus();
    } else {
      _focusNodes[index].unfocus();
      if (!_isConfirming) {
        _startConfirming();
      } else {
        _completeSetup();
      }
    }
  }

  void _onDigitDeleted(int index) {
    if (index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
    
    setState(() {
      if (!_isConfirming) {
        if (_pin.isNotEmpty) {
          _pin = _pin.substring(0, _pin.length - 1);
        }
      } else {
        if (_confirmPin.isNotEmpty) {
          _confirmPin = _confirmPin.substring(0, _confirmPin.length - 1);
        }
      }
    });
  }

  void _startConfirming() {
    setState(() {
      _isConfirming = true;
      _confirmPin = '';
    });
    
    // Clear controllers and focus first one
    for (var controller in _controllers) {
      controller.clear();
    }
    _focusNodes[0].requestFocus();
  }

  void _completeSetup() async {
    if (_pin != _confirmPin) {
      _showError('PINs do not match. Please try again.');
      _resetPin();
      return;
    }

    if (_pin.length != 4) {
      _showError('PIN must be 4 digits.');
      _resetPin();
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final pinProvider = context.read<PinAuthProvider>();
    final success = await pinProvider.enablePinAuth(_pin);

    setState(() {
      _isLoading = false;
    });

    if (success && mounted) {
      Navigator.pop(context, true);
    } else {
      _showError('Failed to set PIN. Please try again.');
      _resetPin();
    }
  }

  void _resetPin() {
    setState(() {
      _pin = '';
      _confirmPin = '';
      _isConfirming = false;
    });
    
    for (var controller in _controllers) {
      controller.clear();
    }
    _focusNodes[0].requestFocus();
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
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
      appBar: CustomAppBar(
        title: widget.isChangingPin ? 'Change PIN' : 'Set PIN',
        showBackButton: true,
      ),
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Icon
                    Container(
                      width: isSmallScreen ? 60 : 80,
                      height: isSmallScreen ? 60 : 80,
                      decoration: BoxDecoration(
                        color: accentColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(isSmallScreen ? 15 : 20),
                      ),
                      child: Icon(
                        Icons.lock_outline,
                        size: isSmallScreen ? 30 : 40,
                        color: accentColor,
                      ),
                    ),
                    
                    SizedBox(height: isSmallScreen ? AppDimensions.paddingL : AppDimensions.paddingXL),
                    
                    // Title
                    Text(
                      widget.isChangingPin ? 'Change Your PIN' : 'Set Up PIN Authentication',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 20 : 24,
                        fontWeight: FontWeight.bold,
                        color: ThemeColors.getTextPrimary(context),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    SizedBox(height: AppDimensions.paddingS),
                    
                    // Subtitle
                    Text(
                      _isConfirming 
                        ? 'Confirm your PIN'
                        : 'Enter a 4-digit PIN to secure your app',
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
                        final currentPin = _isConfirming ? _confirmPin : _pin;
                        final isFilled = index < currentPin.length;
                        
                        return Container(
                          width: isSmallScreen ? 50 : 60,
                          height: isSmallScreen ? 50 : 60,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: isFilled ? accentColor : ThemeColors.getTextSecondary(context),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(isSmallScreen ? 10 : 12),
                            color: isFilled 
                              ? accentColor.withOpacity(0.1)
                              : Colors.transparent,
                          ),
                          child: Center(
                            child: Text(
                              isFilled ? '●' : '',
                              style: TextStyle(
                                fontSize: isSmallScreen ? 20 : 24,
                                color: accentColor,
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
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
              
              if (_isLoading)
                Padding(
                  padding: const EdgeInsets.all(AppDimensions.paddingM),
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(accentColor),
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
      onTap: () {
        final currentIndex = _isConfirming ? _confirmPin.length : _pin.length;
        if (currentIndex < 4) {
          _onDigitEntered(number, currentIndex);
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
      onTap: () {
        final currentIndex = _isConfirming ? _confirmPin.length : _pin.length;
        if (currentIndex > 0) {
          _onDigitDeleted(currentIndex - 1);
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
