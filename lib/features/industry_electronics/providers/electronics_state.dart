import 'package:thawani_pos/features/industry_electronics/models/device_imei_record.dart';
import 'package:thawani_pos/features/industry_electronics/models/repair_job.dart';
import 'package:thawani_pos/features/industry_electronics/models/trade_in_record.dart';

sealed class ElectronicsState {
  const ElectronicsState();
}

class ElectronicsInitial extends ElectronicsState {
  const ElectronicsInitial();
}

class ElectronicsLoading extends ElectronicsState {
  const ElectronicsLoading();
}

class ElectronicsLoaded extends ElectronicsState {
  final List<DeviceImeiRecord> imeiRecords;
  final List<RepairJob> repairJobs;
  final List<TradeInRecord> tradeIns;

  const ElectronicsLoaded({required this.imeiRecords, required this.repairJobs, required this.tradeIns});

  ElectronicsLoaded copyWith({List<DeviceImeiRecord>? imeiRecords, List<RepairJob>? repairJobs, List<TradeInRecord>? tradeIns}) =>
      ElectronicsLoaded(
        imeiRecords: imeiRecords ?? this.imeiRecords,
        repairJobs: repairJobs ?? this.repairJobs,
        tradeIns: tradeIns ?? this.tradeIns,
      );
}

class ElectronicsError extends ElectronicsState {
  final String message;
  const ElectronicsError({required this.message});
}
