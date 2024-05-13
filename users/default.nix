{ config, lib, ... }: {
  imports = [ ./root ./wednesday ];

  users.mutableUsers = false;
}
