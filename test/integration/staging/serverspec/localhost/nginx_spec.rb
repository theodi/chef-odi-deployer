require 'spec_helper'

# Make sure vhosts have the correct stuff
describe file("/etc/nginx/sites-enabled/staging.certificates.theodi.org") do
  its(:content) { should match "upstream open-data-certificate" }
  its(:content) { should match "server 127.0.0.1:3000;" }

  its(:content) { should match "listen 80 default;" }
  its(:content) { should match "server_name staging.certificates.theodi.org;" }
  its(:content) { should match /try_files \$uri @backend;/ }

  its(:content) { should match /location ~ \^\/\(assets\)\// }
  its(:content) { should match "root /var/www/staging.certificates.theodi.org/current/public/;" }

  its(:content) { should match "proxy_pass http://open-data-certificate;" }
end
