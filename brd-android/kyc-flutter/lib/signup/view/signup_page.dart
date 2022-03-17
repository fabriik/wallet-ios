import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kyc/common/dependency_provider.dart';
import 'package:kyc/kyc/view/kyc_page.dart';
import 'package:kyc/login/login.dart';
import 'package:kyc/utils/form_validator.dart';
import 'package:kyc/widgets/bloc_screen.dart';
import 'package:kyc/l10n/l10n.dart';
import 'package:kyc/widgets/error_snackbar.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({required this.loginCubit});

  final LoginCubit loginCubit;

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  late LoginCubit loginCubit;
  late AppLocalizations l10n;
  bool consentChecked = false;

  @override
  void initState() {
    super.initState();
    loginCubit = widget.loginCubit;
  }

  @override
  Widget build(BuildContext context) {
    l10n = context.l10n;

    return Builder(builder: (BuildContext context) {
      return Scaffold(
        body: BlocScreen<LoginCubit, LoginState>(
            listener: _signUpStateListener,
            bloc: loginCubit,
            builder: (context, state) {
              return SafeArea(
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(40, 32, 40, 0),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 400),
                        child: registrationForm(),
                      ),
                    ),
                  ),
                ),
              );
            }),
      );
    });
  }

  Widget registrationForm() {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Text(
            l10n.signUpHeadline,
            style: Theme.of(context).textTheme.headline6,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: TextFormField(
              controller: _firstNameController,
              key: const Key('firstName_input'),
              textInputAction: TextInputAction.next,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: FormValidator.formValidation,
              decoration: InputDecoration(
                labelText: l10n.firstName,
                hintText: l10n.firstNameHint,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: TextFormField(
              controller: _lastNameController,
              key: const Key('lastName_input'),
              textInputAction: TextInputAction.next,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: FormValidator.formValidation,
              decoration: InputDecoration(
                labelText: l10n.lastName,
                hintText: l10n.lastNameHint,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: TextFormField(
              controller: _emailController,
              key: const Key('email_input'),
              textInputAction: TextInputAction.next,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: FormValidator.emailAddressValidator,
              decoration: InputDecoration(
                labelText: l10n.email,
                hintText: l10n.emailHint,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: TextFormField(
              controller: _phoneController,
              key: const Key('phone_input'),
              textInputAction: TextInputAction.next,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: FormValidator.formValidation,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: l10n.phone,
                hintText: l10n.phoneHint,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: TextFormField(
              controller: _passwordController,
              key: const Key('password_input'),
              textInputAction: TextInputAction.next,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              obscureText: true,
              validator: FormValidator.formValidation,
              decoration: InputDecoration(
                labelText: l10n.password,
                hintText: l10n.passwordHint,
              ),
            ),
          ),
          Padding(
              padding: const EdgeInsets.only(top: 8),
              child: CheckboxListTile(
                title: RichText(
                  text: TextSpan(children: [
                    TextSpan(
                      text: '${l10n.signUpConsent1} ',
                      style: theme.textTheme.subtitle2,
                    ),
                    TextSpan(
                      text: l10n.signUpConsent2,
                      style: theme.textTheme.subtitle2!
                          .copyWith(decoration: TextDecoration.underline),
                    ),
                    TextSpan(
                      text: ' ${l10n.signUpConsent3} ',
                      style: theme.textTheme.subtitle2,
                    ),
                    TextSpan(
                      text: l10n.signUpConsent4,
                      style: theme.textTheme.subtitle2!
                          .copyWith(decoration: TextDecoration.underline),
                    ),
                  ]),
                ),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: const EdgeInsets.all(0),
                dense: true,
                value: consentChecked,
                onChanged: (bool? newValue) {
                  setState(() {
                    consentChecked = newValue ?? false;
                  });
                },
              )),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: ElevatedButton(
              onPressed: consentChecked ? _onSubmit : null,
              child: Text(l10n.signUp),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _onSubmit() async {
    ScaffoldMessenger.of(_formKey.currentContext!).removeCurrentSnackBar();
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    loginCubit.handleSignUpEvent(
      _emailController.text.trim(),
      _passwordController.text,
      _firstNameController.text.trim(),
      _lastNameController.text.trim(),
      _phoneController.text.trim(),
    );
  }

  void _handleRegisterSuccess() async {
    ScaffoldMessenger.of(_formKey.currentContext!).removeCurrentSnackBar();
    ScaffoldMessenger.of(_formKey.currentContext!).showSnackBar(
      SnackBar(content: Text(l10n.registrationSuccessful)),
    );
    final kycPi = await DependencyProvider.of(context).userRepo.getKycPi();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => KycPage(kycPi: kycPi)),
    );
  }

  void _signUpStateListener(context, LoginState state) {
    if (state is LoginErrorState) {
      ScaffoldMessenger.of(_formKey.currentContext!).removeCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(ErrorSnackBar(state.error));
    } else if (state is SignUpEventSuccessState) {
      _handleRegisterSuccess();
    }
  }
}
