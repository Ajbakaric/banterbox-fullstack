const { TextEncoder, TextDecoder } = require('util');

// Add polyfills for Node.js
global.TextEncoder = global.TextEncoder || TextEncoder;
global.TextDecoder = global.TextDecoder || TextDecoder;

// ✅ Extend Jest's expect with jest-dom matchers
const matchers = require('@testing-library/jest-dom/matchers');
expect.extend(matchers);
