require 'spec_helper'

describe 'Static Pages' do

  subject { page }

  describe 'Home Page' do

    before { visit root_path }

    it { should have_title 'Nimbus' }
    it { should have_selector 'nav' }
    it { should have_selector 'footer' }
    it { should have_selector 'h1', text: 'Welcome to Nimbus' }

  end

  describe 'Features Page' do

    before { visit features_path }

    it { should have_title 'Nimbus | Features' }
    it { should have_selector 'nav' }
    it { should have_selector 'footer' }

  end

  describe 'Contribute Page' do

    before { visit contribute_path }

    it { should have_title 'Nimbus | Contribute' }
    it { should have_selector 'nav' }
    it { should have_selector 'footer' }
    it { should have_content 'Github' }

  end

  escribe 'About Page' do

    before { visit about_path }

    it { should have_title 'Nimbus | About Us' }
    it { should have_selector 'nav' }
    it { should have_selector 'footer' }
    it { should have_content 'Nick Gerleman' }

  end

end
