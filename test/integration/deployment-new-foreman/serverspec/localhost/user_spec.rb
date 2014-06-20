require 'spec_helper'

describe user("certificate") do
  it { should exist }
end

describe file("/etc/sudoers.d/certificate") do
  it { should be_file }
  its(:content) { should match "certificate ALL=NOPASSWD:ALL" }
  it { should be_mode "440" }
end

describe file("/etc/sudoers") do
  its(:content) { should match "#includedir /etc/sudoers.d" }
end

describe command("su - certificate -c 'ruby -v'") do
  it { should return_stdout /1.9.3/ }
end
