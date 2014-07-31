name             'odi-deployer'
maintainer       'The Open Data Institute'
maintainer_email 'tech@theodi.org'
license          'MIT'
description      'New Improved Deployment Mechanism'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.5.0'

depends "nginx"
depends "git"
depends "nodejs"
depends 'odi-ruby'
depends 'envbuilder'
depends 'apt'
