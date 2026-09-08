import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import '../core/api_client.dart';
import '../models/models.dart';
import '../components/ui_components.dart';

class ProspectingView extends StatefulWidget {
  const ProspectingView({super.key});

  @override
  State<ProspectingView> createState() => _ProspectingViewState();
}

class _ProspectingViewState extends State<ProspectingView> {
  final ApiClient _api = ApiClient();
  DailyGoal? _dailyGoal;
  bool _isLoading = true;

  late TextEditingController _coldTargetCtrl;
  late TextEditingController _callsTargetCtrl;
  late TextEditingController _followTargetCtrl;
  late TextEditingController _emailsTargetCtrl;

  @override
  void initState() {
    super.initState();
    _coldTargetCtrl = TextEditingController(text: '3');
    _callsTargetCtrl = TextEditingController(text: '10');
    _followTargetCtrl = TextEditingController(text: '8');
    _emailsTargetCtrl = TextEditingController(text: '5');
    _loadDailyGoal();
  }

  Future<void> _loadDailyGoal() async {
    setState(() => _isLoading = true);
    try {
      final res = await _api.get('/goals/daily');
      final goal = DailyGoal.fromJson(res['data']);
      setState(() {
        _dailyGoal = goal;
        _coldTargetCtrl.text = goal.coldContactsTarget.toString();
        _callsTargetCtrl.text = goal.callsTarget.toString();
        _followTargetCtrl.text = goal.followUpsTarget.toString();
        _emailsTargetCtrl.text = goal.emailsTarget.toString();
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cargar metas: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _commitGoals() async {
    final cold = int.tryParse(_coldTargetCtrl.text) ?? 3;
    final calls = int.tryParse(_callsTargetCtrl.text) ?? 10;
    final follow = int.tryParse(_followTargetCtrl.text) ?? 8;
    final email = int.tryParse(_emailsTargetCtrl.text) ?? 5;

    if (cold < 1 || cold > 5) {
      _showToast('Toques en frío debe ser entre 1 y 5');
      return;
    }
    if (calls < 1 || calls > 15) {
      _showToast('Llamadas debe ser entre 1 y 15');
      return;
    }
    if (follow < 1 || follow > 15) {
      _showToast('Seguimientos debe ser entre 1 y 15');
      return;
    }
    if (email < 1 || email > 15) {
      _showToast('Correos debe ser entre 1 y 15');
      return;
    }

    try {
      final res = await _api.post('/goals/daily/commit', {
        'coldContactsTarget': cold,
        'callsTarget': calls,
        'followUpsTarget': follow,
        'emailsTarget': email,
      });
      setState(() {
        _dailyGoal = DailyGoal.fromJson(res['data']);
      });
      _showToast('¡Te has comprometido con tus metas de hoy!');
    } catch (e) {
      _showToast('Error: $e');
    }
  }

  Future<void> _increment(String type) async {
    try {
      final res = await _api.post('/goals/daily/increment', {'type': type});
      setState(() {
        _dailyGoal = DailyGoal.fromJson(res['data']);
      });
    } catch (e) {
      _showToast('Error al registrar avance: $e');
    }
  }

  void _showToast(String msg) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const LoadingStateWidget(message: 'Cargando metas diarias de prospección...');
    }

    final g = _dailyGoal!;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            const Text(
              'METAS DIARIAS',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.tealAccent, letterSpacing: 1.2),
            ),
            const SizedBox(height: 4),
            const Text(
              'Prospección',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 16),

            // Luppo Focus Quote
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.accentBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.tealAccent.withOpacity(0.3)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.lightbulb_outline, color: AppColors.tealAccent, size: 24),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('LUPPO FOCUS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.primary)),
                        SizedBox(height: 2),
                        Text('Cada oportunidad merece un próximo paso.', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Compromiso de Hoy
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: g.committed ? AppColors.successBg : AppColors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: g.committed ? AppColors.success : AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'COMPROMISO DE HOY',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: g.committed ? AppColors.success : AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    g.committed
                        ? '¡Compromiso activo! ${g.overallPercentage.toStringAsFixed(0)}% completado'
                        : 'Aún no has fijado tus metas',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    g.statusMessage,
                    style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 4 Daily Goal Cards
            LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 700;
                return GridView.count(
                  crossAxisCount: isWide ? 2 : 1,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: isWide ? 2.3 : 1.9,
                  children: [
                    _buildGoalCard(
                      title: 'Toques en frío',
                      limitText: 'Meta permitida: 1 a 5',
                      targetCtrl: _coldTargetCtrl,
                      doneCount: g.coldContactsDone,
                      pct: g.coldContactsPercentage,
                      actionLabel: '+ Registrar uno',
                      onAdd: () => _increment('cold'),
                    ),
                    _buildGoalCard(
                      title: 'Llamadas',
                      limitText: 'Meta permitida: 1 a 15',
                      targetCtrl: _callsTargetCtrl,
                      doneCount: g.callsDone,
                      pct: g.callsPercentage,
                      actionLabel: '+ Registrar una',
                      onAdd: () => _increment('calls'),
                    ),
                    _buildGoalCard(
                      title: 'Seguimiento a clientes existentes',
                      limitText: 'Meta permitida: 1 a 15',
                      targetCtrl: _followTargetCtrl,
                      doneCount: g.followUpsDone,
                      pct: g.followUpsPercentage,
                      actionLabel: '+ Registrar uno',
                      onAdd: () => _increment('follow'),
                    ),
                    _buildGoalCard(
                      title: 'Correos o reenvíos de propuesta',
                      limitText: 'Meta permitida: 1 a 15',
                      targetCtrl: _emailsTargetCtrl,
                      doneCount: g.emailsDone,
                      pct: g.emailsPercentage,
                      actionLabel: '+ Registrar uno',
                      onAdd: () => _increment('email'),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 28),

            // Botón de Compromiso
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _commitGoals,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.tealAccent,
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                child: const Text('Me comprometo con estas metas'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalCard({
    required String title,
    required String limitText,
    required TextEditingController targetCtrl,
    required int doneCount,
    required double pct,
    required String actionLabel,
    required VoidCallback onAdd,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                      Text(limitText, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                    ],
                  ),
                ),
                Text(
                  '${pct.toStringAsFixed(0)}%',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.tealAccent),
                ),
              ],
            ),
            Row(
              children: [
                SizedBox(
                  width: 90,
                  child: TextField(
                    controller: targetCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Mi meta', contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8)),
                  ),
                ),
                const SizedBox(width: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Llevas: $doneCount',
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.primary),
                  ),
                ),
                const Spacer(),
                OutlinedButton(
                  onPressed: onAdd,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.tealAccent,
                    side: const BorderSide(color: AppColors.tealAccent),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  child: Text(actionLabel, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: (pct / 100.0).clamp(0.0, 1.0),
                backgroundColor: AppColors.border,
                color: pct >= 100.0 ? AppColors.success : AppColors.tealAccent,
                minHeight: 8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
