import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  output: 'standalone',
  typescript: {
    // Temporarily ignore type errors during build if needed
    ignoreBuildErrors: process.env.NEXT_BUILD_SKIP_TYPE_CHECK === 'true',
  },
  eslint: {
    // Ignore ESLint errors during build if needed
    ignoreDuringBuilds: process.env.NEXT_BUILD_SKIP_TYPE_CHECK === 'true',
  },
  /* config options here */
};

export default nextConfig;
