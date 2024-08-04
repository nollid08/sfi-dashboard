import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard/models/coach.dart';
import 'package:dashboard/models/leave.dart';

class CoachLinkedLeave extends Leave {
  final Coach coach;

  CoachLinkedLeave({
    required super.id,
    required super.startDate,
    required super.endDate,
    required super.coachUid,
    required this.coach,
    super.status,
    super.type,
  });

  static CoachLinkedLeave fromQueryDocumentSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> doc, Coach coach) {
    final data = doc.data();
    return CoachLinkedLeave(
      id: doc.id,
      coachUid: data['coachUid'],
      startDate: data['startDate'].toDate(),
      endDate: data['endDate'].toDate(),
      type: LeaveType.values[data['leaveType']],
      status: LeaveStatus.values[data['status']],
      coach: coach,
    );
  }

  @override
  Map<String, dynamic> toFBJson() {
    return {
      'startDate': startDate,
      'endDate': endDate,
      'leaveType': type.index,
      'coachUid': coachUid,
      'status': status.index,
    };
  }

  CoachLinkedLeave copyWith({
    String? id,
    DateTime? startDate,
    DateTime? endDate,
    String? coachUid,
    Coach? coach,
    LeaveStatus? status,
    LeaveType? type,
  }) {
    return CoachLinkedLeave(
      id: id ?? this.id,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      coachUid: coachUid ?? this.coachUid,
      coach: coach ?? this.coach,
      status: status ?? this.status,
      type: type ?? this.type,
    );
  }
}
