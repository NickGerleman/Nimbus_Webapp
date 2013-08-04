require 'spec_helper'

describe 'User Pages' do

  subject { page }

  describe 'Settings Page', js: true do

    before do
      create(:user)
      visit new_session_path
      fill_in 'email', with: 'name@example.com'
      fill_in 'password', with: 'password'
      click_button 'login-button'
      sleep 0.5
    end

    it { should have_text 'Bob' }
    it { should have_text 'verified' }
    it { should have_text 'Connections' }
    it { should have_content 'Link a New Account' }

  end

  describe 'Account Deletion Popup', js: true do

    before do
      create(:user)
      visit new_session_path
      fill_in 'email', with: 'name@example.com'
      fill_in 'password', with: 'password'
      click_button 'login-button'
      click_link 'delete-account'
    end

    describe 'The Popup' do

      it { should have_text 'Delete' }
      it { should have_selector '.popup' }

    end

    describe 'Correct Password' do
      before(:each) do
        fill_in 'password', with: 'password'
        click_button 'Delete'
        sleep 0.2
      end
      it do
        should_not have_selector '.error'
      end

      it do
        should have_text 'Account Deleted Successfully'
      end
    end

    describe 'Incorrect Password' do

      before { fill_in 'password', with: 'invalidpass' }

      it do
        click_button 'Delete'
        should have_selector '.error'
      end
    end

  end

  describe 'Register Page', js: true do

    before do
      visit new_session_path
      click_link 'Register'
    end

    describe 'Popup Contents' do

      it { should have_selector '#register' }
      it { should have_selector 'h3', text: 'Register' }
      it { should have_field 'Name' }
      it { should have_field 'Email Address' }
      it { should have_field 'Confirm Email Address' }
      it { should have_field 'Password' }
      it { should have_field 'Confirm Password' }
      it { should have_button 'Submit' }

      it 'should close correctly' do
        click_button 'Close'
        sleep 2
        page.save_screenshot('screenshot.png')
        should_not have_content 'Confirm Email Address'
      end

    end

    describe 'Valid Registration' do


      before :each do
        visit new_session_path
        click_link 'Register'
        fill_in 'Name', with: 'Bob'
        fill_in 'user_email', exact: true, with: "name@example.com"
        fill_in 'Confirm Email Address', with: "name@example.com"
        fill_in 'user_password', exact: true, with: 'password'
        fill_in 'Confirm Password', with: 'password'
      end

      it { should have_selector '#register' }

      it 'should increment the user count' do
        expect do
          click_button 'Submit'
          sleep 0.2
        end.to change(User, :count).by 1
      end

      it do
        click_button 'Submit'
        sleep 0.5
        should_not have_selector('.error')
      end

      it do
        click_button 'Submit'
        sleep 0.5
        should have_content 'Success'
      end

      it 'should close correctly' do
        click_button 'Close'
        should_not have_content 'Confirm Email Address'
      end

    end

    describe 'invalid_name' do

      before :each do
        fill_in 'Name', with: 'B'
        fill_in 'user_email', exact: true, with: "name@example.com"
        fill_in 'Confirm Email Address', with: "name@example.com"
        fill_in 'user_password', exact: true, with: 'password'
        fill_in 'Confirm Password', with: 'password'
        @initial_count = User.count
        click_button 'Submit'
        sleep 0.2
      end

      it { User.count.should eq @initial_count }

      it { should have_selector '.error' }

      it 'should close correctly' do
        click_button 'Close'
        should_not have_content 'Confirm Email Address'
      end

    end

    describe 'invalid_email' do

      before :each do
        fill_in 'Name', with: 'Bob'
        fill_in 'user_email', exact: true, with: "name@example"
        fill_in 'Confirm Email Address', with: "name@example"
        fill_in 'user_password', exact: true, with: 'password'
        fill_in 'Confirm Password', with: 'password'
        @initial_count = User.count
        click_button 'Submit'
        sleep 0.2
      end

      it { User.count.should eq @initial_count }

      it { should have_selector '.error' }

      it 'should close correctly' do
        click_button 'Close'
        should_not have_content 'Confirm Email Address'
      end

    end

    describe 'non_matching_email' do

      before :each do
        fill_in 'Name', with: 'Bob'
        fill_in 'user_email', exact: true, with: "name@exampel.com"
        fill_in 'Confirm Email Address', with: "name@example.com"
        fill_in 'user_password', exact: true, with: 'password'
        fill_in 'Confirm Password', with: 'password'
        @initial_count = User.count
        click_button 'Submit'
        sleep 0.2
      end

      it { User.count.should eq @initial_count }

      it { should have_selector '.error' }

      it 'should close correctly' do
        click_button 'Close'
        should_not have_content 'Confirm Email Address'
      end

    end

    describe 'invalid_password' do

      before :each do
        fill_in 'Name', with: 'Bob'
        fill_in 'user_email', exact: true, with: "name@example.com"
        fill_in 'Confirm Email Address', with: "#name@example.com"
        fill_in 'user_password', exact: true, with: 'pa'
        fill_in 'Confirm Password', with: 'pa'
        @initial_count = User.count
        click_button 'Submit'
        sleep 0.2
      end

      it { User.count.should eq @initial_count }

      it { should have_selector '.error' }

      it 'should close correctly' do
        click_button 'Close'
        should_not have_content 'Confirm Email Address'
      end

    end

    describe 'non_matching_password' do

      before :each do
        fill_in 'Name', with: 'Bob'
        fill_in 'user_email', exact: true, with: "name@example.com"
        fill_in 'Confirm Email Address', with: "#name@example.com"
        fill_in 'user_password', exact: true, with: 'password'
        fill_in 'Confirm Password', with: 'passw0rd'
        @initial_count = User.count
        click_button 'Submit'
        sleep 0.2
      end

      it { User.count.should eq @initial_count }

      it { should have_selector '.error' }

      it 'should close correctly' do
        click_button 'Close'
        should_not have_content 'Confirm Email Address'
      end

    end
    describe 'existing_email' do

      before :each do
        2.times do
          visit new_session_path
          click_link 'Register'
          fill_in 'Name', with: 'Bob'
          fill_in 'user_email', exact: true, with: "name@example.com"
          fill_in 'Confirm Email Address', with: "#name@example.com"
          fill_in 'user_password', exact: true, with: 'password'
          fill_in 'Confirm Password', with: 'password'
          @initial_count = User.count
          click_button 'Submit'
          sleep 0.2
        end
      end

      it { User.count.should eq @initial_count }

      it { should have_selector '.error' }

      it 'should close correctly' do
        click_button 'Close'
        should_not have_content 'Confirm Email Address'
      end

    end

  end

end
