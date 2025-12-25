import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nostrrdr/src/app/theme/app_colors.dart';
import 'package:nostrrdr/src/app/widgets/nr_icon_button.dart';
import 'package:nostrrdr/src/app/widgets/nr_text_field.dart';
import 'package:nostrrdr/src/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:nostrrdr/src/features/auth/presentation/bloc/auth_state.dart';

import 'package:flutter/services.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:nostrrdr/src/features/auth/presentation/bloc/auth_event.dart';
import 'package:nostrrdr/src/features/auth/presentation/validators/nsec_validator.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nsecController = TextEditingController();

  @override
  void dispose() {
    _nsecController.dispose();
    super.dispose();
  }

  void _onPaste() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data?.text != null) {
      setState(() {
        _nsecController.text = data!.text!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final isLoading = state is AuthLoading;

        return Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              NrTextField(
                textController: _nsecController,
                label: 'Enter your private key',
                hintText: 'nsec',
                obscureText: true,
                readOnly: isLoading,
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(
                    errorText: 'Please enter your private key',
                  ),
                  NsecValidatorExtension.nsec(),
                ]),
                trailingIcon: NrIconButton(
                  onTap: isLoading ? null : _onPaste,
                  icon: Icons.paste,
                  color: context.colors.onCard,
                ),
              ),
              SizedBox(height: 32.h),
              FilledButton(
                onPressed: isLoading
                    ? null
                    : () {
                        if (_formKey.currentState!.validate()) {
                          context.read<AuthBloc>().add(
                            NsecLoginRequested(_nsecController.text),
                          );
                        }
                      },
                child: isLoading
                    ? SizedBox(
                        height: 20.h,
                        width: 20.h,
                        child: const CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Login'),
              ),
              SizedBox(height: 24.h),
              const OrDivider(),
              SizedBox(height: 24.h),
              FilledButton(
                onPressed: isLoading
                    ? null
                    : () {
                        context.read<AuthBloc>().add(
                          const CreateIdentityRequested(),
                        );
                      },
                child: const Text('Create new identity'),
              ),
              SizedBox(height: 12.h),
              const FilledButton(
                onPressed: null,
                child: Text('Login with Amber'),
              ),
            ],
          ),
        );
      },
    );
  }
}

class OrDivider extends StatelessWidget {
  const OrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Divider()),
        SizedBox(width: 16.w),
        Text('or'),
        SizedBox(width: 16.w),
        Expanded(child: Divider()),
      ],
    );
  }
}
