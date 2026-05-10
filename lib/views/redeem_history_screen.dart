import 'package:coffee/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RedeemHistoryScreen extends StatelessWidget {
  const RedeemHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBackground,
      appBar: AppBar(
        title: Text('Redeem history', style: GoogleFonts.roboto(fontWeight: FontWeight.w600)),
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              'Your redeem history will appear here when available.',
              textAlign: TextAlign.center,
              style: GoogleFonts.roboto(fontSize: 16, color: colorOnSurface),
            ),
          ),
        ),
      ),
    );
  }
}
