{ config, pkgs, ... }:
{
  # Set the root password
  users.users.root.initialPassword = "1234";
}