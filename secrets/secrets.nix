let
  user1 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMz7v8TolMVBNSrX8r8Lvav2wyGEIWLi8sEWSeVXNLj3";
  users = [user1];

  system1 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGcAShSDx+v1XRMxCqcQyeFuw9yF2JuarbunMQqAUOCE";
  systems = [system1];
  all = users ++ systems;
in {
  "password.age".publicKeys = all;
}
