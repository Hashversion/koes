"use client";

export const Button = ({ children, className }: React.ComponentProps<"button">) => {
  return <button className={className}>{children}</button>;
};
