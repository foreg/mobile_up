import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_up/data/models/app_state.dart';
import 'package:mobile_up/generated/l10n.dart';
import 'package:provider/provider.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: _LoginScreen(),
      ),
    );
  }
}

class _LoginScreen extends StatelessWidget {
  const _LoginScreen({Key? key}) : super(key: key);

  void _onPressed(BuildContext context) async {
    final result = await Provider.of<AppState>(context, listen: false).login();
    if (result == AuthStatus.cancelled) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(S.of(context).signCancelled)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Spacer(),
          Text(
            S.of(context).appTitle,
            style: const TextStyle(fontSize: 48, fontWeight: FontWeight.w700),
          ),
          const Spacer(flex: 3),
          SizedBox(
            height: 56,
            width: double.infinity,
            child: ElevatedButton(
              child: Text(
                S.of(context).signIn,
                style: const TextStyle(fontSize: 18),
              ),
              onPressed: () => _onPressed(context),
            ),
          ),
        ],
      ),
    );
  }
}
