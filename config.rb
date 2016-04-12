class ConfigSingleton
  STATE = { :PROCESSING => 'process', :COMPLETE => 'result'}

  MASTER_INI = 'master.ini'
  SLAVE_INI = 'slave.ini'

  DATA_TYPE = {:BINARY => 1, :STRING => 2}
end