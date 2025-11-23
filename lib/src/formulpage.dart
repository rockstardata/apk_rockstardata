import 'package:flutter/material.dart';
// Importa la página de destino (Configuración Inteligente)
import 'package:aplicativo_01/src/configpage.dart';
import 'package:aplicativo_01/src/services/auth_service.dart';
import 'package:aplicativo_01/src/utils/validators.dart';
import 'package:aplicativo_01/src/utils/error_handler.dart'; 

class FormularioManualPage extends StatefulWidget {
  const FormularioManualPage({super.key});

  @override
  State<FormularioManualPage> createState() => _FormularioManualPageState();
}

class _FormularioManualPageState extends State<FormularioManualPage> {
  final _formKey = GlobalKey<FormState>();


  // --- FUNCIÓN PARA MOSTRAR EL DIÁLOGO DE TÉRMINOS Y CONDICIONES ---
  Future<dynamic> _showTermsAndConditionsDialog() async {
    // Diálogo seguro: tamaño máximo y scroll interno para evitar overflow.
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        final double maxHeight = MediaQuery.of(context).size.height * 0.7;
        return AlertDialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          content: SizedBox(
            width: double.maxFinite,
            height: maxHeight < 400 ? maxHeight : 400,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Cabecera
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Términos y Condiciones', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(dialogContext).pop(false),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // Contenido con pestañas y scroll
                Expanded(
                  child: DefaultTabController(
                    length: 2,
                    child: Column(
                      children: [
                        const TabBar(
                          indicatorSize: TabBarIndicatorSize.tab,
                          indicatorColor: Colors.deepPurple,
                          labelColor: Colors.deepPurple,
                          unselectedLabelColor: Colors.grey,
                          tabs: [Tab(text: 'Términos'), Tab(text: 'Privacidad')],
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                          child: TabBarView(
                            children: [
                              // Términos (scrollable)
                              SingleChildScrollView(
                                padding: const EdgeInsets.only(right: 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text('1. Aceptación de términos', style: TextStyle(fontWeight: FontWeight.bold)),
                                    SizedBox(height: 6),
                                    Text('Al usar RockstarData, aceptas estos términos y condiciones.'),
                                    SizedBox(height: 12),
                                    Text('2. Uso del servicio', style: TextStyle(fontWeight: FontWeight.bold)),
                                    SizedBox(height: 6),
                                    Text('RockstarData es una plataforma de análisis de datos para restaurantes y locales de hostelería.'),
                                    SizedBox(height: 12),
                                    Text('3. Protección de datos', style: TextStyle(fontWeight: FontWeight.bold)),
                                    SizedBox(height: 6),
                                    Text('Todos tus datos están encriptados y protegidos según la normativa GDPR.'),
                                    SizedBox(height: 12),
                                    Text('4. Responsabilidades', style: TextStyle(fontWeight: FontWeight.bold)),
                                    SizedBox(height: 6),
                                    Text('El usuario es responsable de la veracidad de los datos proporcionados.'),
                                    SizedBox(height: 12),
                                  ],
                                ),
                              ),

                              // Privacidad (simple placeholder)
                              Center(child: Text('Política de Privacidad', style: TextStyle(color: Colors.grey[700]))),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Botones de acción
                ElevatedButton(
                  onPressed: () => Navigator.of(dialogContext).pop(true),
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4B0082), minimumSize: const Size(double.infinity, 44)),
                  child: const Text('Acepto los términos', style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(height: 8),
                OutlinedButton(
                  onPressed: () => Navigator.of(dialogContext).pop(false),
                  style: OutlinedButton.styleFrom(side: const BorderSide(color: Color(0xFF4B0082)), minimumSize: const Size(double.infinity, 44)),
                  child: const Text('Cancelar', style: TextStyle(color: Color(0xFF4B0082))),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2C003E),
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        title: const Text('Registro Manual'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Text(
                  'Crea tu cuenta',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
                const SizedBox(height: 20),
                _buildTextField('Nombre', 'Tu nombre'),
                _buildTextField('Email', 'tu@email.com'),
                _buildTextField('Nombre del local', 'Mi restaurante'),
                _buildTextField('Teléfono (opcional)', '+34 123 456 789'),
                _buildTextField('Dirección (opcional)', 'Calle Principal, 123'),
                _buildTextField('Ciudad', 'Barcelona'),
                _buildTextField('País', 'España'),
                const SizedBox(height: 12),
                
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      // 1. Mostrar el diálogo de T&C y esperar el resultado
                      final accepted = await _showTermsAndConditionsDialog();

                      // 2. Si aceptó los términos
                      if (accepted == true) {
                        // 3. Registrar usuario
                        // Nota: En una implementación real, obtendrías los valores de los TextFormField
                        // usando controllers o accediendo a los campos del formulario
                        final success = await AuthService.instance.register(
                          name: 'Usuario', // En producción, obtener del formulario
                          email: 'usuario@email.com', // En producción, obtener del formulario
                          restaurantName: 'Mi Restaurante', // En producción, obtener del formulario
                          city: 'Barcelona',
                          country: 'España',
                        );

                        if (success) {
                          // 4. Mostrar la notificación de éxito
                          ErrorHandler.showSuccess(context, '¡Datos guardados con éxito!');

                          // 5. Navegar a la página de Configuración Inteligente después de un breve retraso
                          await Future.delayed(const Duration(milliseconds: 1500));
                          
                          if (context.mounted) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ConfiguracionInteligentePage(), 
                              ),
                            );
                          }
                        } else {
                          ErrorHandler.showError(context, 'Error al guardar los datos');
                        }
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    minimumSize: const Size(double.infinity, 48),
                  ),
                  child: const Text('Continuar', style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(height: 20),
                const Text('O CONTINÚA CON'),
                const SizedBox(height: 10),
                _buildSocialButton(Icons.apple, 'Continuar con Apple'),
                const SizedBox(height: 10),
                _buildSocialButton(Icons.g_mobiledata, 'Continuar con Google'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- MÉTODOS AUXILIARES ---
  
  Widget _buildTextField(String label, String hint) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        validator: (value) {
          if (label == 'Email') {
            return Validators.validateEmail(value);
          } else if (label == 'Nombre') {
            return Validators.validateName(value);
          } else if (label == 'Teléfono (opcional)') {
            return Validators.validatePhone(value);
          } else if (label != 'Dirección (opcional)' &&
              (value == null || value.isEmpty)) {
            return 'Este campo es obligatorio';
          }
          return null;
        },
        keyboardType: _getKeyboardType(label),
      ),
    );
  }

  TextInputType _getKeyboardType(String label) {
    if (label == 'Email') {
      return TextInputType.emailAddress;
    } else if (label == 'Teléfono (opcional)') {
      return TextInputType.phone;
    }
    return TextInputType.text;
  }

  Widget _buildSocialButton(IconData icon, String text) {
    return OutlinedButton.icon(
      onPressed: () {},
      icon: Icon(icon, color: Colors.deepPurple),
      label: Text(
        text,
        style: const TextStyle(color: Colors.deepPurple),
      ),
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(double.infinity, 48),
        side: const BorderSide(color: Colors.deepPurple),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}