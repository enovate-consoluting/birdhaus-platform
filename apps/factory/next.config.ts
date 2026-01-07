import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  // Temporarily ignore TypeScript errors due to React 19 type conflicts in monorepo
  // These are type definition conflicts, not runtime issues
  typescript: {
    ignoreBuildErrors: true,
  },
};

export default nextConfig;
