export function checkExists(obj) {
  if (typeof obj !== "object") {
    throw new Error('No entry found');
  }
  return obj;
}