require 'spec_helper'

dependencies = [
  "build-essential",
  "git",
  "curl",
  "libxml2-dev",
  "libxslt1-dev",
  "libcurl4-openssl-dev",
  "libmysqlclient-dev",
  "nodejs",
  "nginx"
]

dependencies.each do |p|
  describe package p do
    it { should be_installed }
  end
end
