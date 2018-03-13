require 'spec_helper'
require 'ec2_helper'

describe vpc('my-vpc') do
  it { should exist }
  its(:cidr_block) { should eq '10.0.0.0/16' }
end

#Below fails when an instace with same name is terminated:
# https://github.com/k1LoW/awspec/issues/155
#describe ec2('example') do
#  it { should exist }
#  it { should be_running }
#  it { should belong_to_vpc('my-vpc') }
#end

describe ec2_instances_named('example') do
  its(:size) { should eq 1 }
  #it { should have(1).items } # This fails with: undefined method `have' for #<RSpec::ExampleGroups::Ec2I05a41c133451f970d:0x007f99a8b72750>
  it { is_expected.to all(exist) }
  it { is_expected.to all(be_running) }
end
