import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

import '../route.dart';
import '../utils/auth_storage.dart';
import '../utils/color.dart';
import '../utils/constants.dart';
import '../utils/password_validator.dart';
import '../webservice/api.dart';
import '../webservice/dio_util.dart';

class ForgotPasswordController extends GetxController {
  final emailCtrl = TextEditingController();
  final loading = false.obs;
  final cache = GetStorage();
  late final Api api;
  String verificationCode = "";

  final formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    api = Api(DioUtil(null).getDio(), baseUrl: DioUtil.mainUrl!);
  }

  @override
  void onClose() {
    emailCtrl.dispose();
    super.onClose();
  }

  void persistCredentials(String email, String password) {
    cache.write(AuthStorage.emailKey, email);
    cache.write(AuthStorage.passwordKey, password);
  }

  Future<void> sendResetRequest() async {
    if (!(formKey.currentState?.validate() ?? false)) return;

    final email = emailCtrl.text.trim();

    final online = await Constants.checkNetwork();
    if (!online) {
      showToastMessage('No internet connection');
      return;
    }

    loading.value = true;
    try {
      final res = await api.requesthalatreeforgotpassword(email);
      if (res.message!="success") {
        showToastMessage(res.message ?? 'Could not send reset email');
        return;
      }
      verificationCode = res.verification_code??"";
      if(verificationCode.length!=6){
        showToastMessage("Something is wrong to send OTP");
      }else{
        showToastMessage(res.message ?? 'OTP sent');
      }
    } catch (_) {
      showToastMessage('Request failed. Please try again.');
      return;
    } finally {
      loading.value = false;
    }
    print(verificationCode);
    await Get.dialog<void>(
      _OtpResetDialog(
        email: email,
        api: api,
        otpCode: verificationCode,
        onSuccess: (newPassword) async {
          persistCredentials(email, newPassword);
          await Get.offAllNamed(RouteName.mainView);
        },
      ),
      barrierDismissible: false,
    );
  }
}

class _OtpResetDialog extends StatefulWidget {
  final String email;
  final Api api;
  final String otpCode;
  final void Function(String newPassword) onSuccess;

  const _OtpResetDialog({
    required this.email,
    required this.api,
    required this.otpCode,
    required this.onSuccess,
  });

  @override
  State<_OtpResetDialog> createState() => _OtpResetDialogState();
}

class _OtpResetDialogState extends State<_OtpResetDialog> {
  final _otpCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  final _saving = ValueNotifier<bool>(false);

  @override
  void dispose() {
    _otpCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    _saving.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final otp = _otpCtrl.text.trim();
    if (otp.isEmpty) {
      showToastMessage('Enter the OTP');
      return;
    }

    final pwdError = PasswordValidator.validateSignupPassword(
      _passwordCtrl.text,
      _confirmCtrl.text,
    );
    if (pwdError != null) {
      showToastMessage(pwdError);
      return;
    }

    final online = await Constants.checkNetwork();
    if (!online) {
      showToastMessage('No internet connection');
      return;
    }

    if(otp != widget.otpCode){
      showToastMessage("Invalid OTP code");
      return;
    }

    _saving.value = true;
    try {
      final res = await widget.api.changepassword(
        widget.email,
        otp,
        _passwordCtrl.text,
      );
      if (res.message != "success") {
        showToastMessage(res.message ?? 'Could not change password');
        return;
      }
      Get.back<void>();
      showToastMessage(res.message ?? 'Password updated');
      Constants.userModel=res.user;
      widget.onSuccess(_passwordCtrl.text);
    } catch (_) {
      showToastMessage('Could not change password. Please try again.');
    } finally {
      _saving.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Reset password',
        style: GoogleFonts.roboto(fontWeight: FontWeight.w600),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Enter the OTP sent to your email, then choose a new password.',
              style: GoogleFonts.roboto(fontSize: 14, color: colorOnSurface),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _otpCtrl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'OTP',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _passwordCtrl,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'New password',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _confirmCtrl,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Confirm password',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back<void>(),
          child: const Text('Cancel'),
        ),
        ValueListenableBuilder<bool>(
          valueListenable: _saving,
          builder: (context, saving, _) {
            return FilledButton(
              onPressed: saving ? null : _save,
              child: saving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Save'),
            );
          },
        ),
      ],
    );
  }
}
