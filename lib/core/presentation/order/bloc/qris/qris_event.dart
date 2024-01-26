part of 'qris_bloc.dart';

@freezed
class QrisEvent with _$QrisEvent {
  const factory QrisEvent.started() = _Started;
  //generate qris code
  const factory QrisEvent.generateQRCode(String orderId, int grossAmount) = _GenerateQRCode;
  //checkpayment status
  const factory QrisEvent.checkPaymentStatus(String orderId) = _CheckPaymentStatus;
}