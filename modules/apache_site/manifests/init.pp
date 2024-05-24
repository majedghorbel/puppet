class apache_site {
  # Ensure the git package is installed
  package { 'git':
    ensure => installed,
  }

  # Ensure the apache2 package is installed and the service is running
  package { 'apache2':
    ensure => installed,
  }

  service { 'apache2':
    ensure     => running,
    enable     => true,
    subscribe  => File['/var/www/html/site'],
  }

  # Clone the HTML site from GitHub
  exec { 'clone_site':
    command => '/usr/bin/git clone https://github.com/majedghorbel/monsite.git /var/www/html/site',
    require => Package['git'],
  }

  # Ensure the /var/www/html/site directory exists and has the right permissions
  ensure_resource('file',"/var/www/html/site", { 
    ensure  => directory,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
  })

  # Ensure the Apache configuration is correct
  ensure_resource('file',"/etc/apache2/sites-enabled/site.conf',{
    content => template('apache_site/site.conf.erb'),
    notify  => Service['apache2'],
  })
}

