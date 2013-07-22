#
#
#
class cassandra_00::apply () {

  anchor { 'start': }
  
  include params
  include validate
  include install
  include config
  
  include service

  anchor { 'finish': }

  Anchor['start'] -> 
    
  Class['params'] -> 
  Class['validate'] -> 
  Class['install'] -> 
  Class['config']
     
  ~>
   
  Class['service'] ->
    
  Anchor['finish']
      
}
