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

describe file('/var/www/certificates.theodi.org/shared/log/production.log') do
  it { should contain ('Creating scope :with_includes. Overwriting existing method SurveySection.with_includes.') }
end

# Make sure vhosts have correct static asset configuration
describe file("/etc/nginx/sites-enabled/certificates.theodi.org") do
  it { should be_file }
  its(:content) { should match /location \~ \^\/\(assets\)\// }
  its(:content) { should match /add_header Access-Control-Allow-Origin "\*";/ }
end
