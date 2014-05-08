require 'spec_helper'

# Make sure nginx is running
describe service("nginx") do
  it { should be_running }
end

# Make sure vhosts have the correct stuff
describe file("/etc/nginx/sites-enabled/office-calendar.theodi.org") do
  it { should be_file }
  its(:content) { should match "server_name office-calendar.theodi.org;" }
  its(:content) { should match "proxy_pass http://office-calendar;" }
end

# Make sure we have some code
describe file("/var/www/office-calendar.theodi.org/current/config.ru") do
  it { should be_file }
end

# Make sure we have environment correctly
describe file("/var/www/office-calendar.theodi.org/current/.env") do
  its(:content) { should match /SUCH: test/ }
end

describe file("/etc/init/office-calendar-thin-1.conf") do
  its(:content) { should match /SUCH=test/ }
  its(:content) { should match /PORT=3000/ }
  its(:content) { should match /bundle exec thin start/ }
end

# Make sure foreman job is running
describe service("office-calendar-thin-1") do
  it { should be_running }
end

# Check we can actually access the thing - we'll get a Rails error due
# to lack of database, but that's OK as we know Rails is running.
describe command("curl -H 'Host: office-calendar.theodi.org' localhost") do
  it { should return_stdout /We\'re sorry, but something went wrong \(500\)/ }
end
