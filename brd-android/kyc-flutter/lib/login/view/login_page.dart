import 'package:flutter/material.dart';

import 'package:kyc/common/app_theme.dart';
import 'package:kyc/common/dependency_provider.dart';
import 'package:kyc/kyc/view/kyc_page.dart';
import 'package:kyc/l10n/l10n.dart';
import 'package:kyc/models/login_credentials.dart';
import 'package:kyc/signup/signup.dart';
import 'package:kyc/utils/form_validator.dart';
import 'package:kyc/widgets/bloc_screen.dart';
import 'package:kyc/widgets/error_snackbar.dart';

import '../login.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    Key? key,
    this.userEmail,
  }) : super(key: key);

  final String? userEmail;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (BuildContext context) {
      return Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.fromLTRB(40, 32, 40, 0),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: LoginForm(
                    userEmail: widget.userEmail,
                    onSuccess: _onLoginSuccess,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  void _onLoginSuccess(String sessionKey) async {
    final kycPi = await DependencyProvider.of(context).userRepo.getKycPi();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => KycPage(kycPi: kycPi),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({
    Key? key,
    this.userEmail,
    this.onSuccess,
  }) : super(key: key);

  final String? userEmail;
  final Function(String)? onSuccess;

  @override
  LoginFormState createState() {
    return LoginFormState();
  }
}

class LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final LoginCredentials _state = LoginCredentials();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late LoginCubit loginCubit;
  late AppLocalizations l10n;

  Future<void> _onSubmit() async {
    ScaffoldMessenger.of(_formKey.currentContext!).removeCurrentSnackBar();
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    loginCubit.handleAttemptLogin(_state);
  }

  @override
  void initState() {
    super.initState();
    if (widget.userEmail != null) _emailController.text = widget.userEmail!;
  }

  @override
  Widget build(BuildContext context) {
    l10n = context.l10n;
    return BlocScreen<LoginCubit, LoginState>(
        listener: _loginStateListener,
        bloc: loginCubit,
        builder: (context, state) {
          return Form(
              key: _formKey,
              child: Column(
                children: [
                  Text(
                    l10n.signInHeadline,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _emailController,
                    key: const Key('email_input'),
                    textInputAction: TextInputAction.next,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: FormValidator.emailAddressValidator,
                    onSaved: (val) => _state.email = val,
                    decoration: InputDecoration(
                      labelText: l10n.email,
                      hintText: l10n.signInEmailHint,
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(bottom: 12, top: 6),
                    child: const Text(
                      "Forgot password?",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  TextFormField(
                    controller: _passwordController,
                    key: const Key('password_input'),
                    textInputAction: TextInputAction.done,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    obscureText: true,
                    onSaved: (val) => _state.password = val,
                    validator: FormValidator.formValidation,
                    decoration: InputDecoration(
                      labelText: l10n.password,
                      hintText: l10n.signInPasswordHint,
                    ),
                  ),
                  Container(
                      margin: const EdgeInsets.symmetric(vertical: 16),
                      child: ElevatedButton(
                        onPressed: _onSubmit,
                        child: Text(l10n.signInButtonText),
                      )),
                  Container(
                    child: TextButton(
                      key: const Key('login_submit_btn'),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SignUpPage(
                              loginCubit: loginCubit,
                            ),
                          ),
                        );
                      },
                      child: RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: '${l10n.signInSignUpPrompt1} ',
                              style: const TextStyle(color: grey2),
                            ),
                            TextSpan(
                              text: l10n.signInSignUpPrompt2,
                              style: const TextStyle(
                                color: yellow,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ));
        });
  }

  void _loginStateListener(context, LoginState state) {
    if (state is LoginErrorState) {
      ScaffoldMessenger.of(_formKey.currentContext!).removeCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(ErrorSnackBar(state.error));
    } else if (state is LoginSuccessState) {
      if (widget.onSuccess != null) {
        widget.onSuccess!(state.sessionKey);
        print('sessionKey = ' + state.sessionKey);
      }
    }
  }

  @override
  void didChangeDependencies() {
    loginCubit =
        LoginCubit(authCubit: DependencyProvider.of(context).authCubit);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    loginCubit.close();
    super.dispose();
  }
}
