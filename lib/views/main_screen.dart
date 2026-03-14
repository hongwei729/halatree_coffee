import 'package:coffee/controllers/main_controller.dart';
import 'package:coffee/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_fonts/google_fonts.dart';

class MainScreen extends GetView<MainController> {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBackground,
      body: SafeArea(
        child: Column(
          children: [
            // Logo
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Image.asset('assets/logo.png', width: 120, height: 120, fit: BoxFit.contain),
            ),
            // Label
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                'Order For Rckcp',
                style: GoogleFonts.roboto(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: colorOnBackground,
                ),
              ),
            ),
            // 3 action buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                    child: _ActionButton(
                      label: 'Waikiki',
                      onPressed: () {
                        controller.openWaikiki();
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ActionButton(
                      label: 'Kaaawa',
                      onPressed: () {
                        controller.openKaaawa();
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ActionButton(
                      label: 'Shop Online',
                      onPressed: () {
                        controller.openShopOnline();
                      },
                    ),
                  ),
                ],
              ),
            ),
            // Contact Info section
            _ContactSection(controller: controller),
            // News feed (scrollable only here)
            Expanded(
              child: _NewsSection(controller: controller), 
            ),
            // Social icons
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _SocialIcon(icon: FontAwesomeIcons.linkedin, onTap: () {}),
                  const SizedBox(width: 24),
                  _SocialIcon(icon: FontAwesomeIcons.facebook, onTap: () {controller.openUrl("https://www.facebook.com/profile.php?id=61557040718686");}),
                  const SizedBox(width: 24),
                  _SocialIcon(icon: FontAwesomeIcons.instagram, onTap: () {controller.openUrl("https://www.instagram.com/halatreecafe/");}),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const _ActionButton({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12),
        backgroundColor: colorPrimary,
        foregroundColor: colorOnPrimary,
      ),
      child: Text(
        label,
        style: GoogleFonts.roboto(fontSize: 13, fontWeight: FontWeight.w600),
        textAlign: TextAlign.center,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class _ContactSection extends StatelessWidget {
  final MainController controller;

  const _ContactSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorOutline),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Contact Info',
            style: GoogleFonts.roboto(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: colorOnBackground,
            ),
          ),
          const SizedBox(height: 12),
          Obx(() => SegmentedButton<int>(
                segments: [
                  for (int i = 0; i < MainController.shopContacts.length; i++)
                    ButtonSegment<int>(
                      value: i,
                      label: Text(
                        MainController.shopContacts[i].name,
                        style: GoogleFonts.roboto(fontSize: 12),
                      ),
                    ),
                ],
                selected: {controller.selectedShopIndex.value},
                onSelectionChanged: (Set<int> selected) {
                  controller.selectShop(selected.first);
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.resolveWith((states) {
                    if (states.contains(WidgetState.selected)) return colorPrimary;
                    return colorSurface;
                  }),
                  foregroundColor: WidgetStateProperty.resolveWith((states) {
                    if (states.contains(WidgetState.selected)) return colorOnPrimary;
                    return colorOnSurface;
                  }),
                  padding: WidgetStateProperty.all(const EdgeInsets.symmetric(vertical: 10)),
                ),
              )),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: controller.callUs,
                  icon: const Icon(Icons.phone_outlined, size: 18),
                  label: const Text('Call Us'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: colorPrimaryDark,
                    side: const BorderSide(color: colorPrimary),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: controller.emailUs,
                  icon: const Icon(Icons.email_outlined, size: 18),
                  label: const Text('Email Us'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: colorPrimaryDark,
                    side: const BorderSide(color: colorPrimary),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: controller.openWebsite,
                  icon: const Icon(Icons.language, size: 18),
                  label: const Text('Website'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: colorPrimaryDark,
                    side: const BorderSide(color: colorPrimary),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _NewsSection extends StatelessWidget {
  final MainController controller;

  const _NewsSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      decoration: BoxDecoration(
        color: colorSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorOutline),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Text(
              'News',
              style: GoogleFonts.roboto(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: colorOnBackground,
              ),
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: Obx(() {
              if (controller.newsLoading.value) {
                return const Center(child: CircularProgressIndicator(color: colorPrimary));
              }
              final html = controller.newsHtml.value;
              if (html.isEmpty) {
                return Center(
                  child: Text(
                    'No news yet.',
                    style: GoogleFonts.roboto(color: colorOnSurface),
                  ),
                );
              }
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Html(
                  data: html,
                  style: {
                    'body': Style(
                      fontSize: FontSize(14),
                      color: colorOnSurface,
                    ),
                    'p': Style(
                      fontSize: FontSize(14),
                    ),
                  },
                  shrinkWrap: true,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _SocialIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _SocialIcon({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: FaIcon(icon, color: colorPrimaryDark, size: 24),
      style: IconButton.styleFrom(
        backgroundColor: colorSurface,
        side: const BorderSide(color: colorOutline),
      ),
    );
  }
}
