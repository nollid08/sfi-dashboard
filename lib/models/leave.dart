import 'package:cloud_firestore/cloud_firestore.dart';

class Leave {
  final String id;
  final String coachUid;
  final DateTime startDate;
  final DateTime endDate;
  final LeaveType type;
  final LeaveStatus status;

  Leave({
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.coachUid,
    LeaveType? type,
    LeaveStatus? status,
  })  : type = type ?? LeaveType.annual,
        status = _calculateStatus(
          startDate: startDate,
          endDate: endDate,
          status: status ?? LeaveStatus.pending,
        );

  static LeaveStatus _calculateStatus(
      {required DateTime startDate,
      required DateTime endDate,
      required LeaveStatus status}) {
    if (status == LeaveStatus.approved) {
      if (endDate.isBefore(DateTime.now())) {
        return LeaveStatus.completed;
      } else if (startDate.isBefore(DateTime.now()) &&
          endDate.isAfter(DateTime.now())) {
        return LeaveStatus.current;
      }
    }
    return status;
  }

  factory Leave.fromQueryDocumentSnapshot(
    QueryDocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();
    return Leave(
      id: doc.id,
      coachUid: data['coachUid'],
      startDate: data['startDate'].toDate(),
      endDate: data['endDate'].toDate(),
      type: LeaveType.values[data['leaveType']],
      status: LeaveStatus.values[data['status']],
    );
  }

  Map<String, dynamic> toFBJson() {
    return {
      'startDate': startDate,
      'endDate': endDate,
      'leaveType': type.index,
      'coachUid': coachUid,
      'status': status.index,
    };
  }
}

enum LeaveType {
  annual,
  notAvailable,
  unpaid,
  other,
}

enum LeaveStatus {
  pending,
  approved,
  rejected,
  completed,
  current,
}
