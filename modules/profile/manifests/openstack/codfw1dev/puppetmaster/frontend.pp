class profile::openstack::codfw1dev::puppetmaster::frontend(
    Array[Stdlib::Fqdn] $designate_hosts = lookup('profile::openstack::codfw1dev::designate_hosts'),
    $puppetmasters = hiera('profile::openstack::codfw1dev::puppetmaster::servers'),
    $puppetmaster_ca = hiera('profile::openstack::codfw1dev::puppetmaster::ca'),
    $puppetmaster_hostname = hiera('profile::openstack::codfw1dev::puppetmaster_hostname'),
    $puppetmaster_webhostname = hiera('profile::openstack::codfw1dev::puppetmaster::web_hostname'),
    $encapi_db_host = hiera('profile::openstack::codfw1dev::puppetmaster::encapi::db_host'),
    $encapi_db_name = hiera('profile::openstack::codfw1dev::puppetmaster::encapi::db_name'),
    $encapi_db_user = hiera('profile::openstack::codfw1dev::puppetmaster::encapi::db_user'),
    $encapi_db_pass = hiera('profile::openstack::codfw1dev::puppetmaster::encapi::db_pass'),
    $encapi_statsd_prefix = hiera('profile::openstack::codfw1dev::puppetmaster::encapi::statsd_prefix'),
    $statsd_host = hiera('profile::openstack::codfw1dev::statsd_host'),
    $labweb_hosts = hiera('profile::openstack::codfw1dev::labweb_hosts'),
    $cert_secret_path = hiera('profile::openstack::codfw1dev::puppetmaster::cert_secret_path'),
    $nova_controller = hiera('profile::openstack::codfw1dev::nova_controller'),
    $nova_controller_standby = hiera('profile::openstack::codfw1dev::nova_controller'),
    ) {

    require ::profile::openstack::codfw1dev::clientpackages
    class {'::profile::openstack::base::puppetmaster::frontend':
        designate_hosts          => $designate_hosts,
        puppetmasters            => $puppetmasters,
        puppetmaster_ca          => $puppetmaster_ca,
        puppetmaster_hostname    => $puppetmaster_hostname,
        puppetmaster_webhostname => $puppetmaster_webhostname,
        encapi_db_host           => $encapi_db_host,
        encapi_db_name           => $encapi_db_name,
        encapi_db_user           => $encapi_db_user,
        encapi_db_pass           => $encapi_db_pass,
        encapi_statsd_prefix     => $encapi_statsd_prefix,
        statsd_host              => $statsd_host,
        labweb_hosts             => $labweb_hosts,
        cert_secret_path         => $cert_secret_path,
        nova_controller          => $nova_controller,
        nova_controller_standby  => $nova_controller,
    }
}
