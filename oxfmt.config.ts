import { defineConfig } from "oxfmt";

export default defineConfig({
  semi: true,
  printWidth: 110,
  singleQuote: false,
  trailingComma: "es5",
  bracketSpacing: true,
  arrowParens: "always",
  jsxSingleQuote: false,
  importOrder: [
    "^(react/(.*)$)|^(react$)",
    "^(next/(.*)$)|^(next$)",
    "<THIRD_PARTY_MODULES>",
    "^@repo/(.*)$",
    "<TYPES>",
    "<TYPES>^[.]",
    "^@/lib/(.*)$",
    "^@/components/(.*)$",
    "^@/app/(.*)$",
    "^[.]",
  ],
  sortTailwindcss: {
    functions: ["clsx", "cn"],
  },
  sortPackageJson: true,
  ignorePatterns: [],
});
