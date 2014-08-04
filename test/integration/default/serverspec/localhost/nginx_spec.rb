require 'spec_helper'

# Make sure vhosts have the correct stuff
describe file("/etc/nginx/sites-enabled/certificates.theodi.org") do
  its(:content) { should match "upstream open-data-certificate" }
  its(:content) { should match "server 127.0.0.1:3000;" }

  its(:content) { should match "listen 80 default;" }
  its(:content) { should match "server_name certificates.theodi.org;" }
  its(:content) { should match /try_files \$uri @backend;/ }

  its(:content) { should match /location ~ \^\/\(assets\)\// }
  its(:content) { should match "root /var/www/certificates.theodi.org/current/public/;" }

  its(:content) { should match "proxy_pass http://open-data-certificate;" }
end

describe file("/etc/nginx/sites-enabled/certificates.theodi.org") do
  it { should contain("listen 80;").after('certificate.theodi.org') }
  it { should contain("server_name certificate.theodi.org;").after('certificate.theodi.org') }
  it { should contain("rewrite ^/(.*)$ http://certificates.theodi.org/$1 permanent;").after('certificate.theodi.org') }
end
