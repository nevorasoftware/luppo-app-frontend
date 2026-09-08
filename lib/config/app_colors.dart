import 'package:flutter/material.dart';

class AppColors {
  // Paleta Estricta Oficial Luppo
  static const Color primary = Color(0xFF112A46);       // Fondos, navegación, encabezados, sidebar
  static const Color tealAccent = Color(0xFF19A7A0);   // Botones principales, CTA, estados activos
  static const Color secondaryBlue = Color(0xFF183957); // Cards oscuras, hover, diagramas
  static const Color white = Color(0xFFFFFFFF);         // Superficies, cards, texto sobre oscuros
  static const Color info = Color(0xFF316B9E);          // Información, enlaces, indicadores
  static const Color success = Color(0xFF2F9E6E);       // Cumplimiento, progreso, estados positivos
  static const Color warning = Color(0xFFD99A2B);       // Alertas, riesgos, atención
  static const Color accentBg = Color(0xFFEAF5F8);      // Bloques suaves, insights, filtros
  static const Color textPrimary = Color(0xFF1F2937);   // Títulos, métricas, contenido prioritario
  static const Color successBg = Color(0xFFF0FAF9);     // Fondos estados positivos
  static const Color background = Color(0xFFF5F7FA);    // Fondo general
  static const Color border = Color(0xFFD8E2EA);        // Separadores, contornos, tablas, inputs
  static const Color textSecondary = Color(0xFF667085); // Etiquetas, ayudas, soporte
  static const Color warningBg = Color(0xFFFFF9EF);     // Alertas, avisos

  // Aliases de compatibilidad UI
  static const Color accent = tealAccent;
  static const Color secondary = secondaryBlue;
  static const Color surface = white;
  static const Color divider = border;
  static const Color accentSoft = accentBg;
}
