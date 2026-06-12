import { useState } from "react";

const STORAGE_KEY = "aivi_daily_goal";
const DEFAULT_GOAL = 400;

export function useDailyGoal() {
  const [goal, setGoalState] = useState<number>(() => {
    const stored = localStorage.getItem(STORAGE_KEY);
    return stored ? Math.max(1, Number(stored)) : DEFAULT_GOAL;
  });

  const setGoal = (value: number) => {
    const safe = Math.max(1, Math.round(value));
    localStorage.setItem(STORAGE_KEY, String(safe));
    setGoalState(safe);
  };

  return { goal, setGoal };
}
