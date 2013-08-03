require 'spec_helper'

describe 'Register Page', js: true do

  subject { page }

  before do
    visit new_session_path
    click_link 'Register'
  end

  it { should have_selector '#register' }
  it { should have_selector 'h3', text: 'Register' }
  it { should have_field 'Name' }
  it { should have_field 'Email Address' }
  it { should have_field 'Confirm Email Address' }
  it { should have_field 'Password' }
  it { should have_field 'Confirm Password' }
  it { should have_button 'Submit' }
  it 'should close correctly' do
    sleep 0.5
    click_button 'Close'
    sleep 0.5
    should_not have_content 'Confirm Email Address'
  end

end

describe 'Valid Registration', js: true do

  subject { page }

  before :each do
    num = rand(100000)
    visit new_session_path
    click_link 'Register'
    fill_in 'Name', with: 'Bob'
    fill_in 'user_email', exact: true, with: "#{num}@example.com"
    fill_in 'Confirm Email Address', with: "#{num}@example.com"
    fill_in 'user_password', exact: true, with: 'password'
    fill_in 'Confirm Password', with: 'password'
  end

  it { should have_selector '#register' }
  it 'should increment the user count' do
    expect do
      click_button 'Submit'
      sleep 0.5
    end.to change(User, :count).by 1
  end

  it do
    click_button 'Submit'
    should_not have_selector('.error')
  end

  it do
    click_button 'Submit'
    sleep 1
    should have_content 'Success'
  end

  it 'should close correctly' do
    click_button 'Close'
    should_not have_content 'Confirm Email Address'
  end

end

describe 'invalid_name', js: true do

  subject { page }

  before :each do
    num = rand(100000)
    visit new_session_path
    click_link 'Register'
    fill_in 'Name', with: 'B'
    fill_in 'user_email', exact: true, with: "#{num}@example.com"
    fill_in 'Confirm Email Address', with: "#{num}@example.com"
    fill_in 'user_password', exact: true, with: 'password'
    fill_in 'Confirm Password', with: 'password'
    @initial_count = User.count
    click_button 'Submit'
  end

  it { User.count.should eq @initial_count }
  it { should have_selector '.error' }
  it 'should close correctly' do
    click_button 'Close'
    should_not have_content 'Confirm Email Address'
  end
end

describe 'invalid_email', js: true do

  subject { page }

  before :each do
    num = rand(100000)
    visit new_session_path
    click_link 'Register'
    fill_in 'Name', with: 'Bob'
    fill_in 'user_email', exact: true, with: "#{num}@example"
    fill_in 'Confirm Email Address', with: "#{num}@example"
    fill_in 'user_password', exact: true, with: 'password'
    fill_in 'Confirm Password', with: 'password'
    @initial_count = User.count
    click_button 'Submit'
  end

  it { User.count.should eq @initial_count }
  it { should have_selector '.error' }
  it 'should close correctly' do
    click_button 'Close'
    should_not have_content 'Confirm Email Address'
  end
end

describe 'non_matching_email', js: true do

  subject { page }

  before :each do
    num = rand(100000)
    visit new_session_path
    click_link 'Register'
    fill_in 'Name', with: 'Bob'
    fill_in 'user_email', exact: true, with: "#{num}@exampel.com"
    fill_in 'Confirm Email Address', with: "#{num}@example.com"
    fill_in 'user_password', exact: true, with: 'password'
    fill_in 'Confirm Password', with: 'password'
    @initial_count = User.count
    click_button 'Submit'
  end

  it { User.count.should eq @initial_count }
  it { should have_selector '.error' }
  it 'should close correctly' do
    click_button 'Close'
    should_not have_content 'Confirm Email Address'
  end
end

describe 'invalid_password', js: true do

  subject { page }

  before :each do
    num = rand(100000)
    visit new_session_path
    click_link 'register-button'
    fill_in 'Name', with: 'Bob'
    fill_in 'user_email', exact: true, with: "#{num}@example.com"
    fill_in 'Confirm Email Address', with: "#{num}@example.com"
    fill_in 'user_password', exact: true, with: 'pa'
    fill_in 'Confirm Password', with: 'pa'
    @initial_count = User.count
    click_button 'Submit'
  end

  it { User.count.should eq @initial_count }
  it { should have_selector '.error' }
  it 'should close correctly' do
    click_button 'Close'
    should_not have_content 'Confirm Email Address'
  end
end

describe 'non_matching_password', js: true do

  subject { page }

  before :each do
    num = rand(100000)
    visit new_session_path
    click_link 'Register'
    fill_in 'Name', with: 'Bob'
    fill_in 'user_email', exact: true, with: "#{num}@example.com"
    fill_in 'Confirm Email Address', with: "#{num}@example.com"
    fill_in 'user_password', exact: true, with: 'password'
    fill_in 'Confirm Password', with: 'passw0rd'
    @initial_count = User.count
    click_button 'Submit'
  end

  it { User.count.should eq @initial_count }
  it { should have_selector '.error' }
  it 'should close correctly' do
    click_button 'Close'
    should_not have_content 'Confirm Email Address'
  end

end
describe 'existing_email', js: true do

  subject { page }

  before :each do
    num = rand(100000)
    2.times do
      visit new_session_path
      click_link 'Register'
      fill_in 'Name', with: 'Bob'
      fill_in 'user_email', exact: true, with: "#{num}@example.com"
      fill_in 'Confirm Email Address', with: "#{num}@example.com"
      fill_in 'user_password', exact: true, with: 'password'
      fill_in 'Confirm Password', with: 'password'
      @initial_count = User.count
      click_button 'Submit'
    end
  end

  it { User.count.should eq @initial_count }
  it { should have_selector '.error' }
  it 'should close correctly' do
    click_button 'Close'
    should_not have_content 'Confirm Email Address'
  end
end