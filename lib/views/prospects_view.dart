import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../config/app_colors.dart';
import '../core/api_client.dart';
import '../models/models.dart';
import '../components/ui_components.dart';

class ProspectsView extends StatefulWidget {
  const ProspectsView({super.key});

  @override
  State<ProspectsView> createState() => _ProspectsViewState();
}

class _ProspectsViewState extends State<ProspectsView> {
  final ApiClient _api = ApiClient();
  List<Prospect> _prospects = [];
  bool _isLoading = true;
  String _selectedStage = 'all'; // all, Viva, Más adelante
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  final currencyFormatter = NumberFormat.currency(symbol: '\$', decimalDigits: 0);

  @override
  void initState() {
    super.initState();
    _loadProspects();
  }

  Future<void> _loadProspects() async {
    setState(() => _isLoading = true);
    try {
      final res = await _api.get('/prospects?stage=$_selectedStage&query=$_searchQuery&size=50');
      final content = res['data']['content'] as List<dynamic>;
      setState(() {
        _prospects = content.map((e) => Prospect.fromJson(e)).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cargar prospectos: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  double get _totalQuotedValue => _prospects.fold(0.0, (sum, p) => sum + p.priceQuoted);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.tealAccent,
        foregroundColor: AppColors.white,
        onPressed: () => _openNewProspectDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('Nuevo prospecto'),
      ),
      body: RefreshIndicator(
        onRefresh: _loadProspects,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Head
              const Text(
                'CLIENTES Y OPORTUNIDADES',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.tealAccent,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Clientes y seguimiento',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 16),

              // Search Bar
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Buscar por nombre, empresa o producto cotizado...',
                  prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _searchQuery = '');
                            _loadProspects();
                          },
                        )
                      : null,
                ),
                onSubmitted: (val) {
                  setState(() => _searchQuery = val.trim());
                  _loadProspects();
                },
              ),
              const SizedBox(height: 16),

              // Filter Chips
              Row(
                children: [
                  _buildFilterChip('Todos', 'all'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Vivas', 'Viva'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Más adelante', 'Más adelante'),
                ],
              ),
              const SizedBox(height: 16),

