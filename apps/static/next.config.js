/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  reactCompiler: true,
  poweredByHeader: false,
  typedRoutes: true,
  output: "export",
  allowedDevOrigins: ["static.koes.localhost", "*.static.koes.localhost"],
  images: {
    loader: "custom",
    loaderFile: "./image-loader.ts",
    // Limit max image size to 1200px (displayed size is ~1248px)
    // Default: [640, 750, 828, 1080, 1200, 1920, 2048, 3840]
    deviceSizes: [640, 750, 828, 1080, 1200],
    qualities: [50, 80],
    remotePatterns: [],
  },
};

export default nextConfig;
