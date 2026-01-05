import { domAnimation, LazyMotion } from "motion/react";
import * as m from "motion/react-m";
import { fontsVariable } from "@repo/ui/styles/fonts";
import type { Metadata, Viewport } from "next";
import "./styles.css";

export const metadata: Metadata = {
  title: {
    template: "%s :: Koes",
    default: "Koes",
  },
};

export const viewport: Viewport = {
  themeColor: [
    { media: "(prefers-color-scheme: light)", color: "white" },
    { media: "(prefers-color-scheme: dark)", color: "black" },
  ],
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en" className={fontsVariable}>
      <LazyMotion features={domAnimation}>
        <m.body
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          transition={{ duration: 1.23, ease: [0.455, 0.03, 0.515, 0.955] }}
          className="font-geist-sans antialiased"
        >
          {children}
        </m.body>
      </LazyMotion>
    </html>
  );
}
