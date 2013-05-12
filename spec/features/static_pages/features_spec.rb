require 'spec_helper'

describe 'Features Page' do

  subject { page }

  before { visit features_path }

  it { should have_title 'Nimbus | Features' }
  it { should have_selector 'nav' }
  it { should have_selector 'footer' }

end
