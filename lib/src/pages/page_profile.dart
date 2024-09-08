import 'package:cengodelivery/src/interfaces/Status.dart';
import 'package:cengodelivery/src/pages/page_login.dart';
import 'package:cengodelivery/src/providers/status_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PageProfile extends StatelessWidget {
  const PageProfile({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(15), // Reduce el radio de las esquinas
      ),
      content: IntrinsicHeight(
        child: Container(
          width: MediaQuery.of(context).size.width - 10,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(height: 10),
              CircleAvatar(
                radius: 25,
                backgroundImage: AssetImage('assets/images/profile.png'),
              ),
              SizedBox(height: 10),
              Text(
                'Levi Anderson Albarran Luengo',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Picker',
                  style: TextStyle(
                    color: Colors.blue[800],
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ),
              SizedBox(height: 30),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Datos de contacto',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 10),
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      color: Colors.blue[100],
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Icon(
                      Icons.phone_outlined,
                      size: 18,
                      color: colorScheme.primary,
                    ),
                  ),
                  SizedBox(width: 5),
                  Text('+56 9 6350 0819'),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 10),
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      color: Colors.blue[100],
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Icon(
                      Icons.email_outlined,
                      size: 18,
                      color: colorScheme.primary,
                    ),
                  ),
                  SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      'levi.albarran@cencosud.cl',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: double.infinity,
                ),
                child: TextButton.icon(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.grey[100],
                    backgroundColor: colorScheme.primary,
                    side: BorderSide(color: colorScheme.primary, width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  ),
                  onPressed: () {
                    Provider.of<StatusProvider>(context, listen: false)
                        .setStatus(StatusType.start);
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => PageLogin()),
                    );
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text('Cerrar Sesión'),
                ),
              ),
              SizedBox(height: 10),
              ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: double.infinity,
                ),
                child: TextButton.icon(
                  style: TextButton.styleFrom(
                    foregroundColor: colorScheme.primary,
                    backgroundColor: colorScheme.surface,
                    side: BorderSide(color: colorScheme.primary, width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.close),
                  label: const Text('Cerrar'),
                ),
              ),
            ],
          ),
        ),
      ),
      contentPadding: EdgeInsets.all(16),
    );
  }
}
