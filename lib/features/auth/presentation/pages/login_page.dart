import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:turismo_app/core/data/datasources/firebase_user_datasource.dart';
import 'package:turismo_app/core/data/repositories/user_repository_impl.dart';
import 'package:turismo_app/core/domain/entities/user.dart';
import 'package:turismo_app/core/domain/repositories/user_repository.dart';
import 'package:turismo_app/core/utils/theme/theme_colors.dart';


// ignore: must_be_immutable
class LoginPage extends StatelessWidget {
  final UserRepository repo = UserRepositoryImpl(FirebaseUserdataSource());

  LoginPage({super.key});

  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.bgColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              // Logo
              Expanded(
                flex: 3,
                child: Column(
                  spacing: 12,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: const [
                    CircleAvatar(
                      radius: 48,
                      backgroundColor: Color(0xFFE8F5E9),
                      child: Icon(
                        Icons.travel_explore,
                        size: 40,
                        color: ThemeColors.primaryGreen,
                      ),
                    ),
                    Text(
                      'App Turismo',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: ThemeColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 32,),

              // Credentials
              Expanded(
                flex: 5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Form(
                      key: _formKey,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: ThemeColors.cardColor,
                          borderRadius: BorderRadius.circular(28),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          spacing: 16,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Email',
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(16)),
                                ),
                              ),
                              validator: (v) =>
                                  v == null || v.isEmpty ? 'Requerido' : null,
                              onSaved: (v) => email = v ?? '',
                            ),

                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Contraseña',
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(16)),
                                ),
                              ),
                              obscureText: true,
                              validator: (v) =>
                                  v != null && v.length < 6 ? 'Mínimo 6' : null,
                              onSaved: (v) => password = v ?? '',
                            ),

                            // Link registro
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  '¿No tienes un usuario? ',
                                  style: TextStyle(color: ThemeColors.textSecondary),
                                ),
                                InkWell(
                                  onTap: () => context.push('/register'),
                                  child: const Text(
                                    'Regístrate aquí',
                                    style: TextStyle(
                                      color: ThemeColors.primaryGreen,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            // Botón login
                            SizedBox(
                              width: double.infinity,
                              // height: 52,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: ThemeColors.primaryGreen,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  elevation: 0,
                                ),
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    _formKey.currentState!.save();

                                    User? user = await repo.loginUser(email, password);

                                    if (user != null) {
                                      context.pushReplacement('/menu');
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Credenciales incorrectas.',
                                          ),
                                          duration: Duration(seconds: 2),
                                        ),
                                      );
                                    }
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Completa los campos nuevamente.',
                                        ),
                                        duration: Duration(seconds: 2),
                                      ),
                                    );
                                  }
                                },
                                child: const Text(
                                  'Iniciar sesión',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}
