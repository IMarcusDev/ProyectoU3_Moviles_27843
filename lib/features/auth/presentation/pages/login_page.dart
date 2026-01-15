import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:turismo_app/core/data/datasources/firebase_user_datasource.dart';
import 'package:turismo_app/core/data/repositories/user_repository_impl.dart';
import 'package:turismo_app/core/domain/repositories/user_repository.dart';

class LoginPage extends StatelessWidget {
  // final UserRepository repo = UserRepositoryImpl(FirebaseUserdataSource());

  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsetsGeometry.symmetric(vertical: 60, horizontal: 24),
        child: Column(
          children: [
            Column(
              spacing: 16,
              children: [
                CircleAvatar(
                  radius: 75,
                ),
                Text('App Turismo', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),)
              ],
            ),

            Expanded(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 20,
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Email'),
                      validator: (v) => v == null || v.isEmpty ? 'Requerido' : null,
                      onSaved: (v) => email = v ?? '',
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Contraseña'),
                      obscureText: true,
                      validator: (v) => v != null && v.length < 6 ? 'Mínimo 6' : null,
                      onSaved: (v) => password = v ?? '',
                    ),

                    // To Register
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('¿No tienes un usuario? '),
                        InkWell(
                          onTap: () => context.push('/register'),
                          child: const Text(
                            '¡Regístrate aquí!',
                            style: TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),

                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();

                          print(email);
                          print(password);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Credenciales incorrectas. Revisa los campos nuevamente.'),
                            duration: Duration(seconds: 2),
                          ));
                        }
                      },
                      child: const Text('Login'),
                    ),
                  ],
                )
              ),
            ),
          ],
        ),
      ),
    );
  }
}
