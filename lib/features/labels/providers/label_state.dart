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

  const LabelTemplatesLoaded({required this.templates, this.presets = const []});
  final List<LabelTemplate> templates;
  final List<LabelTemplate> presets;

  LabelTemplatesLoaded copyWith({List<LabelTemplate>? templates, List<LabelTemplate>? presets}) =>
      LabelTemplatesLoaded(templates: templates ?? this.templates, presets: presets ?? this.presets);
}

class LabelTemplatesError extends LabelTemplatesState {
  const LabelTemplatesError({required this.message});
  final String message;
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
  const LabelDetailLoaded({required this.template});
  final LabelTemplate template;
}

class LabelDetailSaving extends LabelDetailState {
  const LabelDetailSaving();
}

class LabelDetailSaved extends LabelDetailState {
  const LabelDetailSaved({required this.template});
  final LabelTemplate template;
}

class LabelDetailError extends LabelDetailState {
  const LabelDetailError({required this.message});
  final String message;
}
