import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/dimensions.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/theme_colors.dart';
import '../../../app/routes.dart';
import '../../providers/theme_provider.dart';
import '../../providers/pin_auth_provider.dart';
import '../auth/pin_verification_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _progressController;
  late AnimationController _fadeController;

  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoRotationAnimation;
  late Animation<double> _textSlideAnimation;
  late Animation<double> _progressAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startSplashSequence();
  }

  void _initializeAnimations() {
    // Logo animations
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _logoScaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.elasticOut,
    ));

    _logoRotationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: const Interval(0.0, 0.5, curve: Curves.easeInOut),
    ));

    // Text animation
    _textController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _textSlideAnimation = Tween<double>(
      begin: 50.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeOutCubic,
    ));

    // Progress animation
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeInOut,
    ));

    // Fade animation
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    ));
  }

  void _startSplashSequence() async {
    // Start logo animation
    _logoController.forward();
    
    // Wait a bit then start text animation
    await Future.delayed(const Duration(milliseconds: 500));
    _textController.forward();
    
    // Start progress animation
    await Future.delayed(const Duration(milliseconds: 300));
    _progressController.forward();
    
    // Start fade animation for additional elements
    await Future.delayed(const Duration(milliseconds: 500));
    _fadeController.forward();
    
    // Wait for all animations to complete and navigate
    await Future.delayed(const Duration(milliseconds: 1500));
    _navigateToHome();
  }

  void _navigateToHome() {
    final pinProvider = context.read<PinAuthProvider>();
    
    // Check if PIN authentication is enabled
    if (pinProvider.isEnabled) {
      // Show PIN verification popup
      _showPinVerificationPopup();
    } else {
      // Navigate directly to home page
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    }
  }

  void _showPinVerificationPopup() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _PinVerificationDialog(
        onVerified: (pin) {
          Navigator.pop(context); // Close dialog
          Navigator.pushReplacementNamed(context, AppRoutes.home);
        },
        onCancel: () {
          // Don't allow canceling - user must enter PIN
        },
      ),
    );
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _progressController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.getAccentColor(context, context.read<ThemeProvider>().accentColor),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFF6B35), // Bright orange
              Color(0xFFFF8E53), // Light orange
              Color(0xFFE55A2B), // Dark orange
            ],
            stops: [0.0, 0.6, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Floating elements
            ..._buildFloatingElements(),
            
            // Main content - properly centered
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo Section
                  AnimatedBuilder(
                    animation: _logoController,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _logoScaleAnimation.value,
                        child: Transform.rotate(
                          angle: _logoRotationAnimation.value * 2 * 3.14159,
                          child: _buildLogo(),
                        ),
                      );
                    },
                  ),
                  
                  const SizedBox(height: AppDimensions.paddingXL),
                  
                  // App Name
                  AnimatedBuilder(
                    animation: _textController,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, _textSlideAnimation.value),
                        child: _buildAppName(),
                      );
                    },
                  ),
                  
                  const SizedBox(height: AppDimensions.paddingS),
                  
                  // Tagline
                  AnimatedBuilder(
                    animation: _fadeController,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _fadeAnimation.value,
                        child: _buildTagline(),
                      );
                    },
                  ),
                  
                  const SizedBox(height: AppDimensions.paddingXL * 2),
                  
                  // Progress Section
                  AnimatedBuilder(
                    animation: _fadeController,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _fadeAnimation.value,
                        child: _buildProgressSection(),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.1),
            blurRadius: 30,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background circle
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFFFFFFFF), // White
                  Color(0xFFF5F5F5), // Light gray
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(50),
            ),
          ),
          // Wallet icon
          const Icon(
            Icons.account_balance_wallet,
            size: 50,
            color: Color(0xFFFF6B35), // Orange color
          ),
          // Animated rings
          AnimatedBuilder(
            animation: _logoController,
            builder: (context, child) {
              return CustomPaint(
                size: const Size(120, 120),
                painter: RingPainter(
                  progress: _logoController.value,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAppName() {
    return Column(
      children: [
        Text(
          'Money Maker',
          style: AppTheme.lightTheme('Orange').textTheme.headlineLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 36,
            letterSpacing: 1.5,
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.3),
                offset: const Offset(0, 2),
                blurRadius: 4,
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Container(
          height: 4,
          width: 80,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Colors.white, Colors.white70],
            ),
            borderRadius: BorderRadius.circular(2),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(0.3),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTagline() {
    return Text(
      'Manage Your Finances Smartly',
      style: AppTheme.lightTheme('Orange').textTheme.bodyLarge?.copyWith(
        color: Colors.white.withOpacity(0.9),
        fontSize: 16,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildProgressSection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Progress bar
        Container(
          width: 250,
          height: 6,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(3),
          ),
          child: AnimatedBuilder(
            animation: _progressAnimation,
            builder: (context, child) {
              return FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: _progressAnimation.value,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.white, Colors.white70],
                    ),
                    borderRadius: BorderRadius.circular(3),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        
        const SizedBox(height: AppDimensions.paddingM),
        
        // Loading text
        Text(
          'Loading...',
          style: AppTheme.lightTheme('Orange').textTheme.bodyMedium?.copyWith(
            color: Colors.white.withOpacity(0.9),
            fontSize: 16,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  List<Widget> _buildFloatingElements() {
    return [
      // Floating coins
      Positioned(
        top: 120,
        left: 50,
        child: AnimatedBuilder(
          animation: _fadeController,
          builder: (context, child) {
            return Opacity(
              opacity: _fadeAnimation.value * 0.8,
              child: Transform.rotate(
                angle: _logoController.value * 2 * 3.14159,
                child: const Icon(
                  Icons.monetization_on,
                  color: Color(0xFFFF8E53), // Light orange
                  size: 35,
                ),
              ),
            );
          },
        ),
      ),
      
      Positioned(
        top: 220,
        right: 60,
        child: AnimatedBuilder(
          animation: _fadeController,
          builder: (context, child) {
            return Opacity(
              opacity: _fadeAnimation.value * 0.7,
              child: Transform.rotate(
                angle: -_logoController.value * 2 * 3.14159,
                child: const Icon(
                  Icons.savings,
                  color: Color(0xFFFF8E53), // Light orange
                  size: 30,
                ),
              ),
            );
          },
        ),
      ),
      
      Positioned(
        bottom: 170,
        left: 80,
        child: AnimatedBuilder(
          animation: _fadeController,
          builder: (context, child) {
            return Opacity(
              opacity: _fadeAnimation.value * 0.8,
              child: Transform.rotate(
                angle: _logoController.value * 3.14159,
                child: const Icon(
                  Icons.trending_up,
                  color: Color(0xFFFF8E53), // Light orange
                  size: 32,
                ),
              ),
            );
          },
        ),
      ),
      
      Positioned(
        bottom: 220,
        right: 40,
        child: AnimatedBuilder(
          animation: _fadeController,
          builder: (context, child) {
            return Opacity(
              opacity: _fadeAnimation.value * 0.6,
              child: Transform.rotate(
                angle: -_logoController.value * 1.5 * 3.14159,
                child: const Icon(
                  Icons.account_balance,
                  color: Color(0xFFFF8E53), // Light orange
                  size: 38,
                ),
              ),
            );
          },
        ),
      ),
    ];
  }
}

class RingPainter extends CustomPainter {
  final double progress;

  RingPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;

    // Outer ring
    final outerPaint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    canvas.drawCircle(center, radius, outerPaint);

    // Animated inner ring
    final innerPaint = Paint()
      ..color = Colors.white.withOpacity(0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;

    final sweepAngle = 2 * 3.14159 * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - 5),
      -3.14159 / 2, // Start from top
      sweepAngle,
      false,
      innerPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is RingPainter && oldDelegate.progress != progress;
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
      // PIN is correct
      widget.onVerified(_pin);
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
    
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // App Logo/Icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.account_balance_wallet,
                size: 40,
                color: accentColor,
              ),
            ),
            
            const SizedBox(height: 16),
            
            // App Name
            Text(
              'Money Maker',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: ThemeColors.getTextPrimary(context),
              ),
            ),
            
            const SizedBox(height: 8),
            
            // Title
            Text(
              'Enter your PIN',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: ThemeColors.getTextPrimary(context),
              ),
            ),
            
            const SizedBox(height: 8),
            
            // Subtitle
            Text(
              'Enter your 4-digit PIN to continue',
              style: TextStyle(
                fontSize: 14,
                color: ThemeColors.getTextSecondary(context),
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 24),
            
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
                    child: _isLoading && index == 3
                      ? SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(accentColor),
                          ),
                        )
                      : Text(
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
                  fontSize: 12,
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
          ],
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
      onTap: _isLoading ? null : () {
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
            size: 18,
            color: ThemeColors.getTextPrimary(context),
          ),
        ),
      ),
    );
  }
}
