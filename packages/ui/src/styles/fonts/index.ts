import localFont from "next/font/local";

const geistSans = localFont({
  src: "./GeistVF.woff",
  variable: "--font-geist-sans",
});

const geistMono = localFont({
  src: "./GeistMonoVF.woff",
  variable: "--font-geist-mono",
});

const gehaks = localFont({
  src: "./GEHAKS.woff2",
  variable: "--font-gehaks-sans",
});

const fonts = [gehaks, geistSans, geistMono];
const fontsVariable = fonts.map((font) => font.variable).join(" ");

export { fontsVariable, gehaks, geistMono, geistSans };
