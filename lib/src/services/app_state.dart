import 'package:flutter/material.dart';
import 'dart:convert';
import 'storage_service.dart';
import 'logger_service.dart';

/// Estado de la aplicación (singleton) para gestionar el local activo y métricas.
class AppState {
  AppState._internal();
  static final AppState instance = AppState._internal();

  /// Estado de carga
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  /// Local seleccionado (id)
  final ValueNotifier<String> currentLocal = ValueNotifier<String>('principal');

  /// Métricas por local
  final ValueNotifier<Map<String, double>> metrics =
      ValueNotifier<Map<String, double>>({
        'ingresos_totales': 4634.0,
        'gastos_totales': 2000.0,
        'comensales': 13.0,
        'ticket_medio': 290.08,
        'ratio_personal': 46.0,
        'ratio_cogs': 6.0,
      });

  /// Serie de ingresos por día (L..D) para gráficas
  final ValueNotifier<List<double>> ingresosDiarios =
      ValueNotifier<List<double>>([154, 194, 0, 215, 499, 454, 709]);

  /// Valores por turno: [comida, cena]
  final ValueNotifier<List<double>> ingresosPorTurno =
      ValueNotifier<List<double>>([3966, 14473]);

  /// Serie genérica para gráficos de línea (puede mapear a restaurantes o totales)
  final ValueNotifier<List<double>> ingresosSerie = ValueNotifier<List<double>>(
    [1000, 1500, 1200, 1800, 2000, 1700, 1400],
  );

  /// Asistentes por día (L..D)
  final ValueNotifier<List<int>> asistentesDiarios =
      ValueNotifier<List<int>>([2, 11, 16, 12, 23, 0, 0]);

  /// Tickets medios por día (L..D) - calculado de ingresos/asistentes
  final ValueNotifier<List<double>> ticketsMediosDiarios =
      ValueNotifier<List<double>>([109.5, 17.6, 0, 17.9, 21.7, 0, 0]);

  /// Origen de ingresos (categorías)
  final ValueNotifier<Map<String, double>> origenIngresos =
      ValueNotifier<Map<String, double>>({});

  /// Inicializa el estado cargando datos guardados
  Future<void> initialize() async {
    try {
      isLoading.value = true;
      
      // Cargar datos guardados
      final savedMetrics = await StorageService.instance.getMetrics();
      if (savedMetrics != null && savedMetrics.isNotEmpty) {
        metrics.value = savedMetrics;
      }

      final savedIngresosDiarios =
          await StorageService.instance.getList('ingresos_diarios');
      if (savedIngresosDiarios != null) {
        ingresosDiarios.value = savedIngresosDiarios;
      }

      final savedIngresosPorTurno =
          await StorageService.instance.getList('ingresos_por_turno');
      if (savedIngresosPorTurno != null) {
        ingresosPorTurno.value = savedIngresosPorTurno;
      }

      final savedIngresosSerie =
          await StorageService.instance.getList('ingresos_serie');
      if (savedIngresosSerie != null) {
        ingresosSerie.value = savedIngresosSerie;
      }

      final savedAsistentes =
          await StorageService.instance.getStringList('asistentes_diarios');
      if (savedAsistentes != null) {
        asistentesDiarios.value =
            savedAsistentes.map((e) => int.tryParse(e) ?? 0).toList();
      }

      final savedTicketsMedios =
          await StorageService.instance.getList('tickets_medios_diarios');
      if (savedTicketsMedios != null) {
        ticketsMediosDiarios.value = savedTicketsMedios;
      }

      final savedOrigen =
          await StorageService.instance.getString('origen_ingresos');
      if (savedOrigen != null) {
        try {
          final map = jsonDecode(savedOrigen) as Map<String, dynamic>;
          origenIngresos.value =
              map.map((key, value) => MapEntry(key, (value as num).toDouble()));
        } catch (e) {
          // Si hay error, usar valores por defecto
        }
      }

      final savedLocal =
          await StorageService.instance.getString('current_local');
      if (savedLocal != null) {
        currentLocal.value = savedLocal;
      }

      LoggerService.instance.info('AppState inicializado correctamente');
    } catch (e) {
      LoggerService.instance.error('Error al inicializar AppState: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Guarda el estado actual en almacenamiento
  Future<void> saveState() async {
    try {
      await StorageService.instance.saveMetrics(metrics.value);
      await StorageService.instance.saveList('ingresos_diarios', ingresosDiarios.value);
      await StorageService.instance.saveList('ingresos_por_turno', ingresosPorTurno.value);
      await StorageService.instance.saveList('ingresos_serie', ingresosSerie.value);
      await StorageService.instance.setStringList(
        'asistentes_diarios',
        asistentesDiarios.value.map((e) => e.toString()).toList(),
      );
      await StorageService.instance.saveList(
        'tickets_medios_diarios',
        ticketsMediosDiarios.value,
      );
      await StorageService.instance.setString(
        'origen_ingresos',
        jsonEncode(origenIngresos.value),
      );
      await StorageService.instance.setString('current_local', currentLocal.value);
      LoggerService.instance.debug('Estado guardado correctamente');
    } catch (e) {
      LoggerService.instance.error('Error al guardar estado: $e');
    }
  }

  void setLocal(String id) {
    currentLocal.value = id;
    saveState();
  }

  void updateMetric(String key, double value) {
    final m = Map<String, double>.from(metrics.value);
    m[key] = value;
    metrics.value = m;
    saveState();
  }

  void updateIngresosDiarios(List<double> values) {
    ingresosDiarios.value = values;
    saveState();
  }

  void updateIngresosPorTurno(List<double> values) {
    ingresosPorTurno.value = values;
    saveState();
  }

  void updateIngresosSerie(List<double> values) {
    ingresosSerie.value = values;
    saveState();
  }

  /// Resetea el estado a valores por defecto
  void reset() {
    metrics.value = {
      'ingresos_totales': 0.0,
      'gastos_totales': 0.0,
      'comensales': 0.0,
      'ticket_medio': 0.0,
      'ratio_personal': 0.0,
      'ratio_cogs': 0.0,
    };
    ingresosDiarios.value = [0, 0, 0, 0, 0, 0, 0];
    ingresosPorTurno.value = [0, 0, 0];
    ingresosSerie.value = [0, 0, 0, 0, 0, 0, 0];
    saveState();
  }
}
