import type { NextConfig } from 'next';

const nextConfig: NextConfig = {
  transpilePackages: ['@birdhaus/ui'],
  // Force cache invalidation - Jan 2026
  generateBuildId: async () => {
    return 'build-' + Date.now();
  },
};

export default nextConfig;
