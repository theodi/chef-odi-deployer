name             'odi-deployer'
maintainer       'The Open Data Institute'
maintainer_email 'tech@theodi.org'
license          'MIT'
description      'New Improved Deployment Mechanism'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.5.6'

depends 'odi-base'
depends "nginx"
depends "git"
depends "nodejs"
depends 'odi-ruby'
depends 'apt'
