require 'spec_helper'

# Make sure vhosts have the correct stuff
describe file("/var/www/staging.certificates.theodi.org/shared/config/database.yml") do
  it { should be_file }
  it { should contain 'password: it_is_raining'}
end
