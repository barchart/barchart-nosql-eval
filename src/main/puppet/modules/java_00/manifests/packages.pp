#
#
#
class java_00::packages {
  @package { 
    [
      "wget", 
    ]:
        ensure => present,
    }
}
