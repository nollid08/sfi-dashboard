export interface Leave {
    id: string;
    coachUid: string;
    startDate: Date;
    endDate: Date;
    type: LeaveType;
    status: LeaveStatus;
}

export enum LeaveType {
    annual,
    sick,
    unpaid,
    other,
}

export enum LeaveStatus {
    pending,
    approved,
    rejected,
    completed,
    current,
}