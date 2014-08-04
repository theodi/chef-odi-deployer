require 'spec_helper'

# Make sure we have environment correct
describe file("/var/www/certificates.theodi.org/current/.env") do
 its(:content) { should match /SUCH: test/ }
end

describe file("/var/www/certificates.theodi.org/current/.env.production") do
  it { should be_file }
  it { should be_owned_by 'certificates' }
  its(:content) { should match "MEMCACHED_HOSTS: 127.0.0.1"}
end

describe file("/var/www/certificates.theodi.org/current/database.yml") do
  its(:content) { should match /host: localhost/ }
  its(:content) { should match /database: certificates/ }
  its(:content) { should match /username: certificates/ }
  its(:content) { should match /password: how_to_security/ }
end

describe file("/etc/init/open-data-certificate-thin-1.conf") do
  its(:content) { should match /SUCH=test/ }
  its(:content) { should match /PORT=3000/ }
  its(:content) { should match /bundle exec thin start/ }
end
