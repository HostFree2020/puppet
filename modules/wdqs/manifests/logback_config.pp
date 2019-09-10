define wdqs::logback_config (
    String $pattern,
    String $logstash_host,
    Stdlib::Unixpath $log_dir,
    Stdlib::Port $logstash_port = 11514,
    Stdlib::Port $logstash_logback_port = 11514,
    Enum['logstash-direct', 'syslog'] $logstash_transport = 'logstash-direct',
    Boolean $evaluators = false,
    Boolean $sparql = false,
) {
    file { "/etc/wdqs/logback-${title}.xml":
        ensure  => present,
        content => template('wdqs/logback.xml.erb'),
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
    }
}
