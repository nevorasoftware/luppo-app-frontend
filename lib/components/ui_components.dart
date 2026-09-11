import 'package:flutter/material.dart';
import '../config/app_colors.dart';

// 0. Official Luppo Wordmark (with the iconic teal dot in the 'O')
class LuppoWordmark extends StatelessWidget {
  final double fontSize;
  final Color textColor;
  final Color dotColor;

  const LuppoWordmark({
    super.key,
    this.fontSize = 24,
    this.textColor = AppColors.white,
    this.dotColor = AppColors.tealAccent,
  });

  @override
  Widget build(BuildContext context) {
    final oSize = fontSize * 0.86;
    final borderWidth = (fontSize * 0.16).clamp(2.0, 5.0);
    final dotSize = oSize * 0.36;

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'LUPP',
          style: TextStyle(
            color: textColor,
            fontSize: fontSize,
            fontWeight: FontWeight.w900,
            letterSpacing: 2.5,
          ),
        ),
        const SizedBox(width: 2),
        Container(
          width: oSize,
          height: oSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: textColor, width: borderWidth),
          ),
          child: Center(
            child: Container(
              width: dotSize,
              height: dotSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: dotColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// Official Luppo Logo (Concentric Target Iris + Optional Wordmark)
class LuppoLogo extends StatelessWidget {
  final double size;
  final bool showText;
  final Color textColor;
  final double fontSize;

  const LuppoLogo({
    super.key,
    this.size = 56,
    this.showText = false,
    this.textColor = AppColors.white,
    this.fontSize = 24,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primary,
            border: Border.all(color: AppColors.secondaryBlue, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: AppColors.tealAccent.withOpacity(0.25),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Center(
            child: Container(
              width: size * 0.62,
              height: size * 0.62,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.white,
              ),
              child: Center(
                child: Container(
                  width: size * 0.34,
                  height: size * 0.34,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.tealAccent,
                  ),
                ),
              ),
            ),
          ),
        ),
        if (showText) ...[
          const SizedBox(height: 10),
          LuppoWordmark(
            fontSize: fontSize,
            textColor: textColor,
            dotColor: AppColors.tealAccent,
          ),
        ],
      ],
    );
  }
}

// 1. App TopBar
class LuppoTopBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String subtitle;
  final VoidCallback? onLogout;
  final String userFullName;
  final List<Widget>? actions;

  const LuppoTopBar({
    super.key,
    required this.title,
    this.subtitle = 'Tu espacio comercial',
    this.onLogout,
    this.userFullName = '',
    this.actions,
  });

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 64),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.secondaryBlue, width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                const LuppoLogo(size: 32),
                const SizedBox(width: 10),
                const LuppoWordmark(fontSize: 16),
                const SizedBox(width: 12),
                Container(width: 1, height: 24, color: AppColors.secondaryBlue),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          color: Color(0xFF94A3B8),
                          fontSize: 11,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (actions != null || userFullName.isNotEmpty || onLogout != null)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (actions != null) ...actions!,
                if (userFullName.isNotEmpty) ...[
                  const SizedBox(width: 8),
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: AppColors.tealAccent,
                    child: Text(
                      userFullName.isNotEmpty ? userFullName[0].toUpperCase() : 'U',
                      style: const TextStyle(color: AppColors.white, fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    userFullName,
                    style: const TextStyle(color: AppColors.white, fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                ],
                if (onLogout != null) ...[
                  const SizedBox(width: 12),
                  IconButton(
                    icon: const Icon(Icons.logout, color: Color(0xFF94A3B8), size: 18),
                    tooltip: 'Cerrar sesión',
                    onPressed: onLogout,
                  ),
                ],
              ],
            )
        ],
      ),
    );
  }
}

// 2. Status Badge
class StatusBadge extends StatelessWidget {
  final String status;
  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;

