require 'spec_helper'

# Make sure vhosts have the correct stuff
describe file("/etc/nginx/sites-enabled/certificates.theodi.org.ssl") do
  it { should be_file }

#  its(:content) { should match "upstream open-data-certificate" }
#  its(:content) { should match "server 127.0.0.1:3000;" }
# 
#  its(:content) { should match "listen 81 default;" }
#  its(:content) { should match "server_name certificates.theodi.org;" }
#  its(:content) { should match "try_files $uri @backend;" }
# 
#  its(:content) { should match "location ~ ^/(assets)/" }
#  its(:content) { should match "root /var/www/certificates.theodi.org/current/public/;" }
# 
#  its(:content) { should match "proxy_pass http://open-data-certificate;" }
end

### describe file("/etc/nginx/sites-enabled/certificates.theodi.org") do
###   it { should be_file }
###
###   its(:content) { should match "listen 80;" }
###   its(:content) { should match "server_name certificates.theodi.org;" }
###   its(:content) { should match "rewrite ^/(.*)$ https://certificates.theodi.org/$1 permanent;" }
### end
###
### describe file("/etc/nginx/sites-enabled/certificate.theodi.org") do
###   it { should be_file }
###
###   its(:content) { should match "listen 80;" }
###   its(:content) { should match "server_name certificate.theodi.org;" }
###   its(:content) { should match "rewrite ^/(.*)$ https://certificates.theodi.org/$1 permanent;" }
### end
###
### describe file("/etc/nginx/sites-enabled/certificate.theodi.org") do
###   it { should be_file }
###
###   its(:content) { should match "listen 81;" }
###   its(:content) { should match "server_name certificate.theodi.org;" }
###   its(:content) { should match "rewrite ^/(.*)$ https://certificates.theodi.org/$1 permanent;" }
### end
