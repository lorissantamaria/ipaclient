require 'spec_helper'
describe 'ipaclient' do

  context 'with defaults for all parameters' do
    it { should contain_class('ipaclient') }
  end
end
