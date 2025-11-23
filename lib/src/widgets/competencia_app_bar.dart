import 'package:flutter/material.dart';
import 'package:aplicativo_01/src/services/auth_service.dart';

class CompetenciaAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String selectedRole;
  final Function(String) onRoleChanged;

  const CompetenciaAppBar({
    super.key,
    required this.selectedRole,
    required this.onRoleChanged,
  });

  @override
  Size get preferredSize => const Size.fromHeight(90);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      titleSpacing: 20,
      automaticallyImplyLeading: false,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedRole,
              items: const [
                DropdownMenuItem(value: 'CEO', child: Text('CEO')),
                DropdownMenuItem(value: 'Finanzas', child: Text('Finanzas')),
                DropdownMenuItem(
                  value: 'Director de Compras',
                  child: Text('Director de Compras'),
                ),
              ],
              onChanged: (v) {
                print('Dropdown changed to: $v');
                if (v != null) onRoleChanged(v);
              },
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Pallapizza Restaurante',
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: IconButton(
            icon: const Icon(Icons.logout, color: Colors.red),
            tooltip: 'Cerrar Sesión',
            onPressed: () async {
              // Mostrar diálogo de confirmación
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Cerrar Sesión'),
                  content: const Text('¿Estás seguro de que deseas salir?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancelar'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text(
                        'Salir',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              );

              if (confirm == true) {
                await AuthService.instance.logout();
                if (context.mounted) {
                  // Navegar a LoginPage eliminando el historial
                  Navigator.of(
                    context,
                  ).pushNamedAndRemoveUntil('/', (route) => false);
                }
              }
            },
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(right: 12.0),
          child: CircleAvatar(
            backgroundColor: Color(0xFFF0F0F0),
            child: Icon(Icons.person, color: Colors.grey),
          ),
        ),
      ],
    );
  }
}
