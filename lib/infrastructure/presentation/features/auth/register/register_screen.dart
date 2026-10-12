import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:trip_planner/entities/entity_result.dart';
import 'package:trip_planner/infrastructure/presentation/app/components/button_component.dart';
import 'package:trip_planner/infrastructure/presentation/app/components/text_field_component.dart';
import 'package:trip_planner/infrastructure/presentation/app/components/trip_planner_logo_component.dart';
import 'package:trip_planner/infrastructure/presentation/app/intl/app_localizations.dart';
import 'package:trip_planner/infrastructure/presentation/features/auth/register/register_state.dart';
import 'package:trip_planner/infrastructure/presentation/routes.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RegisterState(),
      child: const _RegisterScreen(),
    );
  }
}

class _RegisterScreen extends StatelessWidget {
  const _RegisterScreen();

  @override
  Widget build(BuildContext context) {
    final intl = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final from = GoRouterState.of(context).uri.queryParameters['from'];
    final parameters = <String, String>{if (from != null) 'from': from};

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.colorScheme.primary),
          onPressed: () => context.go(
            Uri(path: AppRoutes.login, queryParameters: parameters).toString(),
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const TripPlannerLogoComponent(),
                Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.tertiary,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: Column(
                      children: [
                        Text(
                          intl.createAccount,
                          style: TextStyle(
                            fontSize: 20,
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w900,
                            fontFamily: "Times New Roman",
                          ),
                        ),
                        Text(
                          intl.signUpSubtitle,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Consumer<RegisterState>(
                          builder: (context, state, child) => Column(
                            children: [
                              AbsorbPointer(
                                absorbing: state.loading,
                                child: Column(
                                  children: [
                                    TextFieldComponent(
                                      controller: state.controllerName,
                                      label: intl.name,
                                    ),
                                    TextFieldComponent(
                                      controller: state.controllerEmail,
                                      label: intl.email,
                                    ),
                                    TextFieldComponent(
                                      controller: state.controllerPassword,
                                      label: intl.password,
                                      isPassword: true,
                                    ),
                                    ButtonComponent(
                                      function: () async {
                                        final result = await state
                                            .attemptRegister();
                                        if (!context.mounted) {
                                          return;
                                        }

                                        if (result case Success()) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                intl.registerSuccessful,
                                              ),
                                            ),
                                          );
                                          context.go(
                                            Uri(
                                              path: AppRoutes.login,
                                              queryParameters: parameters,
                                            ).toString(),
                                          );
                                        }
                                      },
                                      message: intl.signUp,
                                    ),
                                  ],
                                ),
                              ),
                              if (state.loading)
                                const LinearProgressIndicator(),
                              if (state.error case final error?)
                                Text(
                                  error.translate(intl),
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.error,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(child: Divider(color: Colors.grey[300])),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: Text(
                                intl.or,
                                style: TextStyle(
                                  color: Colors.grey[500],
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Expanded(child: Divider(color: Colors.grey[300])),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              intl.haveAccountQuestion,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => context.go(
                                Uri(
                                  path: AppRoutes.login,
                                  queryParameters: parameters,
                                ).toString(),
                              ),
                              child: Text(
                                intl.signInLink,
                                style: TextStyle(
                                  color: theme.colorScheme.secondary,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ],
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
    );
  }
}