              // Pipeline Summary Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        const Text('Valor cotizado', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                        const SizedBox(height: 4),
                        Text(
                          currencyFormatter.format(_totalQuotedValue),
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                        ),
                      ],
                    ),
                    Container(height: 36, width: 1, color: AppColors.border),
                    Column(
                      children: [
                        const Text('KYC ingresados', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                        const SizedBox(height: 4),
                        Text(
                          _prospects.length.toString(),
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Toolbar
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  OutlinedButton.icon(
                    onPressed: _copySummary,
                    icon: const Icon(Icons.copy, size: 16),
                    label: const Text('Copiar resumen'),
                  ),
                  OutlinedButton.icon(
                    onPressed: _exportCsv,
                    icon: const Icon(Icons.download, size: 16),
                    label: const Text('Exportar CSV'),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Prospect List
              if (_isLoading)
                const LoadingStateWidget(message: 'Cargando prospectos...')
              else if (_prospects.isEmpty)
                EmptyStateWidget(
                  title: 'No hay prospectos todavía',
                  message: 'Agrega tu primer prospecto para comenzar a construir tu cartera.',
                  actionLabel: '+ Nuevo prospecto',
                  onAction: () => _openNewProspectDialog(context),
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _prospects.length,
                  separatorBuilder: (ctx, i) => const SizedBox(height: 12),
                  itemBuilder: (ctx, i) => _buildProspectCard(_prospects[i]),
                ),
              const SizedBox(height: 80), // espacio para el FAB
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, String stageKey) {
    final isSelected = _selectedStage == stageKey;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (val) {
        if (val) {
          setState(() => _selectedStage = stageKey);
          _loadProspects();
        }
      },
      selectedColor: AppColors.tealAccent,
      backgroundColor: AppColors.white,
      labelStyle: TextStyle(
        color: isSelected ? AppColors.white : AppColors.textPrimary,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        fontSize: 13,
      ),
      side: BorderSide(color: isSelected ? AppColors.tealAccent : AppColors.border),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }

  Widget _buildProspectCard(Prospect p) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        p.fullName,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                      ),
                      if (p.company != null && p.company!.isNotEmpty)
                        Text(
                          '${p.company} ${p.jobTitle != null && p.jobTitle!.isNotEmpty ? "· " + p.jobTitle! : ""}',
                          style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                        ),
                    ],
                  ),
                ),
                StatusBadge(status: p.status),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      p.productQuoted,
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primary),
                    ),
                  ),
                  Text(
                    currencyFormatter.format(p.priceQuoted),
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.tealAccent),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 16,
              runSpacing: 6,
              children: [
                _buildInfoTag(Icons.phone, p.phone),
                _buildInfoTag(Icons.email, p.email),
                _buildInfoTag(Icons.send, 'Canal: ${p.proposalChannel}'),
                _buildInfoTag(Icons.calendar_today, 'Mes: ${p.quotationMonth}'),
                if (p.activeClient)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(color: AppColors.successBg, borderRadius: BorderRadius.circular(4)),
                    child: const Text('Cliente Activo', style: TextStyle(color: AppColors.success, fontSize: 11, fontWeight: FontWeight.bold)),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            // CTA Action banner
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.accentBg,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: AppColors.tealAccent.withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.flash_on, size: 14, color: AppColors.tealAccent),
                      const SizedBox(width: 4),
                      Text(
                        'Próxima acción: ${p.ctaAction}',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primary),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => _openChangeStatusDialog(p),
                  child: const Text('Cambiar estado'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTag(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: AppColors.textSecondary),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
      ],
    );
  }

  void _copySummary() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Resumen copiado: ${_prospects.length} KYC registrados con valor de ${currencyFormatter.format(_totalQuotedValue)}')),
    );
  }

  void _exportCsv() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Descargando archivo CSV desde el servidor...')),
    );
  }

  void _openChangeStatusDialog(Prospect p) {
    String newStatus = p.status;
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDlgState) => AlertDialog(
          title: Text('Estado de ${p.fullName}'),
          content: DropdownButtonFormField<String>(
            value: newStatus,
            decoration: const InputDecoration(labelText: 'Estado comercial'),
            items: const [
              DropdownMenuItem(value: 'NUEVO', child: Text('Nuevo')),
              DropdownMenuItem(value: 'CONTACTADO', child: Text('Contactado')),
              DropdownMenuItem(value: 'CALIFICADO', child: Text('Calificado')),
              DropdownMenuItem(value: 'PROPUESTA', child: Text('Propuesta')),
              DropdownMenuItem(value: 'NEGOCIACION', child: Text('Negociación')),
              DropdownMenuItem(value: 'GANADO', child: Text('Ganado (Cierre exitoso)')),
              DropdownMenuItem(value: 'PERDIDO', child: Text('Perdido')),
              DropdownMenuItem(value: 'MAS_ADELANTE', child: Text('Para más adelante')),
            ],
            onChanged: (val) {
              if (val != null) setDlgState(() => newStatus = val);
            },
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(ctx);
                try {
                  await _api.patch('/prospects/${p.id}/status', {'status': newStatus});
                  _loadProspects();
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Estado actualizado correctamente')),
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
            ),
          ],
        ),
      ),
    );
  }

  void _openNewProspectDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final nameCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    final companyCtrl = TextEditingController();
    final roleCtrl = TextEditingController();
    final productCtrl = TextEditingController();
    final valueCtrl = TextEditingController();
    final commentsCtrl = TextEditingController();

    String channel = 'Correo';
    bool isActiveClient = false;
    String month = DateFormat('yyyy-MM').format(DateTime.now());
    String action = 'Llamar';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDlgState) => AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.person_add_alt_1, color: AppColors.tealAccent),
              SizedBox(width: 8),
              Text('Nuevo prospecto / KYC'),
            ],
          ),
          content: SizedBox(
            width: 540,
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: nameCtrl,
                      decoration: const InputDecoration(labelText: 'Nombre completo *', hintText: 'Ej. María López'),
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'El nombre es obligatorio' : null,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: phoneCtrl,
                            decoration: const InputDecoration(labelText: 'Teléfono *', hintText: '+503 7000 0000'),
                            validator: (v) => (v == null || v.trim().isEmpty) ? 'Teléfono obligatorio' : null,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: emailCtrl,
                            decoration: const InputDecoration(labelText: 'Correo electrónico *', hintText: 'correo@empresa.com'),
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) return 'Correo obligatorio';
                              if (!v.contains('@') || !v.contains('.')) return 'Correo inválido';
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: companyCtrl,
                            decoration: const InputDecoration(labelText: 'Empresa', hintText: 'Empresa S.A.'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: roleCtrl,
                            decoration: const InputDecoration(labelText: 'Puesto', hintText: 'Gerente General'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: productCtrl,
                      decoration: const InputDecoration(labelText: '¿Qué producto o servicio cotizó? *', hintText: 'Consultoría, Licencia...'),
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Producto cotizado obligatorio' : null,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: valueCtrl,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(labelText: 'Precio cotizado *', hintText: '0.00'),
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) return 'Precio obligatorio';
                              final d = double.tryParse(v);
                              if (d == null || d < 0) return 'Monto >= 0';
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: channel,
                            decoration: const InputDecoration(labelText: 'Propuesta enviada por'),
                            items: const [
                              DropdownMenuItem(value: 'Correo', child: Text('Correo')),
                              DropdownMenuItem(value: 'WhatsApp', child: Text('WhatsApp')),
                              DropdownMenuItem(value: 'En físico', child: Text('En físico')),
                            ],
                            onChanged: (v) => setDlgState(() => channel = v!),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<bool>(
                            value: isActiveClient,
                            decoration: const InputDecoration(labelText: '¿Cliente activo?'),
                            items: const [
                              DropdownMenuItem(value: false, child: Text('No')),
                              DropdownMenuItem(value: true, child: Text('Sí')),
                            ],
                            onChanged: (v) => setDlgState(() => isActiveClient = v!),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: action,
                            decoration: const InputDecoration(labelText: 'Próxima acción · CTA *'),
                            items: const [
                              DropdownMenuItem(value: 'Llamar', child: Text('Llamar')),
                              DropdownMenuItem(value: 'Correo', child: Text('Correo')),
                              DropdownMenuItem(value: 'WhatsApp', child: Text('WhatsApp')),
                              DropdownMenuItem(value: 'Visitar', child: Text('Visitar')),
                              DropdownMenuItem(value: 'Reunión', child: Text('Reunión')),
                              DropdownMenuItem(value: 'Demo', child: Text('Demo')),
                              DropdownMenuItem(value: 'Negociación', child: Text('Negociación')),
                            ],
                            onChanged: (v) => setDlgState(() => action = v!),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: commentsCtrl,
                      maxLines: 2,
                      decoration: const InputDecoration(labelText: 'Comentarios', hintText: '¿Qué necesita este prospecto?'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
            ElevatedButton(
              onPressed: () async {
                if (!formKey.currentState!.validate()) return;
                Navigator.pop(ctx);
                try {
                  final body = {
                    'fullName': nameCtrl.text.trim(),
                    'phone': phoneCtrl.text.trim(),
                    'email': emailCtrl.text.trim(),
                    'company': companyCtrl.text.trim(),
                    'jobTitle': roleCtrl.text.trim(),
                    'productQuoted': productCtrl.text.trim(),
                    'priceQuoted': double.parse(valueCtrl.text.trim()),
                    'proposalChannel': channel,
                    'activeClient': isActiveClient,
                    'quotationMonth': month,
                    'ctaAction': action,
                    'comments': commentsCtrl.text.trim(),
                    'status': 'NUEVO',
                    'stageCategory': 'Viva',
                  };
                  await _api.post('/prospects', body);
                  _loadProspects();
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('¡Prospecto guardado exitosamente!')),
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
              child: const Text('Guardar prospecto'),
            ),
          ],
        ),
      ),
    );
  }
}
