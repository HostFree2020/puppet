# == Class profile::statistics::private
#
class profile::statistics::private(
    $labstore_hosts      = hiera('labstore_hosts'),
    $statsd_host         = hiera('statsd'),
    $graphite_host       = hiera('profile::statistics::private::graphite_host'),
    $wmde_secrets        = hiera('wmde_secrets'),
    $use_kerberos        = hiera('profile::statistics::private::use_kerberos', false),
) {

    include ::profile::statistics::base

    class {'::deployment::umask_wikidev': }

    # Directory to host datasets that are generated locally and synced over
    # via rsync fetch jobs running on the dumps distribution servers
    file {'/srv/dumps':
        ensure => 'directory',
        mode   => '0775',
        owner  => 'stats',
        group  => 'wikidev',
    }

    # Include the MySQL research password at
    # /etc/mysql/conf.d/analytics-research-client.cnf
    # and only readable by users in the
    # analytics-privatedata-users group.
    statistics::mysql_credentials { 'analytics-research':
        group => 'analytics-privatedata-users',
    }

    # The eventlogging codebase is useful for scripting
    # EventLogging consumers.  Install this but don't run any daemons.
    class { '::eventlogging': }

    # EventLogging Analytics data logs are not private, but they
    # are rsynced here for convenience and backup redundancy.
    class { '::statistics::rsync::eventlogging': }

    # rsync mediawiki logs from logging hosts
    class { '::statistics::rsync::mediawiki': }

    # Allowing statistics nodes (mostly clouddb hosts in this case)
    # to push nginx access logs to a specific /srv path. We usually
    # allow only pull based rsyncs, but after T211330 we needed a way
    # to unbreak that use case. This rsync might be removed in the future.
    rsync::server::module { 'dumps-webrequest':
        path        => '/srv/log/webrequest/archive/dumps.wikimedia.org',
        read_only   => 'no',
        hosts_allow => $labstore_hosts,
        auto_ferm   => true,
    }

    # Class to save old versions of the geoip MaxMind database, which are useful
    # for historical geocoding.
    if !defined(File['/srv/geoip']) {
        file { '/srv/geoip':
            ensure => directory,
            owner  => 'root',
            group  => 'wikidev',
        }
    }
    class { '::geoip::data::archive':
        archive_dir  => '/srv/geoip/archive',
        use_kerberos => $use_kerberos,
        require      => File['/srv/geoip'],
    }

    # Discovery team statistics scripts and cron jobs
    class { '::statistics::discovery':
        use_kerberos => $use_kerberos
    }

    # WMDE releated statistics & analytics scripts.
    class { '::statistics::wmde':
        statsd_host   => $statsd_host,
        graphite_host => $graphite_host,
        wmde_secrets  => $wmde_secrets,
    }
}
