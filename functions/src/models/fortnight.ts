export class Fortnight {
    index: number;
    startDate: Date;
    endDate: Date;

    constructor(index: number) {
        this.index = index;
        const baseDate = new Date(2024, 0, 1);
        this.startDate = new Date(baseDate.setDate(baseDate.getDate() + (index - 1) * 14));
        this.endDate = new Date(baseDate.setDate(baseDate.getDate() + 13));


    }

    static fromDate(givenDate: Date): Fortnight {
        const baseStartDate: Date = new Date(2024, 0, 1); // Start date of FN1 is January 1, 2024

        // Calculate the difference in days
        const millisecondsPerDay = 1000 * 60 * 60 * 24;
        const deltaDays = Math.floor((givenDate.getTime() - baseStartDate.getTime()) / millisecondsPerDay);

        // Calculate FN period
        const fnPeriod = Math.floor(deltaDays / 14) + 1;
        return new Fortnight(fnPeriod);
    }

    static fromRange(start: Date, end: Date): Fortnight[] {
        const fortnights: Fortnight[] = [];
        const current = new Date(start);
        while (current <= end) {
            const fortnight = Fortnight.fromDate(current);
            const alreadyAdded = fortnights.some((fn) => fn.index === fortnight.index);
            if (!alreadyAdded) {
                fortnights.push(fortnight);
            }
            current.setDate(current.getDate() + 1);
        }
        return fortnights;
    }
}