import 'package:coffee/controllers/main_controller.dart';
import 'package:coffee/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MainScreen extends GetView<MainController> {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBackground,
      body: SafeArea(
        child: _AnimatedLogoLayout(
          onLoyaltyProgramPressed: () => controller.openLoyaltyProgram(),
          child: Column(
            children: [
              // Placeholder for logo + Pickup label + Loyalty button
              const SizedBox(height: 16 + 120 + 8 + 24 + 8 + 40),
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
                        onPressed: () => _showKaaawaHoursDialog(context, controller),
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
                padding: EdgeInsets.only(top: 1, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _SocialIcon(icon: FontAwesomeIcons.facebook, onTap: () {controller.openUrl("https://www.facebook.com/profile.php?id=61557040718686");}),
                    const SizedBox(width: 24),
                    _SocialIcon(icon: FontAwesomeIcons.instagram, onTap: () {controller.openUrl("https://www.instagram.com/halatreecafe/");}),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Layout that shows the logo animating from center (splash position) to top.
class _AnimatedLogoLayout extends StatefulWidget {
  final Widget child;
  final VoidCallback? onLoyaltyProgramPressed;

  const _AnimatedLogoLayout({
    required this.child,
    this.onLoyaltyProgramPressed,
  });

  @override
  State<_AnimatedLogoLayout> createState() => _AnimatedLogoLayoutState();
}

class _AnimatedLogoLayoutState extends State<_AnimatedLogoLayout>
    with SingleTickerProviderStateMixin {
  static const double _logoStartSize = 140.0;
  static const double _logoEndSize = 120.0;
  static const double _topPadding = 16.0;

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final padding = MediaQuery.paddingOf(context);
    final safeHeight = size.height - padding.top - padding.bottom;
    final centerY = (safeHeight / 2) - (_logoStartSize / 2);
    final endY = _topPadding;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        AnimatedBuilder(
          animation: _animation,
          builder: (context, _) => Opacity(
            opacity: _animation.value,
            child: widget.child,
          ),
        ),
        AnimatedBuilder(
          animation: _animation,
          builder: (context, _) {
            final t = _animation.value;
            final top = centerY + (endY - centerY) * t;
            final logoSize = _logoStartSize + (_logoEndSize - _logoStartSize) * t;
            return Positioned(
              left: 0,
              right: 0,
              top: top,
              child: Center(
                child: SizedBox(
                  width: logoSize,
                  height: logoSize,
                  child: Image.asset(
                    'assets/logo.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            );
          },
        ),
        // Loyalty Program button directly under the logo
        AnimatedBuilder(
          animation: _animation,
          builder: (context, _) {
            final t = _animation.value;
            const buttonHeight = 48.0;
            const gap = 8.0;
            final top = _topPadding + _logoEndSize + gap;
            return Positioned(
              left: 24,
              right: 24,
              top: top,
              child: Opacity(
                opacity: t.clamp(0.0, 1.0),
                child: _ActionButton(
                  label: 'Loyalty Program',
                  onPressed: widget.onLoyaltyProgramPressed ?? () {},
                ),
              ),
            );
          },
        ),
        // "Pickup" label below the Loyalty Program button
        AnimatedBuilder(
          animation: _animation,
          builder: (context, _) {
            final t = _animation.value;
            const buttonHeight = 48.0;
            const gap = 8.0;
            final top = _topPadding + _logoEndSize + gap + buttonHeight + gap;
            return Positioned(
              left: 0,
              right: 0,
              top: top,
              child: Opacity(
                opacity: t.clamp(0.0, 1.0),
                child: Text(
                  'Pickup',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.roboto(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: colorOnBackground,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

void _showKaaawaHoursDialog(BuildContext context, MainController controller) {
  showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(
        'Kaaawa hours',
        style: GoogleFonts.roboto(fontWeight: FontWeight.w600),
      ),
      content: Text(
        MainController.kaaawaHoursMessage,
        style: GoogleFonts.roboto(fontSize: 14),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
        FilledButton(
          onPressed: () {
            Navigator.of(context).pop();
            controller.openKaaawa();
          },
          child: const Text('Order Online'),
        ),
      ],
    ),
  );
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
        backgroundColor: colorPrimaryDark,
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
          Obx(() {
            if (controller.locationLoading.value) {
              return Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 12),
                child: LinearProgressIndicator(
                  color: colorPrimary,
                  backgroundColor: colorOutline.withValues(alpha: 0.3),
                ),
              );
            }
            return const SizedBox(height: 12);
          }),
          Obx(() => SegmentedButton<int>(
                showSelectedIcon: false,
                segments: [
                  for (int i = 0; i < MainController.shopContacts.length; i++)
                    ButtonSegment<int>(
                      value: i,
                      label: Center(
                        child: Text(
                          MainController.shopContacts[i].name,
                          style: GoogleFonts.roboto(fontSize: 12),
                          textAlign: TextAlign.center,
                          softWrap: true,
                          maxLines: null,
                        ),
                      ),
                    ),
                ],
                selected: {controller.selectedShopIndex.value},
                onSelectionChanged: (Set<int> selected) {
                  controller.selectShop(selected.first);
                },
                style: ButtonStyle(
                  alignment: Alignment.center,
                  backgroundColor: WidgetStateProperty.resolveWith((states) {
                    if (states.contains(WidgetState.selected)) return colorPrimaryDark;
                    return colorSurface;
                  }),
                  foregroundColor: WidgetStateProperty.resolveWith((states) {
                    if (states.contains(WidgetState.selected)) return colorOnPrimary;
                    return colorOnSurface;
                  }),
                  padding: WidgetStateProperty.all(const EdgeInsets.symmetric(vertical: 10)),
                ),
              )),
          Obx(() {
            if (controller.selectedShopIndex.value != MainController.kaaawaShopIndex) {
              return const SizedBox.shrink();
            }
            return Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                MainController.kaaawaHoursMessage,
                style: GoogleFonts.roboto(
                  fontSize: 12,
                  color: colorOnSurface.withValues(alpha: 0.85),
                ),
                textAlign: TextAlign.center,
              ),
            );
          }),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: controller.callUs,
                  icon: const Icon(Icons.phone_outlined, size: 18),
                  label: const Text('Call Us'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: colorOnBackground,
                    side: const BorderSide(color: colorPrimaryDark),
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
                    foregroundColor: colorOnBackground,
                    side: const BorderSide(color: colorPrimaryDark),
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
                    foregroundColor: colorOnBackground,
                    side: const BorderSide(color: colorPrimaryDark),
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
            padding: const EdgeInsets.fromLTRB(16, 8, 8, 6),
            child: Row(
              children: [
                Text(
                  'News',
                  style: GoogleFonts.roboto(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: colorOnBackground,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: controller.reloadNews,
                  icon: const Icon(Icons.refresh),
                  color: colorOnBackground,
                  style: IconButton.styleFrom(
                    padding: const EdgeInsets.all(4),
                    minimumSize: const Size(36, 36),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: Obx(() {
              if (controller.newsLoading.value) {
                return const Center(child: CircularProgressIndicator(color: colorPrimary));
              }
              final url = controller.newsUrl.value;
              if (url.isEmpty) {
                return _newsUnavailableMessage();
              }
              final webController = controller.newsWebViewController;
              if (webController == null) {
                return _newsUnavailableMessage();
              }
              return WebViewWidget(controller: webController);
            }),
          ),
        ],
      ),
    );
  }
}

Widget _newsUnavailableMessage() {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Text(
        'News will be shown when it\'s available.',
        textAlign: TextAlign.center,
        style: GoogleFonts.roboto(color: colorOnSurface, fontSize: 14),
      ),
    ),
  );
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
