import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:studio_project/cars_app/contact/cubit/message_cubit.dart';
import 'package:studio_project/cars_app/contact/model/message_request.dart';
import 'package:studio_project/cars_app/contact/model/messages_api.dart';
import 'package:studio_project/cars_app/core/carzy_theme.dart';

import 'state/message_state.dart';

class ContactMessageScreen extends StatefulWidget {
  const ContactMessageScreen({super.key});

  @override
  State<ContactMessageScreen> createState() => _ContactMessageScreenState();
}

class _ContactMessageScreenState extends State<ContactMessageScreen> {
  final _formKey = GlobalKey<FormState>();

  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _subject = TextEditingController();
  final _message = TextEditingController();

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _email.dispose();
    _phone.dispose();
    _subject.dispose();
    _message.dispose();
    super.dispose();
  }

  String? _required(String? v, String key) {
    if (v == null || v.trim().isEmpty) return key.tr();
    return null;
  }

  String? _emailValidator(String? v) {
    if (v == null || v.trim().isEmpty) return 'contact_email_required'.tr();
    final value = v.trim();
    final ok = RegExp(r"^[^@\s]+@[^@\s]+\.[^@\s]+$").hasMatch(value);
    if (!ok) return 'contact_email_invalid'.tr();
    return null;
  }

  Future<void> _submit(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    final dto = MessageRequest(
      firstName: _firstName.text.trim(),
      lastName: _lastName.text.trim(),
      email: _email.text.trim(),
      phoneNumber: _phone.text.trim().isEmpty ? null : _phone.text.trim(),
      subject: _subject.text.trim(),
      message: _message.text.trim(),
    );

    await context.read<MessageCubit>().send(dto);
  }

  void _clear() {
    _firstName.clear();
    _lastName.clear();
    _email.clear();
    _phone.clear();
    _subject.clear();
    _message.clear();
  }

  InputDecoration _pillDecoration({
    required BuildContext context,
    required String hintKey,
    required IconData icon,
    required double radius,
    required EdgeInsets contentPadding,
    required double focusedBorderWidth,
  }) {
    final isRtl = context.locale.languageCode == 'ar';

    final base = CarZyTheme.fieldDecoration(hint: hintKey.tr());
    final iconWidget = Icon(icon, color: CarZyTheme.muted);

    OutlineInputBorder border(Color c, {double w = 0}) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(radius),
      borderSide: BorderSide(color: c, width: w),
    );

    return base.copyWith(
      // ✅ keep icon on the RIGHT always
      prefixIcon: isRtl ? iconWidget : null,
      suffixIcon: isRtl ? null : iconWidget,

      filled: true,
      fillColor: Colors.white,
      contentPadding: contentPadding,

      border: border(Colors.transparent),
      enabledBorder: border(Colors.transparent),
      focusedBorder: border(CarZyTheme.red, w: focusedBorderWidth),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Web => localhost, Android emulator => 10.0.2.2
    const baseUrl = "http://localhost:5159";

    final mq = MediaQuery.of(context);
    final w = mq.size.width;
    final h = mq.size.height;

    // ---------- Sizes (all from MediaQuery) ----------
    final outerPad = (w * 0.05).clamp(14.0, 22.0);
    final cardPad = (w * 0.045).clamp(14.0, 22.0);
    final gap = (h * 0.014).clamp(10.0, 14.0);
    final tinyGap = (h * 0.008).clamp(6.0, 10.0);

    final cardRadius = (w * 0.06).clamp(18.0, 26.0);
    final fieldRadius = (w * 0.07).clamp(18.0, 26.0);

    final btnH = (h * 0.07).clamp(48.0, 56.0);

    final appBarTitleSize = (w * 0.045).clamp(16.0, 20.0);
    final subtitleSize = (w * 0.036).clamp(12.0, 14.0);

    final fieldHPad = (w * 0.045).clamp(14.0, 18.0);
    final fieldVPad = (h * 0.018).clamp(14.0, 18.0);

    final shadowBlur = (w * 0.045).clamp(12.0, 18.0);
    final shadowOffsetY = (h * 0.012).clamp(8.0, 12.0);

    final loaderSize = (w * 0.055).clamp(18.0, 24.0);
    final loaderStroke = (w * 0.006).clamp(2.0, 3.0);

    final focusedBorderWidth = (w * 0.003).clamp(1.1, 1.6);

    return BlocProvider(
      create: (_) => MessageCubit(api: MessagesApi(baseUrl: baseUrl)),
      child: BlocConsumer<MessageCubit, MessageState>(
        listener: (context, state) {
          if (state.status == MessageStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.successMessage ?? 'contact_success'.tr())),
            );
            _clear();
          } else if (state.status == MessageStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage ?? 'contact_error'.tr())),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state.status == MessageStatus.loading;

          return Scaffold(
            backgroundColor: CarZyTheme.bg,

            // ✅ AppBar title using .tr()
            appBar: AppBar(
              backgroundColor: CarZyTheme.bg,
              elevation: 0,
              centerTitle: true,
              title: Text(
                'contact_headline'.tr(),
                style: TextStyle(
                  fontSize: appBarTitleSize,
                  fontWeight: FontWeight.w900,
                  color: CarZyTheme.textDark,
                ),
              ),
              iconTheme: IconThemeData(color: CarZyTheme.textDark),
            ),

            body: SafeArea(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 520),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(outerPad),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // (Headline moved to AppBar) keep subtitle
                        Text(
                          'contact_subtitle'.tr(),
                          style: TextStyle(
                            fontSize: subtitleSize,
                            color: CarZyTheme.muted,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: gap + tinyGap),

                        Container(
                          padding: EdgeInsets.all(cardPad),
                          decoration: BoxDecoration(
                            color: CarZyTheme.navy,
                            borderRadius: BorderRadius.circular(cardRadius),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: shadowBlur,
                                offset: Offset(0, shadowOffsetY),
                                color: const Color(0x14000000),
                              ),
                            ],
                          ),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                TextFormField(
                                  controller: _firstName,
                                  decoration: _pillDecoration(
                                    context: context,
                                    hintKey: 'contact_first_name',
                                    icon: Icons.person,
                                    radius: fieldRadius,
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: fieldHPad,
                                      vertical: fieldVPad,
                                    ),
                                    focusedBorderWidth: focusedBorderWidth,
                                  ),
                                  validator: (v) => _required(v, 'contact_first_name_required'),
                                ),
                                SizedBox(height: gap),

                                TextFormField(
                                  controller: _lastName,
                                  decoration: _pillDecoration(
                                    context: context,
                                    hintKey: 'contact_last_name',
                                    icon: Icons.person_outline,
                                    radius: fieldRadius,
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: fieldHPad,
                                      vertical: fieldVPad,
                                    ),
                                    focusedBorderWidth: focusedBorderWidth,
                                  ),
                                  validator: (v) => _required(v, 'contact_last_name_required'),
                                ),
                                SizedBox(height: gap),

                                TextFormField(
                                  controller: _email,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: _pillDecoration(
                                    context: context,
                                    hintKey: 'contact_email',
                                    icon: Icons.email,
                                    radius: fieldRadius,
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: fieldHPad,
                                      vertical: fieldVPad,
                                    ),
                                    focusedBorderWidth: focusedBorderWidth,
                                  ),
                                  validator: _emailValidator,
                                ),
                                SizedBox(height: gap),

                                TextFormField(
                                  controller: _phone,
                                  keyboardType: TextInputType.phone,
                                  decoration: _pillDecoration(
                                    context: context,
                                    hintKey: 'contact_phone_optional',
                                    icon: Icons.phone,
                                    radius: fieldRadius,
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: fieldHPad,
                                      vertical: fieldVPad,
                                    ),
                                    focusedBorderWidth: focusedBorderWidth,
                                  ),
                                ),
                                SizedBox(height: gap),

                                TextFormField(
                                  controller: _subject,
                                  decoration: _pillDecoration(
                                    context: context,
                                    hintKey: 'contact_subject',
                                    icon: Icons.subject,
                                    radius: fieldRadius,
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: fieldHPad,
                                      vertical: fieldVPad,
                                    ),
                                    focusedBorderWidth: focusedBorderWidth,
                                  ),
                                  validator: (v) => _required(v, 'contact_subject_required'),
                                ),
                                SizedBox(height: gap),

                                TextFormField(
                                  controller: _message,
                                  maxLines: 5,
                                  decoration: _pillDecoration(
                                    context: context,
                                    hintKey: 'contact_message',
                                    icon: Icons.message,
                                    radius: fieldRadius,
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: fieldHPad,
                                      vertical: fieldVPad,
                                    ),
                                    focusedBorderWidth: focusedBorderWidth,
                                  ),
                                  validator: (v) => _required(v, 'contact_message_required'),
                                ),
                                SizedBox(height: gap + tinyGap),

                                SizedBox(
                                  width: double.infinity,
                                  height: btnH,
                                  child: ElevatedButton(
                                    onPressed: isLoading ? null : () => _submit(context),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: CarZyTheme.red,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(fieldRadius),
                                      ),
                                    ),
                                    child: isLoading
                                        ? SizedBox(
                                      width: loaderSize,
                                      height: loaderSize,
                                      child: CircularProgressIndicator(
                                        strokeWidth: loaderStroke,
                                        color: Colors.white,
                                      ),
                                    )
                                        : Text(
                                      'contact_send'.tr(),
                                      style: const TextStyle(fontWeight: FontWeight.w800),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
