import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Perfil', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
              child: Row(
                children: [
                  const CircleAvatar(radius: 36, backgroundColor: Color(0xFF8A2BE2), child: Text('JG', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Javier García', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 6),
                      Text('Administrador - El Buen Sabor', style: TextStyle(color: Colors.grey)),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  ListTile(leading: const Icon(Icons.settings), title: const Text('Ajustes de la cuenta'), trailing: Icon(Icons.chevron_right, color: Colors.grey[400])),
                  const Divider(height: 1),
                  ListTile(leading: const Icon(Icons.lock), title: const Text('Privacidad'), trailing: Icon(Icons.chevron_right, color: Colors.grey[400])),
                  const Divider(height: 1),
                  ListTile(leading: const Icon(Icons.logout), title: const Text('Cerrar sesión'), trailing: Icon(Icons.chevron_right, color: Colors.grey[400])),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
