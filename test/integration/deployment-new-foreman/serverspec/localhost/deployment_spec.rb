require 'spec_helper'

# Make sure we have some code
describe file("/var/www/certificates.theodi.org/current/config.ru") do
 it { should be_file }
end

# Check we can actually access the thing - we'll get a Rails error due
# to lack of database, but that's OK as we know Rails is running.
# NOPE, THIS WON'T FLY IF WE'RE ATTEMPTING TO MYSQL-AS-A-SERVICE
describe command("curl -H 'Host: certificates.theodi.org' localhost") do
  it { should return_stdout /Error - ODI Open Data Certificate/ }
end
