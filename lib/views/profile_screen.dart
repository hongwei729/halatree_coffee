import 'package:coffee/utils/color.dart';
import 'package:coffee/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final u = Constants.userModel;
    return Scaffold(
      backgroundColor: colorBackground,
      appBar: AppBar(
        title: Text('Profile', style: GoogleFonts.roboto(fontWeight: FontWeight.w600)),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          children: [
            if (u == null)
              Text(
                'No profile data.',
                style: GoogleFonts.roboto(fontSize: 16, color: colorOnSurface),
              )
            else ...[
              _ProfileRow(label: 'Email', value: u.email ?? '—'),
              _ProfileRow(label: 'First name', value: u.first_name ?? '—'),
              _ProfileRow(label: 'Last name', value: u.last_name ?? '—'),
              _ProfileRow(label: 'Current points', value: u.total_points ?? '—'),
            ],
          ],
        ),
      ),
    );
  }
}

class _ProfileRow extends StatelessWidget {
  final String label;
  final String value;

  const _ProfileRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.roboto(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: colorOnSurface.withValues(alpha: 0.85),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.roboto(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: colorOnBackground,
            ),
          ),
        ],
      ),
    );
  }
}
