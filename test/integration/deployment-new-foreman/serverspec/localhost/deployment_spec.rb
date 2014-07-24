require 'spec_helper'

# Make sure we have some code
describe file("/var/www/certificates.theodi.org/current/config.ru") do
 it { should be_file }
end

describe file("/var/www/certificates.theodi.org/current/public/assets/") do
  it { should be_directory }
end

describe command ('mysql -h localhost -u root -pilikerandompasswords certificates -e "show tables"') do
  it { should return_stdout /surveys/i }
end

# Check we can actually access the thing - we'll get a Rails error due
# to lack of database, but that's OK as we know Rails is running.
describe command("curl -H 'Host: certificates.theodi.org' localhost") do
  it { should return_stdout /ODI Open Data Certificate/ }
end

#describe something "it should run the post-deploy tasks"
