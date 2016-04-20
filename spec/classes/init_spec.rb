require 'spec_helper'
describe 'freeipaclient' do

  context 'with defaults for all parameters' do
    it { should contain_class('freeipaclient') }
  end
end