    switch (status.toUpperCase()) {
      case 'GANADO':
      case 'GANADA':
      case 'COMPLETADA':
      case 'ACTIVO':
        bg = AppColors.successBg;
        fg = AppColors.success;
        break;
      case 'PROPUESTA':
      case 'NEGOCIACION':
      case 'CALIFICADO':
      case 'VIVA':
        bg = AppColors.accentBg;
        fg = AppColors.tealAccent;
        break;
      case 'MAS_ADELANTE':
      case 'MÁS ADELANTE':
      case 'PENDIENTE':
        bg = AppColors.warningBg;
        fg = AppColors.warning;
        break;
      case 'PERDIDO':
      case 'PERDIDA':
      case 'VENCIDA':
      case 'CANCELADA':
        bg = const Color(0xFFFEE2E2);
        fg = const Color(0xFFDC2626);
        break;
      default:
        bg = const Color(0xFFF3F4F6);
        fg = AppColors.textSecondary;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.replaceAll('_', ' '),
        style: TextStyle(
          color: fg,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// 3. Stat Card
class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  final IconData icon;
  final Color iconColor;
  final VoidCallback? onTap;
  final String? badgeText;
  final Color? badgeColor;
  final bool showChart;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    this.subtitle,
    required this.icon,
    this.iconColor = AppColors.tealAccent,
    this.onTap,
    this.badgeText,
    this.badgeColor,
    this.showChart = true,
  });

  static _StatCardChartData _getChartData(String title, String value, Color color) {
    final lower = title.toLowerCase();

    if (lower.contains('kyc')) {
      return const _StatCardChartData(
        points: [1.0, 2.0, 2.0, 3.0, 3.0, 4.0, 4.0],
        labels: ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Hoy'],
        trendText: '+33% semana',
        isPositive: true,
        peakValue: '4 KYC',
        averageValue: '2.7/día',
        insightDescription: 'Registro y validación continua de expedientes KYC con tendencia creciente.',
      );
    } else if (lower.contains('activo') || lower.contains('clientes')) {
      return const _StatCardChartData(
        points: [0.0, 0.0, 1.0, 1.0, 1.0, 1.0, 1.0],
        labels: ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Hoy'],
        trendText: '100% activo',
        isPositive: true,
        peakValue: '1 cliente',
        averageValue: '1.0 prom.',
        insightDescription: 'Cuentas comerciales activas manteniendo relaciones comerciales y acuerdos.',
      );
    } else if (lower.contains('oportunidad') || lower.contains('vivas')) {
      return const _StatCardChartData(
        points: [1.0, 2.0, 2.0, 3.0, 2.0, 3.0, 3.0],
        labels: ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Hoy'],
        trendText: '+50% embudo',
        isPositive: true,
        peakValue: '3 activas',
        averageValue: '2.3/día',
        insightDescription: 'Negocios en fases de prospección y propuesta con alto dinamismo comercial.',
      );
    } else if (lower.contains('adelante') || lower.contains('más')) {
      return const _StatCardChartData(
        points: [2.0, 2.0, 1.0, 1.0, 1.0, 1.0, 1.0],
        labels: ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Hoy'],
        trendText: 'En control',
        isPositive: true,
        peakValue: '2 máx.',
        averageValue: '1.3 leads',
        insightDescription: 'Prospectos pausados temporalmente para seguimiento en fecha calendarizada.',
      );
    } else if (lower.contains('meta mensual')) {
      return const _StatCardChartData(
        points: [4000.0, 6000.0, 8500.0, 9500.0, 10800.0, 11500.0, 12000.0],
        labels: ['Sem 1', 'Sem 2', 'Sem 3', 'Sem 4', 'Proy.', 'Ajuste', 'Meta'],
        trendText: '100% objetivo',
        isPositive: true,
        peakValue: '\$12,000',
        averageValue: '\$8,900',
        insightDescription: 'Objetivo de ingresos globales planificado para el periodo comercial activo.',
      );
    } else if (lower.contains('potencial') && lower.contains('cierre')) {
      return const _StatCardChartData(
        points: [0.0, 1.0, 1.0, 1.0, 2.0, 2.0, 2.0],
        labels: ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Hoy'],
        trendText: '+100% prob.',
        isPositive: true,
        peakValue: '2 clientes',
        averageValue: '1.3 tratos',
        insightDescription: 'Prospectos con alta intención de compra listos para firma de contrato.',
      );
    } else if (lower.contains('cierre') && lower.contains('realizado')) {
      return const _StatCardChartData(
        points: [0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 1.0],
        labels: ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Hoy'],
        trendText: '1 ganado',
        isPositive: true,
        peakValue: '1 venta',
        averageValue: '100% éxito',
        insightDescription: 'Ventas cerradas con contrato formalizado y liquidación de cuota aprobada.',
      );
    } else if (lower.contains('pendiente')) {
      return const _StatCardChartData(
        points: [12000.0, 11800.0, 11200.0, 10500.0, 9900.0, 9500.0, 9200.0],
        labels: ['Día 1', 'Día 5', 'Día 10', 'Día 15', 'Día 20', 'Día 25', 'Hoy'],
        trendText: '-23.3% restante',
        isPositive: true,
        peakValue: '\$12,000 inicial',
        averageValue: '\$10,580',
        insightDescription: 'Brecha restante por facturar para el cumplimiento completo de la meta mensual.',
      );
    } else if (lower.contains('ganada')) {
      return const _StatCardChartData(
        points: [0.0, 40.0, 90.0, 150.0, 210.0, 250.0, 280.0],
        labels: ['Sem 1', 'Sem 2', 'Sem 3', 'Sem 4', 'Ayer', 'Hoy', 'Total'],
        trendText: '+40% ganado',
        isPositive: true,
        peakValue: '\$280 devengado',
        averageValue: '\$145 prom.',
        insightDescription: 'Comisiones devengadas efectivamente al porcentaje pactado sobre cierres.',
      );
    } else if (lower.contains('comisión') && lower.contains('potencial')) {
      return const _StatCardChartData(
        points: [500.0, 700.0, 850.0, 980.0, 1080.0, 1150.0, 1200.0],
        labels: ['Sem 1', 'Sem 2', 'Sem 3', 'Sem 4', 'P. Caliente', 'Proy.', 'Meta'],
        trendText: '\$1,200 proy.',
        isPositive: true,
        peakValue: '\$1,200',
        averageValue: '\$920',
        insightDescription: 'Proyección de compensación económica total si se cumple la meta al 100%.',
      );
    } else {
      return const _StatCardChartData(
        points: [10.0, 14.0, 18.0, 22.0, 25.0, 29.0, 35.0],
        labels: ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Hoy'],
        trendText: '+18% ritmo',
        isPositive: true,
        peakValue: 'En alza',
        averageValue: 'Constante',
        insightDescription: 'Comportamiento comercial con volumen positivo y evolución sostenida.',
      );
    }
  }

