import 'package:flutter/material.dart';
import 'package:turismo_app/core/data/datasources/firebase_user_datasource.dart';
import 'package:turismo_app/core/data/repositories/user_repository_impl.dart';
import 'package:turismo_app/core/domain/repositories/user_repository.dart';

class RegisterPage extends StatelessWidget {
  // final UserRepository repo = UserRepositoryImpl(FirebaseUserdataSource());

  final _formKey = GlobalKey<FormState>();

  String name = '';
  String surname = '';
  String email = '';
  String password = '';

  RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsetsGeometry.symmetric(vertical: 60, horizontal: 24),
        child: Column(
          children: [
            Expanded(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 20,
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Nombre'),
                      validator: (v) => v == null || v.isEmpty ? 'Requerido' : null,
                      onSaved: (v) => name = v ?? '',
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Apellido'),
                      validator: (v) => v == null || v.isEmpty ? 'Requerido' : null,
                      onSaved: (v) => surname = v ?? '',
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Email'),
                      validator: (v) => v == null || v.isEmpty ? 'Requerido' : null,
                      onSaved: (v) => email = v ?? '',
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Password'),
                      obscureText: true,
                      validator: (v) => v != null && v.length < 6 ? 'Mínimo 6' : null,
                      onSaved: (v) => password = v ?? '',
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Completa los campos.'),
                            duration: Duration(seconds: 2),
                            // backgroundColor: const Color.fromRGBO(100, 75, 0, 1),
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
