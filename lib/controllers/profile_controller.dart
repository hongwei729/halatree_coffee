import 'package:coffee/models/user_model.dart';
import 'package:coffee/route.dart';
import 'package:coffee/utils/auth_storage.dart';
import 'package:coffee/utils/color.dart';
import 'package:coffee/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileController extends GetxController {
  final cache = GetStorage();

  final Rxn<UserModel> user = Rxn<UserModel>();

  @override
  void onInit() {
    super.onInit();
    refreshFromConstants();
  }

  void refreshFromConstants() {
    user.value = Constants.userModel;
    user.refresh();
  }

  /// Password from [Constants.userModel] when the API returns it, otherwise the cached login password.
  String? get _expectedPassword {
    final fromModel = Constants.userModel?.password;
    if (fromModel != null && fromModel.isNotEmpty) return fromModel;
    final cached = cache.read(AuthStorage.passwordKey)?.toString();
    if (cached != null && cached.isNotEmpty) return cached;
    return null;
  }

  void onEditProfilePressed() {
    final expected = _expectedPassword;
    if (expected == null) {
      showToastMessage('Unable to verify your password. Please sign in again.');
      return;
    }

    Get.dialog<void>(
      _ConfirmPasswordDialog(
        expectedPassword: expected,
        onVerified: _openEditProfile,
      ),
    );
  }

  Future<void> _openEditProfile() async {
    await Get.toNamed(RouteName.profileEditView);
    // GetX does not always deliver `Get.back(result: …)` to `toNamed`'s future; sync from [Constants.userModel] whenever the edit route is popped.
    refreshFromConstants();
  }
}

class _ConfirmPasswordDialog extends StatefulWidget {
  final String expectedPassword;
  final Future<void> Function() onVerified;

  const _ConfirmPasswordDialog({
    required this.expectedPassword,
    required this.onVerified,
  });

  @override
  State<_ConfirmPasswordDialog> createState() => _ConfirmPasswordDialogState();
}

class _ConfirmPasswordDialogState extends State<_ConfirmPasswordDialog> {
  late final TextEditingController _pwdCtrl;
  bool _obscure = true;

  @override
  void initState() {
    super.initState();
    _pwdCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _pwdCtrl.dispose();
    super.dispose();
  }

  void _onContinue() {
    if (_pwdCtrl.text != widget.expectedPassword) {
      showToastMessage('Incorrect password');
      return;
    }
    Get.back<void>();
    widget.onVerified();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        'Confirm password',
        style: GoogleFonts.roboto(fontWeight: FontWeight.w600),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Enter your account password to edit your profile.',
            style: GoogleFonts.roboto(fontSize: 14, color: colorOnSurface),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _pwdCtrl,
            obscureText: _obscure,
            decoration: InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              suffixIcon: IconButton(
                icon: Icon(_obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                onPressed: () => setState(() => _obscure = !_obscure),
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back<void>(),
          child: Text('Cancel', style: GoogleFonts.roboto(color: colorOnSurface)),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: colorPrimaryDark,
            foregroundColor: colorOnPrimary,
          ),
          onPressed: _onContinue,
          child: Text('Continue', style: GoogleFonts.roboto(fontWeight: FontWeight.w600)),
        ),
      ],
    );
  }
}
