require 'spec_helper'

# Make sure our public keys have been deployed
describe file("/home/odi/.ssh/authorized_keys") do
  it { should be_file }
end
