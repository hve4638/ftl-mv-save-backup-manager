bool dev = false;

setDev(bool enabled) {
  dev = enabled;
}

devPrint(String message) {
  if (!dev) return;
  print(message);
}