class profile::idp::client::httpd (
    String[1]                     $acme_chief_cert  = lookup('profile::idp::client::httpd::acme_chief_cert'),
    String[1]                     $vhost_content    = lookup('profile::idp::client::httpd::vhost_content'),
    Stdlib::Host                  $virtual_host     = lookup('profile::idp::client::httpd::virtual_host'),
    Stdlib::Unixpath              $document_root    = lookup('profile::idp::client::httpd::document_root'),
    Stdlib::Unixpath              $cookie_path      = lookup('profile::idp::client::httpd::cookie_path'),
    Stdlib::Unixpath              $certificate_path = lookup('profile::idp::client::httpd::certificate_path'),
    Hash[String, Stdlib::HTTPUrl] $apereo_cas       = lookup('profile::idp::client::httpd::apereo_cas'),
    String[1]                     $authn_header     = lookup('profile::idp::client::httpd::authn_header'),
    String[1]                     $attribute_prefix = lookup('profile::idp::client::httpd::attribute_prefix'),
    Boolean                       $debug            = lookup('profile::idp::client::httpd::debug'),
    String[1]                     $apache_owner     = lookup('profile::idp::client::httpd::apache_owner'),
    String[1]                     $apache_group     = lookup('profile::idp::client::httpd::apache_group'),
    Optional[Array[String[1]]]    $required_groups  = lookup('profile::idp::client::httpd::required_groups'),
) {
    ensure_packages(['libapache2-mod-auth-cas'])

    $_cookie_path = $cookie_path[-1] ? {
        '/'     => $cookie_path,
        default => "${cookie_path}/",
    }
    $ssl_settings = ssl_ciphersuite('apache', 'strong', true)
    $cas_settings = {
        'CASVersion'         => 2,
        'CASCertificatePath' => $certificate_path,
        'CASCookiePath'      => $_cookie_path,
        'CASLoginURL'        => $apereo_cas['login_url'],
        'CASValidateURL'     => $apereo_cas['validate_url'],
        'CASAttributePrefix' => $attribute_prefix,
        'CASDebug'           => $debug ? { true => 'On', default => 'Off' },
    }
    $cas_base_auth = {
        'AuthType'       => 'CAS',
        'CASAuthNHeader' => $authn_header,
    }
    $cas_auth_require = $required_groups.empty? {
        true    => ['valid-user' ],
        default => $required_groups.map |$group| { "cas-attribute memberOf:${group}" },
    }
    $cas_auth_settings = merge($cas_base_auth, {'Require' => $cas_auth_require})

    acme_chief::cert { $acme_chief_cert:
        puppet_svc => 'apache2',
    }

    httpd::mod_conf{'auth_cas':}
    file{$cookie_path:
        ensure => directory,
        owner  => $apache_owner,
        group  => $apache_group,
    }
    httpd::site {$virtual_host:
        content  => template($vhost_content),
        priority => 99,
    }
}


