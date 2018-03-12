require 'spec_helper'

describe ec2('example') do
  it { should be_running }
end