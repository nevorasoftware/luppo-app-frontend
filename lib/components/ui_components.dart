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
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
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
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: iconColor, size: 18),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 8,
              runSpacing: 4,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (badgeText != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: (badgeColor ?? iconColor).withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      badgeText!,
                      style: TextStyle(
                        color: badgeColor ?? iconColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 4),
              Text(
                subtitle!,
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ]
          ],
        ),
      ),
    );
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
