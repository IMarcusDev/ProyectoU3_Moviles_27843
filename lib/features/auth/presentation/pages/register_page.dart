import 'package:flutter/material.dart';

// ignore: must_be_immutable
class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});

  final _formKey = GlobalKey<FormState>();

  String name = '';
  String surname = '';
  String email = '';
  String password = '';

  // Paleta estilo turismo (misma que Login)
  static const _bgColor = Color(0xFFF5F6F2);
  static const _cardColor = Colors.white;
  static const _primaryGreen = Color(0xFF2E7D32);
  static const _textPrimary = Color(0xFF1C1C1C);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: _bgColor,),  // Return to Login Button
      backgroundColor: _bgColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              // Logo / Header
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
                        Icons.person_add_alt_1,
                        size: 40,
                        color: _primaryGreen,
                      ),
                    ),
                    Text(
                      'Crear cuenta',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: _textPrimary,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 32,),

              // Formulario
              Expanded(
                flex: 6,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Form(
                      key: _formKey,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: _cardColor,
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
                                labelText: 'Nombre',
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(16)),
                                ),
                              ),
                              validator: (v) =>
                                  v == null || v.isEmpty ? 'Requerido' : null,
                              onSaved: (v) => name = v ?? '',
                            ),

                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Apellido',
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(16)),
                                ),
                              ),
                              validator: (v) =>
                                  v == null || v.isEmpty ? 'Requerido' : null,
                              onSaved: (v) => surname = v ?? '',
                            ),

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
                                  v != null && v.length < 6
                                      ? 'Mínimo 6 caracteres'
                                      : null,
                              onSaved: (v) => password = v ?? '',
                            ),

                            // Botón registrar
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _primaryGreen,
                                  minimumSize:
                                      const Size.fromHeight(52),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  elevation: 0,
                                ),
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    _formKey.currentState!.save();

                                    // lógica de registro aquí
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content:
                                            Text('Completa los campos.'),
                                        duration: Duration(seconds: 2),
                                      ),
                                    );
                                  }
                                },
                                child: const Text(
                                  'Crear cuenta',
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
