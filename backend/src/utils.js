export function checkExists(obj) {
  if (typeof obj !== "object") {
    throw new Error('Error from checkExists: No entry found');
  }
  return obj;
}