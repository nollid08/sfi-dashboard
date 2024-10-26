class HalfTerm {
  id: string;
  name: string;
  startDate: Date;
  endDate: Date;
  excludedDates: Date[];
  beginSessionCutoff: Date;

  constructor({
    id,
    name,
    startDate,
    endDate,
    excludedDates,
    beginSessionCutoff,
  }: {
    id: string;
    name: string;
    startDate: Date;
    endDate: Date;
    excludedDates: Date[];
    beginSessionCutoff: Date;
  }) {
    this.id = id;
    this.name = name;
    this.startDate = new Date(startDate);
    this.endDate = new Date(endDate);
    this.excludedDates = excludedDates;
    this.beginSessionCutoff = beginSessionCutoff;
  }
}
