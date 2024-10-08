// Author: Giovanni Rasera

function measureTime(target, key, descriptor) {
  const originalMethod = descriptor.value;
  descriptor.value = function (...args) {
    const start = performance.now();
    const result = originalMethod.apply(this, args);
    const end = performance.now();
    console.log(`Execution time for ${key}: ${end - start} milliseconds`);
    return result;
  };
  return descriptor;
}