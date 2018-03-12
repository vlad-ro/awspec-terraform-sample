require 'spec_helper'

describe ec2('example') do
  it { should exist }
  it { should be_running }
end