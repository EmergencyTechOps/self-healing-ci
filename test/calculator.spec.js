const assert = require('assert');
const { add } = require('../src/index');

describe('Calculator', function () {
  it('should return correct addition', function () {
    const result = add(6, 7);
    assert.strictEqual(result, 42); // Intentional wrong: real is 13
  });
});
