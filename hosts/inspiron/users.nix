let
  orangc = {
    username = "orangc";
    sudo = true;
  };
in
{
  inherit orangc;
  sysadmin = orangc;
  lion = {
    username = "lion";
    sudo = false;
  };
}
