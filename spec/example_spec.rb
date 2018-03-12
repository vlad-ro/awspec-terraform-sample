require 'spec_helper'

describe vpc('my-vpc') do
  it { should exist }
  its(:cidr_block) { should eq '10.0.0.0/16' }
end

describe ec2('example') do
  it { should exist }
  it { should be_running }
  it { should belong_to_vpc('my-vpc') }
end