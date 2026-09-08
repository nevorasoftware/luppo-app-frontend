import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import '../core/api_client.dart';
import '../models/models.dart';

class LoginView extends StatefulWidget {
  final Function(AuthResponse) onLoginSuccess;

  const LoginView({Key? key, required this.onLoginSuccess}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(text: 'vendedor@luppo.app');
  final _passwordController = TextEditingController(text: 'Password123!');
  bool _obscurePassword = true;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final authResponse = await ApiClient.login(
        _emailController.text.trim(),
        _passwordController.text,
      );
      if (mounted) {
        widget.onLoginSuccess(authResponse);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString().replaceAll('Exception: ', '');
          _isLoading = false;
        });
      }
    }
  }

  void _fillDemoAccount(String email, String password) {
    setState(() {
      _emailController.text = email;
      _passwordController.text = password;
      _errorMessage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1B2D),
      body: Stack(
        children: [
          // 1. Círculo de profundidad y acento decorativo (inspirado en la referencia de diseño)
          Positioned(
            top: -60,
            right: -60,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.secondaryBlue.withOpacity(0.35),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 80,
                    right: 90,
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.tealAccent,
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x6619A7A0),
                            blurRadius: 16,
                            offset: Offset(0, 4),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 2. Fondo ambiental suave inferior
          Positioned(
            bottom: -100,
            left: -80,
            child: Container(
              width: 320,
              height: 320,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withOpacity(0.5),
              ),
            ),
          ),

          // 3. Contenedor principal de Login
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 440),
                padding: const EdgeInsets.all(36.0),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.secondaryBlue, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      blurRadius: 36,
                      offset: const Offset(0, 16),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Ícono de onda de pulso comercial (estilo exacto de la referencia)
                      Center(
                        child: SizedBox(
                          width: 80,
                          height: 48,
                          child: CustomPaint(
                            painter: LuppoPulsePainter(
                              color: AppColors.tealAccent,
                              strokeWidth: 4.0,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Título de marca (idéntico a la referencia: tipografía blanca, negrita y espaciada)
                      const Text(
                        'LUPPO',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          color: AppColors.white,
                          letterSpacing: 3.0,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Plataforma Inteligente de Gestión Comercial',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF94A3B8),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 32),

                      if (_errorMessage != null) ...[
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF450A0A),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: const Color(0xFFDC2626)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.error_outline, color: Color(0xFFFCA5A5), size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _errorMessage!,
                                  style: const TextStyle(color: Color(0xFFFECACA), fontSize: 13),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],

                      // Campo Correo Electrónico
                      const Text(
                        'Correo Electrónico',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          color: AppColors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        style: const TextStyle(color: AppColors.white, fontSize: 14),
                        decoration: InputDecoration(
                          fillColor: const Color(0xFF0C1F33),
                          filled: true,
                          prefixIcon: const Icon(Icons.email_outlined, color: AppColors.tealAccent, size: 20),
                          hintText: 'ej. vendedor@luppo.app',
                          hintStyle: const TextStyle(color: Color(0xFF64748B), fontSize: 14),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: AppColors.secondaryBlue),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: AppColors.tealAccent, width: 1.5),
                          ),
                        ),
                        validator: (v) => (v == null || !v.contains('@')) ? 'Ingrese un correo válido' : null,
                      ),
                      const SizedBox(height: 18),

                      // Campo Contraseña
                      const Text(
                        'Contraseña',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          color: AppColors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        style: const TextStyle(color: AppColors.white, fontSize: 14),
                        decoration: InputDecoration(
                          fillColor: const Color(0xFF0C1F33),
                          filled: true,
                          prefixIcon: const Icon(Icons.lock_outline, color: AppColors.tealAccent, size: 20),
                          hintText: '••••••••',
                          hintStyle: const TextStyle(color: Color(0xFF64748B), fontSize: 14),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: AppColors.secondaryBlue),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: AppColors.tealAccent, width: 1.5),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword ? Icons.visibility_off : Icons.visibility,
                              color: const Color(0xFF94A3B8),
                              size: 20,
                            ),
                            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                          ),
                        ),
                        validator: (v) => (v == null || v.isEmpty) ? 'Ingrese su contraseña' : null,
                      ),
                      const SizedBox(height: 26),

                      // Botón Principal de Inicio de Sesión
                      SizedBox(
                        height: 48,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _handleLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.tealAccent,
                            foregroundColor: AppColors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            elevation: 4,
                            shadowColor: AppColors.tealAccent.withOpacity(0.4),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.white),
                                )
                              : const Text(
                                  'Iniciar Sesión',
                                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, letterSpacing: 0.5),
                                ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      const Divider(color: AppColors.secondaryBlue),
                      const SizedBox(height: 16),

                      const Text(
                        'Acceso Rápido Demo:',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF94A3B8),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Botones de Acceso Rápido
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () => _fillDemoAccount('vendedor@luppo.app', 'Password123!'),
                              icon: const Icon(Icons.person, size: 16, color: AppColors.tealAccent),
                              label: const Text(
                                'Vendedor',
                                style: TextStyle(fontSize: 12, color: AppColors.white, fontWeight: FontWeight.w600),
                              ),
                              style: OutlinedButton.styleFrom(
                                backgroundColor: const Color(0xFF0C1F33),
                                side: const BorderSide(color: AppColors.secondaryBlue),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () => _fillDemoAccount('admin@luppo.app', 'Password123!'),
                              icon: const Icon(Icons.admin_panel_settings, size: 16, color: AppColors.tealAccent),
                              label: const Text(
                                'Admin',
                                style: TextStyle(fontSize: 12, color: AppColors.white, fontWeight: FontWeight.w600),
                              ),
                              style: OutlinedButton.styleFrom(
                                backgroundColor: const Color(0xFF0C1F33),
                                side: const BorderSide(color: AppColors.secondaryBlue),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Pintor de onda de pulso comercial (estilo exacto del gráfico de la referencia)
class LuppoPulsePainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  const LuppoPulsePainter({
    required this.color,
    this.strokeWidth = 3.5,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    final w = size.width;
    final h = size.height;

    // Línea base izquierda
    path.moveTo(0, h * 0.60);
    path.lineTo(w * 0.20, h * 0.60);
    // Subida y bajada previa
    path.lineTo(w * 0.35, h * 0.35);
    path.lineTo(w * 0.50, h * 0.95);
    // Pico alto
    path.lineTo(w * 0.65, h * 0.05);
    // Valle de retorno
    path.lineTo(w * 0.78, h * 0.70);
    // Línea base derecha
    path.lineTo(w * 0.88, h * 0.60);
    path.lineTo(w, h * 0.60);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
