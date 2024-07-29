import { find_bookings_available_coaches_function } from "./functions/find_bookings_available_coaches";
import { find_sessions_available_coaches_function } from "./functions/find_sessions_available_coaches";

const { initializeApp, } = require('firebase-admin/app');

initializeApp();

export const find_bookings_available_coaches = find_bookings_available_coaches_function;
export const find_sessions_available_coaches = find_sessions_available_coaches_function;

