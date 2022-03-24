import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kyc/kyc/view/kyc_page.dart';
import 'package:kyc/login/login.dart';
import 'package:kyc/utils/form_validator.dart';
import 'package:kyc/widgets/bloc_screen.dart';
import 'package:kyc/l10n/l10n.dart';
import 'package:kyc/widgets/error_snackbar.dart';

class SignUpConfirmPage extends StatefulWidget {
  SignUpConfirmPage({required this.loginCubit});

  final LoginCubit loginCubit;

  @override
  _SignUpConfirmPageState createState() => _SignUpConfirmPageState();
}

class _SignUpConfirmPageState extends State<SignUpConfirmPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _codeController = TextEditingController();
  late LoginCubit loginCubit;
  late AppLocalizations l10n;

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
              controller: _codeController,
              key: const Key('code_input'),
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
            padding: const EdgeInsets.only(top: 8),
            child: ElevatedButton(
              onPressed: _onSubmit,
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
    loginCubit.handleSignUpConfirmEvent(
      _codeController.text.trim(),
    );
  }

  void _handleRegisterSuccess() async {
    ScaffoldMessenger.of(_formKey.currentContext!).removeCurrentSnackBar();
    ScaffoldMessenger.of(_formKey.currentContext!).showSnackBar(
      SnackBar(content: Text(l10n.registrationSuccessful)),
    );

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const KycPage()),
    );
  }

  void _signUpStateListener(context, LoginState state) {
    if (state is LoginErrorState) {
      ScaffoldMessenger.of(_formKey.currentContext!).removeCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(ErrorSnackBar(state.error));
    } else if (state is SignUpConfirmEventSuccessState) {
      _handleRegisterSuccess();
    }
  }
}
