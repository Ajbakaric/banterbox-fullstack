// react/jest.config.cjs
module.exports = {
  testEnvironment: 'jsdom',
  setupFilesAfterEnv: ['./jest.setup.cjs'],
  transform: {
    '^.+\\.jsx?$': 'babel-jest',  // ✅ Add this line
  },
  moduleFileExtensions: ['js', 'jsx'],  // helpful for React files
};
