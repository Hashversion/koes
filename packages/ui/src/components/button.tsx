"use client";

import { cn } from "@repo/ui/lib/utils";

export const Button = ({ children, className }: React.ComponentProps<"button">) => {
  return <button className={cn("bg-neutral-300 text-neutral-950", className)}>{children}</button>;
};