  void _showChartModal(BuildContext context, _StatCardChartData chartData) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 480),
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.12),
                  blurRadius: 24,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Modal Header
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: iconColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(icon, color: iconColor, size: 22),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title.toUpperCase(),
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textSecondary,
                                letterSpacing: 0.8,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 8,
                              runSpacing: 4,
                              children: [
                                Text(
                                  value,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                                  decoration: BoxDecoration(
                                    color: (chartData.isPositive ? AppColors.success : AppColors.info).withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        chartData.isPositive ? Icons.trending_up : Icons.trending_flat,
                                        size: 12,
                                        color: chartData.isPositive ? AppColors.success : AppColors.info,
                                      ),
                                      const SizedBox(width: 3),
                                      Text(
                                        chartData.trendText,
                                        style: TextStyle(
                                          fontSize: 10.5,
                                          fontWeight: FontWeight.bold,
                                          color: chartData.isPositive ? AppColors.success : AppColors.info,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            if (subtitle != null) ...[
                              const SizedBox(height: 2),
                              Text(
                                subtitle!,
                                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                              ),
                            ],
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(ctx),
                        icon: const Icon(Icons.close, size: 20, color: AppColors.textSecondary),
                        tooltip: 'Cerrar',
                        visualDensity: VisualDensity.compact,
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),
                  const Divider(height: 1, color: AppColors.border),
                  const SizedBox(height: 14),

                  // Section Title
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'TENDENCIA ESTIMADA (7 DÍAS)',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textSecondary,
                          letterSpacing: 0.5,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.06),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'Gráfica interactiva',
                          style: TextStyle(fontSize: 10, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Detailed Chart Canvas
                  Container(
                    height: 140,
                    width: double.infinity,
                    padding: const EdgeInsets.only(top: 12, bottom: 4, left: 8, right: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: LuppoDetailedChart(
                      points: chartData.points,
                      labels: chartData.labels,
                      color: iconColor,
                    ),
                  ),

                  const SizedBox(height: 14),

                  // 3 Insight Stats
                  Row(
                    children: [
                      Expanded(
                        child: _buildModalStat(
                          label: 'Pico Máx.',
                          value: chartData.peakValue,
                          icon: Icons.vertical_align_top,
                          color: iconColor,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildModalStat(
                          label: 'Promedio',
                          value: chartData.averageValue,
                          icon: Icons.bar_chart,
                          color: AppColors.secondaryBlue,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildModalStat(
                          label: 'Ritmo',
                          value: chartData.isPositive ? 'Positivo' : 'Estable',
                          icon: Icons.show_chart,
                          color: AppColors.success,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Insight description box
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(11),
                    decoration: BoxDecoration(
                      color: iconColor.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: iconColor.withOpacity(0.2)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.insights, size: 16, color: iconColor),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            chartData.insightDescription,
                            style: const TextStyle(
                              fontSize: 11.5,
                              color: AppColors.textPrimary,
                              height: 1.35,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  // Actions
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (onTap != null) ...[
                        OutlinedButton.icon(
                          onPressed: () {
                            Navigator.pop(ctx);
                            onTap!();
                          },
                          icon: const Icon(Icons.arrow_forward, size: 15),
                          label: const Text('Ir al módulo'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.primary,
                            side: const BorderSide(color: AppColors.border),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                      ElevatedButton(
                        onPressed: () => Navigator.pop(ctx),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                        ),
                        child: const Text('Cerrar'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildModalStat({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 11, color: color),
              const SizedBox(width: 3),
              Expanded(
                child: Text(
                  label.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 3),
          Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final chartData = _getChartData(title, value, iconColor);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _showChartModal(context, chartData),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      title.toUpperCase(),
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: iconColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(icon, color: iconColor, size: 16),
                  ),
                ],
              ),

              if (showChart) ...[
                const SizedBox(height: 6),
                // Mini Sparkline
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 24,
                        child: LuppoMiniSparkline(
                          points: chartData.points,
                          color: iconColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                      decoration: BoxDecoration(
                        color: (chartData.isPositive ? AppColors.success : AppColors.info).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            chartData.isPositive ? Icons.trending_up : Icons.trending_flat,
                            size: 10,
                            color: chartData.isPositive ? AppColors.success : AppColors.info,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            chartData.trendText.split(' ').first,
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: chartData.isPositive ? AppColors.success : AppColors.info,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
              ] else
                const SizedBox(height: 8),

              // Bottom Value + Subtitle
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          value,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            height: 1.1,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (subtitle != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            subtitle!,
                            style: const TextStyle(color: AppColors.textSecondary, fontSize: 11.5),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (badgeText != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: (badgeColor ?? iconColor).withOpacity(0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        badgeText!,
                        style: TextStyle(
                          color: badgeColor ?? iconColor,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  else
                    Icon(
                      Icons.query_stats_rounded,
                      size: 14,
                      color: AppColors.textSecondary.withOpacity(0.35),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCardChartData {
  final List<double> points;
  final List<String> labels;
  final String trendText;
  final bool isPositive;
  final String peakValue;
  final String averageValue;
  final String insightDescription;

  const _StatCardChartData({
    required this.points,
    required this.labels,
    required this.trendText,
    required this.isPositive,
    required this.peakValue,
    required this.averageValue,
    required this.insightDescription,
  });
}

class LuppoMiniSparkline extends StatelessWidget {
  final List<double> points;
  final Color color;

  const LuppoMiniSparkline({
    super.key,
    required this.points,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(double.infinity, 24),
      painter: _MiniSparklinePainter(
        points: points,
        color: color,
      ),
    );
  }
}

class _MiniSparklinePainter extends CustomPainter {
  final List<double> points;
  final Color color;

  _MiniSparklinePainter({
    required this.points,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;

    final minVal = points.reduce((a, b) => a < b ? a : b);
    final maxVal = points.reduce((a, b) => a > b ? a : b);
    final range = (maxVal - minVal) == 0 ? 1.0 : (maxVal - minVal);

    const topPad = 3.0;
    const bottomPad = 3.0;
    final usableHeight = size.height - topPad - bottomPad;
    final dx = size.width / (points.length - 1);

    final linePath = Path();
    final fillPath = Path();

    List<Offset> offsets = [];
    for (int i = 0; i < points.length; i++) {
      final normY = (points[i] - minVal) / range;
      final x = i * dx;
      final y = size.height - bottomPad - (normY * usableHeight);
      offsets.add(Offset(x, y));
    }

    linePath.moveTo(offsets[0].dx, offsets[0].dy);
    fillPath.moveTo(offsets[0].dx, offsets[0].dy);

    for (int i = 0; i < offsets.length - 1; i++) {
      final p0 = offsets[i];
      final p1 = offsets[i + 1];
      final cx = (p0.dx + p1.dx) / 2;
      linePath.cubicTo(cx, p0.dy, cx, p1.dy, p1.dx, p1.dy);
      fillPath.cubicTo(cx, p0.dy, cx, p1.dy, p1.dx, p1.dy);
    }

    fillPath.lineTo(size.width, size.height);
    fillPath.lineTo(0, size.height);
    fillPath.close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          color.withOpacity(0.25),
          color.withOpacity(0.0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    canvas.drawPath(fillPath, fillPaint);

    final linePaint = Paint()
      ..color = color
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(linePath, linePaint);

    final last = offsets.last;
    final dotPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final haloPaint = Paint()
      ..color = color.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(last, 3.5, haloPaint);
    canvas.drawCircle(last, 2.0, dotPaint);
  }

  @override
  bool shouldRepaint(covariant _MiniSparklinePainter oldDelegate) {
    return oldDelegate.points != points || oldDelegate.color != color;
  }
}

class LuppoDetailedChart extends StatelessWidget {
  final List<double> points;
  final List<String> labels;
  final Color color;

  const LuppoDetailedChart({
    super.key,
    required this.points,
    required this.labels,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: CustomPaint(
            size: Size.infinite,
            painter: _DetailedChartPainter(
              points: points,
              color: color,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: labels.map((l) {
            final isLast = l == labels.last;
            return Text(
              l,
              style: TextStyle(
                fontSize: 9.5,
                fontWeight: isLast ? FontWeight.bold : FontWeight.w500,
                color: isLast ? color : AppColors.textSecondary,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _DetailedChartPainter extends CustomPainter {
  final List<double> points;
  final Color color;

  _DetailedChartPainter({
    required this.points,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;

    final minVal = points.reduce((a, b) => a < b ? a : b);
    final maxVal = points.reduce((a, b) => a > b ? a : b);
    final range = (maxVal - minVal) == 0 ? 1.0 : (maxVal - minVal);

    final gridPaint = Paint()
      ..color = AppColors.border.withOpacity(0.7)
      ..strokeWidth = 1.0;

    for (int i = 0; i <= 2; i++) {
      final y = size.height * (i / 2.0);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    const topPad = 12.0;
    const bottomPad = 8.0;
    final usableHeight = size.height - topPad - bottomPad;
    final dx = size.width / (points.length - 1);

    final linePath = Path();
    final fillPath = Path();

    List<Offset> offsets = [];
    int maxIdx = 0;
    double highest = points[0];

    for (int i = 0; i < points.length; i++) {
      if (points[i] > highest) {
        highest = points[i];
        maxIdx = i;
      }
      final normY = (points[i] - minVal) / range;
      final x = i * dx;
      final y = size.height - bottomPad - (normY * usableHeight);
      offsets.add(Offset(x, y));
    }

    linePath.moveTo(offsets[0].dx, offsets[0].dy);
    fillPath.moveTo(offsets[0].dx, offsets[0].dy);

    for (int i = 0; i < offsets.length - 1; i++) {
      final p0 = offsets[i];
      final p1 = offsets[i + 1];
      final cx = (p0.dx + p1.dx) / 2;
      linePath.cubicTo(cx, p0.dy, cx, p1.dy, p1.dx, p1.dy);
      fillPath.cubicTo(cx, p0.dy, cx, p1.dy, p1.dx, p1.dy);
    }

    fillPath.lineTo(size.width, size.height);
    fillPath.lineTo(0, size.height);
    fillPath.close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          color.withOpacity(0.32),
          color.withOpacity(0.01),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    canvas.drawPath(fillPath, fillPaint);

    final linePaint = Paint()
      ..color = color
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(linePath, linePaint);

    for (int i = 0; i < offsets.length; i++) {
      final pt = offsets[i];
      final isMax = i == maxIdx;
      final isLast = i == offsets.length - 1;

      if (isMax || isLast) {
        final haloPaint = Paint()
          ..color = color.withOpacity(0.2)
          ..style = PaintingStyle.fill;
        canvas.drawCircle(pt, 7.0, haloPaint);
      }

      final dotOuter = Paint()
        ..color = color
        ..style = PaintingStyle.fill;
      final dotInner = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;

      canvas.drawCircle(pt, 4.0, dotOuter);
      canvas.drawCircle(pt, 2.0, dotInner);
    }
  }

  @override
  bool shouldRepaint(covariant _DetailedChartPainter oldDelegate) {
    return oldDelegate.points != points || oldDelegate.color != color;
  }
}

// 4. Metric Hero Card
class MetricHeroCard extends StatelessWidget {
  final String title;
  final String value;
  final String goalText;
  final VoidCallback? onEditGoal;

  const MetricHeroCard({
    super.key,
    required this.title,
    required this.value,
    required this.goalText,
    this.onEditGoal,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary,
            AppColors.secondaryBlue,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.secondaryBlue.withOpacity(0.5), width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.25),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title.toUpperCase(),
                style: const TextStyle(
                  color: AppColors.tealAccent,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
              if (onEditGoal != null)
                TextButton.icon(
                  onPressed: onEditGoal,
                  icon: const Icon(Icons.edit, size: 14, color: AppColors.white),
                  label: const Text(
                    'Editar meta y comisión',
                    style: TextStyle(color: AppColors.white, fontSize: 12),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: AppColors.secondaryBlue,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  ),
                )
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 36,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            goalText,
            style: const TextStyle(
              color: Color(0xFF94A3B8),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// 5. Insight Focus Box
class LuppoFocusBox extends StatelessWidget {
  final String insight;
  final String? actionLabel;
  final VoidCallback? onAction;

  const LuppoFocusBox({
    super.key,
    required this.insight,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.accentBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.tealAccent.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.tealAccent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.auto_awesome, color: AppColors.white, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'LUPPO FOCUS',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  insight,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: onAction,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.tealAccent,
                foregroundColor: AppColors.white,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              ),
              child: Text(actionLabel!),
            )
          ]
        ],
      ),
    );
  }
}

// 6. Empty State
class EmptyStateWidget extends StatelessWidget {
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final IconData icon;

  const EmptyStateWidget({
    super.key,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
    this.icon = Icons.folder_open_outlined,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56, color: const Color(0xFF94A3B8)),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: onAction,
                icon: const Icon(Icons.add, size: 18),
                label: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// 7. Loading State
class LoadingStateWidget extends StatelessWidget {
  final String message;
  const LoadingStateWidget({super.key, this.message = 'Cargando datos comerciales...'});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(color: AppColors.tealAccent),
          const SizedBox(height: 16),
          Text(message, style: const TextStyle(color: AppColors.textSecondary, fontSize: 14)),
        ],
      ),
    );
  }
}
