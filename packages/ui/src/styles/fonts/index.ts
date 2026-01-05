import localFont from "next/font/local";

const geistSans = localFont({
  src: "./GeistVF.woff",
  variable: "--font-geist-sans",
});
const geistMono = localFont({
  src: "./GeistMonoVF.woff",
  variable: "--font-geist-mono",
});

const fonts = [geistSans, geistMono];
const fontsVariable = fonts.map((font) => font.variable).join(" ");

export { fontsVariable, geistMono, geistSans };
