#
#
#
class java00::packages {
  @package { 
    [
      "wget", 
    ]:
        ensure => present,
    }
}
