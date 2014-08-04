require 'spec_helper'

describe user("certificates") do
  it { should exist }
end

describe file("/etc/sudoers.d/certificates") do
  it { should be_file }
  its(:content) { should match "certificates ALL=NOPASSWD:ALL" }
  it { should be_mode "440" }
end

describe file("/etc/sudoers") do
  its(:content) { should match "#includedir /etc/sudoers.d" }
end

describe command("su - certificates -c 'ruby -v'") do
  it { should return_stdout /1.9.3/ }
end
