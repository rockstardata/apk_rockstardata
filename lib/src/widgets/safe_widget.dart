import 'package:flutter/material.dart';

class SafeWidget extends StatelessWidget {
  final WidgetBuilder builder;
  final Widget Function(BuildContext, Object, StackTrace?)? errorBuilder;

  const SafeWidget({super.key, required this.builder, this.errorBuilder});

  @override
  Widget build(BuildContext context) {
    return ErrorWidgetBuilder(
      builder: (context) {
        try {
          return builder(context);
        } catch (e, st) {
          return errorBuilder?.call(context, e, st) ??
              _defaultErrorWidget(context, e);
        }
      },
    );
  }

  Widget _defaultErrorWidget(BuildContext context, Object error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            Text(
              'Error al cargar el componente:\n$error',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}

class ErrorWidgetBuilder extends StatefulWidget {
  final Widget Function(BuildContext) builder;

  const ErrorWidgetBuilder({super.key, required this.builder});

  @override
  State<ErrorWidgetBuilder> createState() => _ErrorWidgetBuilderState();
}

class _ErrorWidgetBuilderState extends State<ErrorWidgetBuilder> {
  @override
  Widget build(BuildContext context) {
    try {
      return widget.builder(context);
    } catch (e, st) {
      return Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Error crítico: $e\n$st',
            style: const TextStyle(color: Colors.red),
          ),
        ),
      );
    }
  }
}
