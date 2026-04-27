import { defineConfig } from 'vitest/config';
import { resolve } from 'path';
export default defineConfig({
    test: {
        globals: true,
        environment: 'node',
        include: ['apps/api/src/**/*.test.ts'],
        // Use the standalone tsconfig to avoid broken extends chain
        // from apps/api/src/tsconfig.json -> ../../tsconfig.json
        alias: {
            '@nexus/shared': resolve(__dirname, 'packages/shared/src/index.ts'),
        },
    },
});
