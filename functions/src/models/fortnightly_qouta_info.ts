import { Fortnight } from "./fortnight";

export class FortnightlyQoutaPercentage {
    fortnight: Fortnight;
    qoutaPercentage: number;

    constructor({ fortnight, qoutaPercentage: currentQoutaPercentage }: { fortnight: Fortnight, qoutaPercentage: number }) {
        this.fortnight = fortnight;
        this.qoutaPercentage = currentQoutaPercentage;
    }
}