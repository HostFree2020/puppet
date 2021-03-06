# https://design.wikimedia.org (T185282)
class profile::microsites::design(
  $server_name = lookup('profile::microsites::design::server_name'),
  $server_admin = lookup('profile::microsites::design::server_admin'),
) {

    httpd::site { 'design.wikimedia.org':
        content => template('profile/design/design.wikimedia.org-httpd.erb'),
    }

    ensure_resource('file', '/srv/org', {'ensure' => 'directory' })
    ensure_resource('file', '/srv/org/wikimedia', {'ensure' => 'directory' })
    ensure_resource('file', '/srv/org/wikimedia/design', {'ensure' => 'directory' })
    ensure_resource('file', '/srv/org/wikimedia/design-strategy', {'ensure' => 'directory' })

    git::clone { 'design/landing-page':
        ensure    => 'latest',
        source    => 'gerrit',
        directory => '/srv/org/wikimedia/design',
        branch    => 'master',
    }

    git::clone { 'design/strategy':
        ensure    => 'latest',
        source    => 'gerrit',
        directory => '/srv/org/wikimedia/design-strategy',
        branch    => 'master',
    }

    scap::target { 'design/style-guide':
        deploy_user => 'deploy-design',
    }

    file { '/srv/org/wikimedia/design-style-guide':
        ensure  => 'link',
        target  => '/srv/deployment/design/style-guide',
        require => Scap::Target['design/style-guide'],
    }

}

