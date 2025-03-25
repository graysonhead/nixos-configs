{pkgs, ...}:

{
      # /tmp on tmpfs
  boot.tmp = {
    useTmpfs = true;
    tmpfsSize = "90%";
  };
}