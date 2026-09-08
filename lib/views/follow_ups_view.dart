import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../config/app_colors.dart';
import '../core/api_client.dart';
import '../models/models.dart';
import '../components/ui_components.dart';

class FollowUpsView extends StatefulWidget {
  const FollowUpsView({super.key});

  @override
  State<FollowUpsView> createState() => _FollowUpsViewState();
}

class _FollowUpsViewState extends State<FollowUpsView> with SingleTickerProviderStateMixin {
  final ApiClient _api = ApiClient();
  late TabController _tabController;
  bool _isLoading = true;

  List<FollowUpItem> _overdue = [];
  List<FollowUpItem> _today = [];
  List<FollowUpItem> _upcoming = [];
  List<FollowUpItem> _completed = [];

  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy HH:mm');

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadFollowUps();
  }

  Future<void> _loadFollowUps() async {
    setState(() => _isLoading = true);
    try {
      final res = await _api.get('/follow-ups/categorized');
      final data = res['data'] as Map<String, dynamic>;

      setState(() {
        _overdue = (data['overdue'] as List<dynamic>?)?.map((e) => FollowUpItem.fromJson(e)).toList() ?? [];
        _today = (data['today'] as List<dynamic>?)?.map((e) => FollowUpItem.fromJson(e)).toList() ?? [];
        _upcoming = (data['upcoming'] as List<dynamic>?)?.map((e) => FollowUpItem.fromJson(e)).toList() ?? [];
        _completed = (data['completed'] as List<dynamic>?)?.map((e) => FollowUpItem.fromJson(e)).toList() ?? [];
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cargar seguimientos: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _complete(String id) async {
    final noteCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Completar seguimiento'),
        content: TextField(
          controller: noteCtrl,
          decoration: const InputDecoration(labelText: 'Notas del resultado (opcional)'),
          maxLines: 2,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              try {
                await _api.patch('/follow-ups/$id/complete', {'completionNotes': noteCtrl.text.trim()});
                _loadFollowUps();
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Seguimiento completado exitosamente')),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                }
              }
            },
            child: const Text('Completar'),
          )
        ],
      ),
    );
  }

  Future<void> _reschedule(String id) async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now.add(const Duration(days: 1)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (pickedDate == null) return;

    try {
      await _api.patch('/follow-ups/$id/reschedule', {
        'newScheduledDate': pickedDate.toIso8601String(),
        'notes': 'Reprogramado desde la plataforma comercial',
      });
      _loadFollowUps();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Seguimiento reprogramado exitosamente')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'CONTROL DE COMPROMISOS',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.tealAccent, letterSpacing: 1.2),
            ),
            const SizedBox(height: 4),
            const Text(
              'Seguimientos comerciales',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 16),

            // Tab Bar
            Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border),
              ),
              child: TabBar(
                controller: _tabController,
                indicatorColor: AppColors.tealAccent,
                labelColor: AppColors.primary,
                unselectedLabelColor: AppColors.textSecondary,
                labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                tabs: [
                  Tab(text: 'Vencidos (${_overdue.length})'),
                  Tab(text: 'Para hoy (${_today.length})'),
                  Tab(text: 'Próximos (${_upcoming.length})'),
                  Tab(text: 'Completados (${_completed.length})'),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Tab View Content
            Expanded(
              child: _isLoading
                  ? const LoadingStateWidget(message: 'Cargando lista de seguimientos...')
                  : TabBarView(
                      controller: _tabController,
                      children: [
                        _buildList(_overdue, 'No tienes seguimientos vencidos. ¡Excelente trabajo!', Colors.red),
                        _buildList(_today, 'No tienes seguimientos programados para hoy.', AppColors.tealAccent),
                        _buildList(_upcoming, 'No hay próximos seguimientos agendados.', AppColors.info),
                        _buildList(_completed, 'No has completado seguimientos aún.', AppColors.success),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList(List<FollowUpItem> items, String emptyMsg, Color tagColor) {
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.event_available, size: 48, color: Colors.grey.shade400),
            const SizedBox(height: 12),
            Text(emptyMsg, style: const TextStyle(color: AppColors.textSecondary)),
          ],
        ),
      );
    }

    return ListView.separated(
      itemCount: items.length,
      separatorBuilder: (ctx, i) => const SizedBox(height: 10),
      itemBuilder: (ctx, i) {
        final item = items[i];
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: tagColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.phone_in_talk, color: tagColor, size: 20),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            item.actionType,
                            style: TextStyle(fontWeight: FontWeight.bold, color: tagColor, fontSize: 13),
                          ),
                          const SizedBox(width: 8),
                          if (item.prospectName != null)
                            Text(
                              '· ${item.prospectName}',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textPrimary),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(item.description, style: const TextStyle(fontSize: 13, color: AppColors.textPrimary)),
                      const SizedBox(height: 4),
                      Text(
                        'Fecha: ${_dateFormat.format(item.scheduledDate)} · Prioridad: ${item.priority}',
                        style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
                if (item.status != 'COMPLETADA') ...[
                  IconButton(
                    icon: const Icon(Icons.check_circle_outline, color: AppColors.success),
                    tooltip: 'Completar',
                    onPressed: () => _complete(item.id),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit_calendar, color: AppColors.info),
                    tooltip: 'Reprogramar',
                    onPressed: () => _reschedule(item.id),
                  ),
                ] else ...[
                  const Icon(Icons.done_all, color: AppColors.success, size: 22),
                ]
              ],
            ),
          ),
        );
      },
    );
  }
}
