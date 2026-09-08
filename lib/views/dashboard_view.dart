import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../config/app_colors.dart';
import '../core/api_client.dart';
import '../models/models.dart';
import '../components/ui_components.dart';

class DashboardView extends StatefulWidget {
  final Function(int)? onNavigateTab;
  const DashboardView({super.key, this.onNavigateTab});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  final ApiClient _api = ApiClient();
  DashboardOverview? _overview;
  bool _isLoading = true;
  String? _error;

  final currencyFormatter = NumberFormat.currency(symbol: '\$', decimalDigits: 0);

  @override
  void initState() {
    super.initState();
    _loadDashboard();
  }

  Future<void> _loadDashboard() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final res = await _api.get('/dashboard/overview');
      setState(() {
        _overview = DashboardOverview.fromJson(res['data']);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const LoadingStateWidget(message: 'Calculando inteligencia de cartera y métricas...');
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 12),
            Text('Error: $_error', style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _loadDashboard, child: const Text('Reintentar')),
          ],
        ),
      );
    }

    final data = _overview!;
    final radar = data.radar;
    final health = data.health;
    final metrics = data.metrics;
    final insight = data.focusInsight;

    return RefreshIndicator(
      onRefresh: _loadDashboard,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'MI DÍA COMERCIAL',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.tealAccent,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      data.todayFormatted,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    if (widget.onNavigateTab != null) widget.onNavigateTab!(1); // Prospectos
                  },
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Nuevo prospecto'),
                )
              ],
            ),
            const SizedBox(height: 20),

            // Compromiso de Prospección Banner
            InkWell(
              onTap: () {
                if (widget.onNavigateTab != null) widget.onNavigateTab!(2); // Prospección
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.tealAccent.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.trending_up, color: AppColors.tealAccent, size: 22),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'COMPROMISO DE PROSPECCIÓN',
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            data.todayGoals.committed
                                ? 'Avance global hoy: ${data.todayGoals.overallPercentage.toStringAsFixed(0)}%'
                                : 'Define tus metas de hoy',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                          ),
                          Text(
                            data.todayGoals.statusMessage,
                            style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right, color: AppColors.textSecondary),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Radar de Cartera
            const Text(
              'RADAR DE CARTERA',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondary, letterSpacing: 1),
            ),
            const SizedBox(height: 4),
            const Text(
              'Así están tus relaciones',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 16),
            LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 700;
                return GridView.count(
                  crossAxisCount: isWide ? 4 : 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: isWide ? 1.6 : 1.3,
                  children: [
                    StatCard(
                      title: 'KYC registrados',
                      value: radar.kycCount.toString(),
                      icon: Icons.assignment_outlined,
                      iconColor: AppColors.info,
                      onTap: () => widget.onNavigateTab?.call(1),
                    ),
                    StatCard(
                      title: 'Clientes activos',
                      value: radar.activeClientsCount.toString(),
                      icon: Icons.favorite_border,
                      iconColor: AppColors.success,
                      onTap: () => widget.onNavigateTab?.call(1),
                    ),
                    StatCard(
                      title: 'Oportunidades vivas',
                      value: radar.aliveCount.toString(),
                      icon: Icons.radio_button_checked,
                      iconColor: AppColors.tealAccent,
                      onTap: () => widget.onNavigateTab?.call(1),
                    ),
                    StatCard(
                      title: 'Para más adelante',
                      value: radar.laterCount.toString(),
                      icon: Icons.schedule,
                      iconColor: AppColors.warning,
                      onTap: () => widget.onNavigateTab?.call(1),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 24),

            // Salud de Cartera & Luppo Focus
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'SALUD DE TU CARTERA',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          health.title,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          health.description,
                          style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.accentBg,
                      border: Border.all(color: AppColors.tealAccent, width: 3),
                    ),
                    child: Center(
                      child: Text(
                        '${health.score}%',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.primary),
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Luppo Focus Box
            LuppoFocusBox(
              insight: insight.primaryInsight,
              actionLabel: insight.actionLabel,
              onAction: () {
                if (insight.category == 'SEGUIMIENTO') {
                  widget.onNavigateTab?.call(3); // Seguimientos
                } else if (insight.category == 'METAS') {
                  widget.onNavigateTab?.call(2); // Prospección / Metas
                } else {
                  widget.onNavigateTab?.call(1); // Pipeline
                }
              },
            ),
            const SizedBox(height: 28),

            // Sección Métricas Comerciales
            const Text(
              'TU PROGRESO',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondary, letterSpacing: 1),
            ),
            const SizedBox(height: 4),
            const Text(
              'Métricas comerciales',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 16),

            // Hero Metric
            MetricHeroCard(
              title: 'Ventas hasta la fecha',
              value: currencyFormatter.format(metrics.salesToDate),
              goalText: '${metrics.goalAchievementPercentage.toStringAsFixed(1)}% de tu meta mensual (${currencyFormatter.format(metrics.monthlyGoal)})',
              onEditGoal: () => _showEditGoalDialog(context, metrics),
            ),
            const SizedBox(height: 16),

            // Metric Grid (6 cards)
            LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 700;
                return GridView.count(
                  crossAxisCount: isWide ? 3 : 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: isWide ? 1.8 : 1.3,
                  children: [
                    StatCard(
                      title: 'Meta mensual',
                      value: currencyFormatter.format(metrics.monthlyGoal),
                      icon: Icons.track_changes,
                      iconColor: AppColors.primary,
                    ),
                    StatCard(
                      title: 'Potenciales de cierre',
                      value: metrics.potentialClosesCount.toString(),
                      subtitle: 'Clientes este mes',
                      icon: Icons.north_east,
                      iconColor: AppColors.info,
                    ),
                    StatCard(
                      title: 'Cierres realizados',
                      value: metrics.wonDealsCount.toString(),
                      subtitle: 'Hasta la fecha',
                      icon: Icons.star_border,
                      iconColor: AppColors.warning,
                    ),
                    StatCard(
                      title: 'Monto pendiente',
                      value: currencyFormatter.format(metrics.remainingAmountForGoal),
                      subtitle: 'Para llegar a la meta',
                      icon: Icons.change_history,
                      iconColor: AppColors.secondaryBlue,
                    ),
                    StatCard(
                      title: 'Comisión ganada',
                      value: currencyFormatter.format(metrics.commissionEarnedToDate),
                      subtitle: 'Al ${metrics.commissionRate.toStringAsFixed(0)}%',
                      icon: Icons.attach_money,
                      iconColor: AppColors.success,
                    ),
                    StatCard(
                      title: 'Comisión potencial',
                      value: currencyFormatter.format(metrics.totalPotentialCommission),
                      subtitle: 'Si logro la meta',
                      icon: Icons.verified_outlined,
                      iconColor: AppColors.tealAccent,
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showEditGoalDialog(BuildContext context, CommercialMetrics metrics) {
    final targetController = TextEditingController(text: metrics.monthlyGoal.toInt().toString());
    final commController = TextEditingController(text: metrics.commissionRate.toInt().toString());

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Editar meta y comisión'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: targetController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Meta de ventas (\$)'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: commController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Porcentaje de comisión (%)'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () async {
              final target = double.tryParse(targetController.text) ?? 10000;
              final comm = double.tryParse(commController.text) ?? 10;
              Navigator.pop(ctx);
              try {
                await _api.post('/goals/monthly', {
                  'month': DateTime.now().month,
                  'year': DateTime.now().year,
                  'salesTarget': target,
                  'commissionRate': comm,
                });
                _loadDashboard();
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Meta mensual actualizada correctamente')),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
                  );
                }
              }
            },
            child: const Text('Guardar'),
          )
        ],
      ),
    );
  }
}
