import 'package:wameedpos/features/labels/models/label_template.dart';

// ─── Label Templates State ──────────────────────────────────────

sealed class LabelTemplatesState {
  const LabelTemplatesState();
}

class LabelTemplatesInitial extends LabelTemplatesState {
  const LabelTemplatesInitial();
}

class LabelTemplatesLoading extends LabelTemplatesState {
  const LabelTemplatesLoading();
}

class LabelTemplatesLoaded extends LabelTemplatesState {
  final List<LabelTemplate> templates;
  final List<LabelTemplate> presets;

  const LabelTemplatesLoaded({required this.templates, this.presets = const []});

  LabelTemplatesLoaded copyWith({List<LabelTemplate>? templates, List<LabelTemplate>? presets}) =>
      LabelTemplatesLoaded(templates: templates ?? this.templates, presets: presets ?? this.presets);
}

class LabelTemplatesError extends LabelTemplatesState {
  final String message;
  const LabelTemplatesError({required this.message});
}

// ─── Label Detail State ─────────────────────────────────────────

sealed class LabelDetailState {
  const LabelDetailState();
}

class LabelDetailInitial extends LabelDetailState {
  const LabelDetailInitial();
}

class LabelDetailLoading extends LabelDetailState {
  const LabelDetailLoading();
}

class LabelDetailLoaded extends LabelDetailState {
  final LabelTemplate template;
  const LabelDetailLoaded({required this.template});
}

class LabelDetailSaving extends LabelDetailState {
  const LabelDetailSaving();
}

class LabelDetailSaved extends LabelDetailState {
  final LabelTemplate template;
  const LabelDetailSaved({required this.template});
}

class LabelDetailError extends LabelDetailState {
  final String message;
  const LabelDetailError({required this.message});
}
