import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../config/app_colors.dart';
import '../core/api_client.dart';
import '../models/models.dart';
import '../components/ui_components.dart';

class PipelineView extends StatefulWidget {
  const PipelineView({Key? key}) : super(key: key);

  @override
  State<PipelineView> createState() => _PipelineViewState();
}

class _PipelineViewState extends State<PipelineView> {
  bool _isLoading = true;
  String? _error;
  List<OpportunityDTO> _opportunities = [];
  final _currencyFormat = NumberFormat.currency(locale: 'es_MX', symbol: r'$', decimalDigits: 2);

  final List<String> _stages = [
    'Contacto Inicial',
    'Diagnóstico',
    'Propuesta Comercial',
    'Negociación',
    'Cierre Ganado',
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final opps = await ApiClient.getOpportunities();
      if (mounted) {
        setState(() {
          _opportunities = opps;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString().replaceAll('Exception: ', '');
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _changeOpportunityStage(OpportunityDTO opp, String newStage) async {
    try {
      final updated = await ApiClient.updateOpportunity(opp.id, {
        'stageName': newStage,
      });
      setState(() {
        final idx = _opportunities.indexWhere((o) => o.id == opp.id);
        if (idx != -1) {
          _opportunities[idx] = updated;
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Oportunidad movida a "$newStage"'),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al cambiar etapa: $e'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const LoadingStateWidget(message: 'Cargando pipeline comercial...');
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Error: $_error', style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: _loadData, child: const Text('Reintentar')),
          ],
        ),
      );
    }

    final totalValue = _opportunities.fold<double>(0.0, (sum, o) => sum + o.estimatedValue);
    final openOpps = _opportunities.where((o) => o.stageName != 'Cierre Ganado' && o.stageName != 'Cierre Perdido').toList();
    final wonOpps = _opportunities.where((o) => o.stageName == 'Cierre Ganado').toList();

    return RefreshIndicator(
      onRefresh: _loadData,
      color: AppColors.accent,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LuppoTopBar(
              title: 'Cartera de Oportunidades',
              subtitle: 'Gestión activa del embudo de ventas y forecast comercial',
              actions: [
                IconButton(
                  icon: const Icon(Icons.refresh, color: AppColors.white),
                  onPressed: _loadData,
                  tooltip: 'Actualizar',
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Metrics row
            Row(
              children: [
                Expanded(
                  child: StatCard(
                    title: 'VALOR TOTAL DEL PIPELINE',
                    value: _currencyFormat.format(totalValue),
                    icon: Icons.monetization_on_outlined,
                    iconColor: AppColors.accent,
                    badgeText: '${_opportunities.length} negocios',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: StatCard(
                    title: 'OPORTUNIDADES ACTIVAS',
                    value: '${openOpps.length}',
                    icon: Icons.trending_up,
                    iconColor: AppColors.secondary,
                    subtitle: 'En proceso de negociación',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: StatCard(
                    title: 'NEGOCIOS GANADOS',
                    value: '${wonOpps.length}',
                    icon: Icons.check_circle_outline,
                    iconColor: AppColors.success,
                    badgeText: 'Ganados',
                    badgeColor: AppColors.success,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),

            // Kanban Pipeline Columns
            const Text(
              'Embudo Comercial (Pipeline)',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 16),

            SizedBox(
              height: 580,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _stages.length,
                separatorBuilder: (_, __) => const SizedBox(width: 16),
                itemBuilder: (context, index) {
                  final stage = _stages[index];
                  final oppsInStage = _opportunities.where((o) => o.stageName == stage).toList();
                  final stageSum = oppsInStage.fold<double>(0.0, (s, o) => s + o.estimatedValue);

                  return Container(
                    width: 280,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.divider),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Column Header
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.03),
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                            border: const Border(bottom: BorderSide(color: AppColors.divider)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                stage,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.primary),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.accent.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  '${oppsInStage.length}',
                                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.accent),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Text(
                            'Subtotal: ${_currencyFormat.format(stageSum)}',
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
                          ),
                        ),
                        const Divider(height: 1, color: AppColors.divider),

                        // Opportunity cards list
                        Expanded(
                          child: oppsInStage.isEmpty
                              ? const Center(
                                  child: Text('Sin oportunidades', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                                )
                              : ListView.separated(
                                  padding: const EdgeInsets.all(12),
                                  itemCount: oppsInStage.length,
                                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                                  itemBuilder: (context, idx) {
                                    final opp = oppsInStage[idx];
                                    return Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(color: AppColors.divider),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.02),
                                            blurRadius: 6,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            opp.title,
                                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.primary),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            opp.prospectName,
                                            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                                          ),
                                          const SizedBox(height: 10),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                _currencyFormat.format(opp.estimatedValue),
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: AppColors.accent,
                                                  fontSize: 13,
                                                ),
                                              ),
                                              Text(
                                                '${opp.probability}% prob.',
                                                style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          // Stage move button
                                          PopupMenuButton<String>(
                                            tooltip: 'Mover etapa',
                                            onSelected: (targetStage) => _changeOpportunityStage(opp, targetStage),
                                            itemBuilder: (context) {
                                              return _stages
                                                  .where((s) => s != opp.stageName)
                                                  .map(
                                                    (s) => PopupMenuItem(
                                                      value: s,
                                                      child: Text('Mover a $s', style: const TextStyle(fontSize: 12)),
                                                    ),
                                                  )
                                                  .toList();
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                              decoration: BoxDecoration(
                                                color: AppColors.background,
                                                borderRadius: BorderRadius.circular(6),
                                                border: Border.all(color: AppColors.divider),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: const [
                                                  Text('Cambiar etapa', style: TextStyle(fontSize: 11, color: AppColors.primary)),
                                                  SizedBox(width: 4),
                                                  Icon(Icons.arrow_drop_down, size: 16, color: AppColors.primary),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
