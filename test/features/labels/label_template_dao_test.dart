import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wameedpos/features/labels/data/local/label_template_dao.dart';
import 'package:wameedpos/features/labels/models/label_template.dart';
import 'package:wameedpos/features/pos_terminal/data/local/pos_offline_database.dart';

void main() {
  late PosOfflineDatabase db;
  late LabelTemplateDao dao;

  setUp(() {
    db = PosOfflineDatabase.forTesting(NativeDatabase.memory());
    dao = LabelTemplateDao(db);
  });

  tearDown(() async {
    await db.close();
  });

  LabelTemplate sample({String? id, String orgId = 'org-1', bool isDefault = false}) {
    return LabelTemplate(
      id: id ?? 't-1',
      organizationId: orgId,
      name: 'Test',
      labelWidthMm: 50,
      labelHeightMm: 30,
      layoutJson: const {'elements': []},
      isPreset: false,
      isDefault: isDefault,
      syncVersion: 1,
    );
  }

  test('upsert and list templates round-trips data', () async {
    await dao.upsertTemplates([sample()]);
    final list = await dao.listTemplates('org-1');
    expect(list, hasLength(1));
    expect(list.first.name, 'Test');
    expect(list.first.labelWidthMm, 50.0);
  });

  test('templates are scoped by organisation', () async {
    await dao.upsertTemplates([
      sample(id: 'a', orgId: 'org-1'),
      sample(id: 'b', orgId: 'org-2'),
    ]);
    expect(await dao.listTemplates('org-1'), hasLength(1));
    expect(await dao.listTemplates('org-2'), hasLength(1));
  });

  test('getDefaultTemplate returns the flagged template only', () async {
    await dao.upsertTemplates([
      sample(id: 'a'),
      sample(id: 'b', isDefault: true),
    ]);
    final def = await dao.getDefaultTemplate('org-1');
    expect(def, isNotNull);
    expect(def!.id, 'b');
  });

  test('pruneOldHistory removes records older than retention window', () async {
    await dao.recordLocalPrint(id: 'p1', productCount: 1, totalLabels: 1);
    await dao.recordLocalPrint(id: 'p2', productCount: 1, totalLabels: 1);
    // Manually age p1 by 100 days.
    await db.customStatement(
      "UPDATE local_label_print_history SET printed_at = ? WHERE id = 'p1'",
      [DateTime.now().subtract(const Duration(days: 100)).millisecondsSinceEpoch ~/ 1000],
    );
    final removed = await dao.pruneOldHistory();
    expect(removed, 1);
  });
}
