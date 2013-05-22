require 'spec_helper'

describe 'Contribute Page' do

  subject { page }

  before { visit contribute_path }

  it { should have_title 'Nimbus | Contribute' }
  it { should have_selector 'nav' }
  it { should have_selector 'footer' }
  it { should have_content 'GitHub' }

end
