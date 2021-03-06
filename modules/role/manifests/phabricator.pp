# phabricator instance
#
# filtertags: labs-project-deployment-prep labs-project-devtools
class role::phabricator {

    system::role { 'phabricator':
        description => 'Phabricator (Main) Server'
    }

    include ::profile::standard
    include ::profile::base::firewall
    include ::profile::backup::host
    include ::profile::phabricator::main
    include ::profile::phabricator::httpd
    include ::profile::phabricator::monitoring
    include ::profile::prometheus::apache_exporter
    include ::profile::waf::apache2::administrative
    include ::profile::tlsproxy::envoy # TLS termination
    include ::rsync::server # copy repo data between servers

    if $::realm == 'production' {
        include ::lvs::realserver
    }
}
