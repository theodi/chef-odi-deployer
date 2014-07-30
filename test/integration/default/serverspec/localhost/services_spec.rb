require 'spec_helper'

# Make sure nginx is running
describe service("nginx") do
 it { should be_running }
end

# Make sure foreman job is running
describe service("open-data-certificate-thin-1") do
  it { should be_running }
end

describe service("open-data-certificate-delayed_job-1") do
  it { should be_running }
end
