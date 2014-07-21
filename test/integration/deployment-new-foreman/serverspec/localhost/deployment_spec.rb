require 'spec_helper'

# Make sure we have some code
describe file("/var/www/certificates.theodi.org/current/config.ru") do
 it { should be_file }
end

### # Check we can actually access the thing - we'll get a Rails error due
### # to lack of database, but that's OK as we know Rails is running.
### describe command("curl -H 'Host: certificates.theodi.org' localhost") do
###  it { should return_stdout /We\'re sorry, but something went wrong \(500\)/ }
### end
