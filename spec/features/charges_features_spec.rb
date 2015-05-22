require 'rails_helper'
require 'helpers/users_helper_spec'
require 'helpers/projects_helper_spec'
require 'helpers/donations_helper_spec'

feature 'stripe' do

 include UserHelper
 include PaymentsHelper
 include ProjectsHelper

  before do
    sign_up
    Project.create(name: 'Campaign', description: regular_description, goal: '75', expiration_date: Time.now + (5), sector: 'Environment', address: 'London', user: User.last)
    visit '/'
    click_link 'Campaign'
    make_payment
    sleep(2)
    visit "/projects/#{Project.last.id}/charges/new"
    find('.stripe-button-el').click
    sleep(2)
    stripe_iframe = all('iframe[name=stripe_checkout_app]').last
    Capybara.within_frame stripe_iframe do
     page.execute_script(%Q{ $('input#email').val('jamesdd9302@yahoo.com'); })
       page.execute_script(%Q{ $('input#card_number').val('4242424242424242'); })
       page.execute_script(%Q{ $('input#cc-exp').val('08/44'); })
       page.execute_script(%Q{ $('input#cc-csc').val('999'); })
       page.execute_script(%Q{ $('#submitButton').click(); })
     sleep(5)
    end
  end

  scenario 'fills in and submits stripe form', js: true, driver: :selenium do
    expect(page).to have_content('you paid £ 75 for Campaign!')
  end

  scenario 'it change donation status to true', js: true, driver: :selenium do
    expect(Donation.first.paid).to eq true
  end
end