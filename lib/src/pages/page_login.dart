import 'package:cengodelivery/src/pages/page_map.dart';
import 'package:flutter/material.dart';

class PageLogin extends StatefulWidget {
  @override
  _PageLoginState createState() => _PageLoginState();
}

class _PageLoginState extends State<PageLogin> {
  bool _isEmailValid = false;
  bool _isPasswordValid = false;
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _emailFocusNode.addListener(() {
      setState(() {});
    });
    _passwordFocusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _login(BuildContext context) {
    // Aquí puedes agregar la lógica de validación de inicio de sesión
    // Por ahora, simplemente navegaremos a la pantalla de inicio
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => PageMap()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(height: 50),
                Image.asset('assets/images/logo.png', width: 250, height: 120),
                SizedBox(height: 10),
                Text(
                  '¡Estás de vuelta!',
                  style: TextStyle(
                    fontSize: 24,
                    color: colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Text(
                  'Ingresa tus datos para acceder a tu cuenta.',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24),
                TextField(
                  focusNode: _emailFocusNode,
                  onChanged: (value) {
                    setState(() {
                      _isEmailValid = value.contains('@');
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Correo electrónico',
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                    alignLabelWithHint: true,
                    suffixIcon: _isEmailValid
                        ? Icon(Icons.check_circle, color: Colors.green)
                        : null,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey, width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.blue, width: 2),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: _isEmailValid ? Colors.green : Colors.grey,
                        width: 2,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 25),
                TextField(
                  focusNode: _passwordFocusNode,
                  obscureText: true,
                  onChanged: (value) {
                    setState(() {
                      _isPasswordValid = value.length >= 6;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Ingresa tu contraseña',
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                    alignLabelWithHint: true,
                    suffixIcon: _isPasswordValid
                        ? Icon(Icons.check_circle, color: Colors.green)
                        : null,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey, width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.blue, width: 2),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: _isPasswordValid ? Colors.green : Colors.grey,
                        width: 2,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 24),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2),
                  child: TextButton.icon(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.grey[100],
                      backgroundColor: colorScheme.primary,
                      side: BorderSide(
                          color: colorScheme.primary,
                          width: 2), // Añade un borde
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            10), // Ajusta el radio de las esquinas
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16), // Ajusta el padding si es necesario
                    ),
                    onPressed: () => _login(context),
                    label: const Text('Ingresar'),
                  ),
                ),
                SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
