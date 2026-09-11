import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../config/app_colors.dart';
import '../components/ui_components.dart';

class ContactView extends StatelessWidget {
  const ContactView({Key? key}) : super(key: key);

  static final List<_SocialNetwork> _socialNetworks = [
    _SocialNetwork(
      name: 'Instagram',
      handle: '@luppo.app',
      tag: 'Historias & Novedades',
      description: 'Descubre tips diarios de ventas, lanzamientos y el detrás de escena de la plataforma.',
      url: 'https://www.instagram.com/luppo.app?stkn=OHR0dWxsZm1nNnh4',
      gradient: const LinearGradient(
        colors: [Color(0xFF833AB4), Color(0xFFFD1D1D), Color(0xFFFCAF45)],
        begin: Alignment.bottomLeft,
        end: Alignment.topRight,
      ),
      accentColor: const Color(0xFFE1306C),
      buttonText: 'Seguir en Instagram',
      iconType: _SocialIconType.instagram,
    ),
    _SocialNetwork(
      name: 'LinkedIn',
      handle: 'Luppo App',
      tag: 'B2B & Networking',
      description: 'Artículos de estrategia comercial, cultura de ventas y networking con líderes de la industria.',
      url: 'https://www.linkedin.com/in/luppoapp?utm_source=share_via&utm_content=profile&utm_medium=member_ios',
      gradient: const LinearGradient(
        colors: [Color(0xFF0077B5), Color(0xFF0A66C2)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      accentColor: const Color(0xFF0A66C2),
      buttonText: 'Conectar en LinkedIn',
      iconType: _SocialIconType.linkedin,
    ),
    _SocialNetwork(
      name: 'TikTok',
      handle: '@luppo.app',
      tag: 'Estrategias Rápidas',
      description: 'Píldoras de conocimiento, hacks de prospección y metodologías de ventas en videos cortos.',
      url: 'https://www.tiktok.com/@luppo.app?_r=1&_t=ZS-99ZsabJ42ho',
      gradient: const LinearGradient(
        colors: [Color(0xFF111111), Color(0xFF222222)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      accentColor: const Color(0xFF00F2FE),
      buttonText: 'Ver en TikTok',
      iconType: _SocialIconType.tiktok,
    ),
    _SocialNetwork(
      name: 'YouTube',
      handle: '@luppo-app',
      tag: 'Webinars & Tutoriales',
      description: 'Masterclasses completas, guías prácticas de la plataforma y entrenamientos comerciales.',
      url: 'https://youtube.com/@luppo-app?si=1yjNITdb63SJIJol',
      gradient: const LinearGradient(
        colors: [Color(0xFFCC0000), Color(0xFFFF0000)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      accentColor: const Color(0xFFFF0000),
      buttonText: 'Suscribirse en YouTube',
      iconType: _SocialIconType.youtube,
    ),
    _SocialNetwork(
      name: 'Facebook',
      handle: 'Luppo App',
      tag: 'Comunidad Oficial',
      description: 'Noticias oficiales, eventos en vivo y espacio de retroalimentación para nuestra comunidad.',
      url: 'https://www.facebook.com/share/1Li5NhcZaz/?mibextid=wwXIfr',
      gradient: const LinearGradient(
        colors: [Color(0xFF1877F2), Color(0xFF0D65D9)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      accentColor: const Color(0xFF1877F2),
      buttonText: 'Seguir en Facebook',
      iconType: _SocialIconType.facebook,
    ),
  ];

  Future<void> _openLink(BuildContext context, String url, String name) async {
    try {
      final uri = Uri.parse(url);
      final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!launched) {
        await launchUrl(uri);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Abriendo $name en el navegador...'),
            backgroundColor: AppColors.primary,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 700;
        final isWide = constraints.maxWidth >= 900;

        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.all(isMobile ? 16 : 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Bar Header
              LuppoTopBar(
                title: 'Contáctanos',
                subtitle: 'Canales oficiales y comunidad digital de Luppo',
              ),
              const SizedBox(height: 20),

              // Hero Banner
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(isMobile ? 20 : 28),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, Color(0xFF132A45)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.secondaryBlue),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.15),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.tealAccent.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: AppColors.tealAccent.withOpacity(0.4)),
                            ),
                            child: const Text(
                              'COMUNIDAD LUPPO',
                              style: TextStyle(
                                color: AppColors.tealAccent,
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Conéctate con nosotros en redes sociales',
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: isMobile ? 20 : 26,
                              fontWeight: FontWeight.bold,
                              letterSpacing: -0.3,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Síguenos en nuestras plataformas oficiales para estar al día con las mejores tácticas de prospección, forecast comercial y lanzamientos de nuevas herramientas.',
                            style: TextStyle(
                              color: const Color(0xFFCBD5E1),
                              fontSize: isMobile ? 13 : 14,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (!isMobile) ...[
                      const SizedBox(width: 24),
                      Container(
                        width: 76,
                        height: 76,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.secondaryBlue.withOpacity(0.5),
                          border: Border.all(color: AppColors.tealAccent.withOpacity(0.3), width: 1.5),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.hub_outlined,
                            color: AppColors.tealAccent,
                            size: 38,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Section Title
              const Text(
                'REDES SOCIALES OFICIALES',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textSecondary,
                  letterSpacing: 1.1,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Nuestros Canales Digitales',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 16),

              // Social Networks List / Grid
              if (isWide)
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 2.2,
                  ),
                  itemCount: _socialNetworks.length,
                  itemBuilder: (context, index) {
                    return _SocialCard(
                      network: _socialNetworks[index],
                      onTap: () => _openLink(context, _socialNetworks[index].url, _socialNetworks[index].name),
                    );
                  },
                )
              else
                Column(
                  children: _socialNetworks
                      .map(
                        (network) => Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: _SocialCard(
                            network: network,
                            onTap: () => _openLink(context, network.url, network.name),
                          ),
                        ),
                      )
                      .toList(),
                ),

              const SizedBox(height: 16),

              // Direct Help / Support Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.divider),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.accent.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.support_agent_outlined, color: AppColors.accent, size: 26),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            '¿Tienes dudas o requieres asistencia directa?',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.primary),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Visita nuestras redes o contáctanos a través de nuestros canales oficiales para soporte comercial.',
                            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}

enum _SocialIconType { instagram, linkedin, tiktok, youtube, facebook }

class _SocialNetwork {
  final String name;
  final String handle;
  final String tag;
  final String description;
  final String url;
  final LinearGradient gradient;
  final Color accentColor;
  final String buttonText;
  final _SocialIconType iconType;

  const _SocialNetwork({
    required this.name,
    required this.handle,
    required this.tag,
    required this.description,
    required this.url,
    required this.gradient,
    required this.accentColor,
    required this.buttonText,
    required this.iconType,
  });
}

class _SocialCard extends StatelessWidget {
  final _SocialNetwork network;
  final VoidCallback onTap;

  const _SocialCard({
    Key? key,
    required this.network,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.divider),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Vanguardist Branded Icon Container
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: network.gradient,
                    borderRadius: BorderRadius.circular(13),
                    boxShadow: [
                      BoxShadow(
                        color: network.accentColor.withOpacity(0.25),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: SizedBox(
                      width: 28,
                      height: 28,
                      child: _buildIcon(network.iconType),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            network.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: network.accentColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              network.tag,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: network.accentColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        network.handle,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: network.accentColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              network.description,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.divider),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    network.buttonText,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Icon(Icons.arrow_forward, size: 14, color: AppColors.primary),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon(_SocialIconType type) {
    switch (type) {
      case _SocialIconType.instagram:
        return CustomPaint(painter: _InstagramPainter());
      case _SocialIconType.linkedin:
        return CustomPaint(painter: _LinkedInPainter());
      case _SocialIconType.tiktok:
        return CustomPaint(painter: _TikTokPainter());
      case _SocialIconType.youtube:
        return CustomPaint(painter: _YouTubePainter());
      case _SocialIconType.facebook:
        return CustomPaint(painter: _FacebookPainter());
    }
  }
}

// Custom Vanguardist Vector Painters
class _InstagramPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final strokePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.10
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(size.width * 0.08, size.height * 0.08, size.width * 0.84, size.height * 0.84),
      Radius.circular(size.width * 0.26),
    );
    canvas.drawRRect(rect, strokePaint);
    canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.5), size.width * 0.22, strokePaint);
    canvas.drawCircle(Offset(size.width * 0.72, size.height * 0.28), size.width * 0.05, fillPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _LinkedInPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final w = size.width;
    final h = size.height;

    // 'i' dot
    canvas.drawCircle(Offset(w * 0.24, h * 0.24), w * 0.08, paint);
    // 'i' stem
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.16, h * 0.38, w * 0.16, h * 0.48), const Radius.circular(2)),
      paint,
    );

    // 'n' stem
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.42, h * 0.38, w * 0.15, h * 0.48), const Radius.circular(2)),
      paint,
    );

    // 'n' arch
    final path = Path();
    path.moveTo(w * 0.57, h * 0.48);
    path.cubicTo(w * 0.59, h * 0.40, w * 0.66, h * 0.36, w * 0.75, h * 0.36);
    path.cubicTo(w * 0.84, h * 0.36, w * 0.89, h * 0.42, w * 0.89, h * 0.54);
    path.lineTo(w * 0.89, h * 0.86);
    path.lineTo(w * 0.74, h * 0.86);
    path.lineTo(w * 0.74, h * 0.57);
    path.cubicTo(w * 0.74, h * 0.50, w * 0.70, h * 0.46, w * 0.65, h * 0.46);
    path.cubicTo(w * 0.60, h * 0.46, w * 0.57, h * 0.50, w * 0.57, h * 0.58);
    path.lineTo(w * 0.57, h * 0.86);
    path.lineTo(w * 0.42, h * 0.86);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _TikTokPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    void drawGlyph(Color color, double dx, double dy) {
      final paint = Paint()
        ..color = color
        ..style = PaintingStyle.fill;

      final path = Path();
      path.moveTo(w * 0.50 + dx, h * 0.65 + dy);
      path.cubicTo(w * 0.50 + dx, h * 0.75 + dy, w * 0.41 + dx, h * 0.83 + dy, w * 0.31 + dx, h * 0.83 + dy);
      path.cubicTo(w * 0.20 + dx, h * 0.83 + dy, w * 0.12 + dx, h * 0.74 + dy, w * 0.12 + dx, h * 0.64 + dy);
      path.cubicTo(w * 0.12 + dx, h * 0.53 + dy, w * 0.21 + dx, h * 0.45 + dy, w * 0.32 + dx, h * 0.45 + dy);
      path.lineTo(w * 0.32 + dx, h * 0.56 + dy);
      path.cubicTo(w * 0.26 + dx, h * 0.56 + dy, w * 0.23 + dx, h * 0.59 + dy, w * 0.23 + dx, h * 0.64 + dy);
      path.cubicTo(w * 0.23 + dx, h * 0.68 + dy, w * 0.26 + dx, h * 0.72 + dy, w * 0.31 + dx, h * 0.72 + dy);
      path.cubicTo(w * 0.36 + dx, h * 0.72 + dy, w * 0.40 + dx, h * 0.68 + dy, w * 0.40 + dx, h * 0.63 + dy);
      path.lineTo(w * 0.40 + dx, h * 0.12 + dy);
      path.lineTo(w * 0.52 + dx, h * 0.12 + dy);
      path.cubicTo(w * 0.52 + dx, h * 0.25 + dy, w * 0.61 + dx, h * 0.34 + dy, w * 0.74 + dx, h * 0.35 + dy);
      path.lineTo(w * 0.74 + dx, h * 0.47 + dy);
      path.cubicTo(w * 0.64 + dx, h * 0.46 + dy, w * 0.55 + dx, h * 0.40 + dy, w * 0.50 + dx, h * 0.33 + dy);
      path.close();
      canvas.drawPath(path, paint);
    }

    drawGlyph(const Color(0xFF00F2FE), -1.5, -1.0);
    drawGlyph(const Color(0xFFFE0979), 1.5, 1.0);
    drawGlyph(Colors.white, 0, 0);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _YouTubePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Centered Play Triangle
    final playPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(w * 0.36, h * 0.28);
    path.lineTo(w * 0.72, h * 0.50);
    path.lineTo(w * 0.36, h * 0.72);
    path.close();
    canvas.drawPath(path, playPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _FacebookPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final w = size.width;
    final h = size.height;

    final path = Path();
    path.moveTo(w * 0.66, h * 0.95);
    path.lineTo(w * 0.46, h * 0.95);
    path.lineTo(w * 0.46, h * 0.54);
    path.lineTo(w * 0.34, h * 0.54);
    path.lineTo(w * 0.34, h * 0.40);
    path.lineTo(w * 0.46, h * 0.40);
    path.lineTo(w * 0.46, h * 0.28);
    path.cubicTo(w * 0.46, h * 0.15, w * 0.54, h * 0.08, w * 0.69, h * 0.08);
    path.cubicTo(w * 0.75, h * 0.08, w * 0.81, h * 0.09, w * 0.84, h * 0.10);
    path.lineTo(w * 0.84, h * 0.24);
    path.lineTo(w * 0.75, h * 0.24);
    path.cubicTo(w * 0.69, h * 0.24, w * 0.66, h * 0.27, w * 0.66, h * 0.34);
    path.lineTo(w * 0.66, h * 0.40);
    path.lineTo(w * 0.83, h * 0.40);
    path.lineTo(w * 0.80, h * 0.54);
    path.lineTo(w * 0.66, h * 0.54);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
