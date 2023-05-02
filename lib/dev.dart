bool dev = false;

devPrint(String message) {
  if (!dev) return;
  print(message);
}