"use client";

import { cn } from "@repo/ui/lib/utils";

export const Button = ({ children, className }: React.ComponentProps<"button">) => {
  return (
    <button
      className={cn(
        "bg-neutral-300 text-neutral-950",
        "rounded-full px-2.5 py-1",
        "hover:bg-neutral-400",
        "duration-300",
        className
      )}
    >
      {children}
    </button>
  );
};
