import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/splash_controller.dart';
import '../utils/color.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _pulseController;
  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;
  late Animation<double> _pulseScale;

  @override
  void initState() {
    super.initState();
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _logoScale = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: Curves.elasticOut,
      ),
    );
    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    _pulseScale = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _logoController.forward().then((_) {
      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted) Get.find<SplashController>().gotoNextView();
      });
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBackground,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              colorBackground,
              colorSurface,
              colorBackground.withValues(alpha: 0.95),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),
              AnimatedBuilder(
                animation: Listenable.merge([_logoController, _pulseController]),
                builder: (context, child) {
                  return Opacity(
                    opacity: _logoOpacity.value,
                    child: Transform.scale(
                      scale: _logoScale.value * _pulseScale.value,
                      child: Material(
                        elevation: 8,
                        shadowColor: colorPrimary.withValues(alpha: 0.4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        color: colorSurface,
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Image.asset(
                            'assets/logo.png',
                            width: 140,
                            height: 140,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              const Spacer(),
              Text(
                'Hala Tree Coffee',
                style: GoogleFonts.roboto(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: colorOnBackground,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: 32,
                height: 3,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: colorPrimary,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const Spacer(flex: 2),
              SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(colorPrimary),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
