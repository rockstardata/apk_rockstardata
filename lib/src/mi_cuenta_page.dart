import 'package:flutter/material.dart';
import 'configpage.dart';
import 'package:aplicativo_01/src/pages/profile_page.dart';
import 'package:aplicativo_01/src/services/auth_service.dart';
import 'package:aplicativo_01/src/home.dart';
import 'package:aplicativo_01/src/utils/error_handler.dart'; 

class MiCuentaPage extends StatelessWidget {
  const MiCuentaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Mi cuenta',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Text(
              'Restaurante Principal',
              style: TextStyle(color: Color(0xFF4B0082), fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Tarjeta de Perfil
            _buildProfileCard(),
            const SizedBox(height: 25),

            // Opciones de Menú
            _buildMenuItem(context, Icons.person_outline, 'Perfil', () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ProfilePage(),
                ),
              );
            }),
            _buildMenuItem(context, Icons.business_center_outlined, 'Configuración del negocio', () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ConfiguracionInteligentePage(),
                ),
              );
            }),
            _buildMenuItem(context, Icons.cloud_upload_outlined, 'Fuentes conectadas', () {
              _showComingSoon(context);
            }),
            _buildMenuItem(context, Icons.receipt_long, 'Plan y facturación', () {
              _showComingSoon(context);
            }),
            _buildMenuItem(context, Icons.notifications_active_outlined, 'Notificaciones push', () {
              _showComingSoon(context);
            }),
            
            // Separador
            const Divider(height: 30, thickness: 1, color: Color(0xFFE0E0E0)),

            // Cerrar Sesión
            _buildLogoutItem(context),
          ],
        ),
      ),
    );
  }

  // Widget para la tarjeta de perfil
  Widget _buildProfileCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 24, // Aumentado un poco el tamaño
            backgroundColor: Color(0xFF4B0082),
            child: Icon(Icons.person, color: Colors.white, size: 28), // Aumentado el tamaño del icono
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Javier García',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.black87),
              ),
              Text(
                'javier.garcia@restaurante.com',
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Widget para un elemento de menú reutilizable
  Widget _buildMenuItem(
      BuildContext context, IconData icon, String title, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF4B0082), size: 24), // Icono con color principal
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  // Widget para la opción de cerrar sesión
  Widget _buildLogoutItem(BuildContext context) {
    return InkWell(
      onTap: () => _showLogoutDialog(context),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Row(
          children: const [
            Icon(Icons.logout, color: Colors.red, size: 24),
            SizedBox(width: 15),
            Expanded(
              child: Text(
                'Cerrar sesión',
                style: TextStyle(fontSize: 16, color: Colors.red, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Esta funcionalidad estará disponible pronto'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _showLogoutDialog(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cerrar sesión'),
          content: const Text('¿Estás seguro de que deseas cerrar sesión?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Cerrar sesión'),
            ),
          ],
        );
      },
    );

    if (confirmed == true && context.mounted) {
      await AuthService.instance.logout();
      ErrorHandler.showSuccess(context, 'Sesión cerrada correctamente');
      
      // Navegar a la página de login
      if (context.mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginPage()),
          (route) => false,
        );
      }
    }
  }
}