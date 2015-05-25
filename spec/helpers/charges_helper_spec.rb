require 'rails_helper'

module ChargesHelper
  def charge_helper
    find('.stripe-button-el').click
    sleep(2)
    stripe_iframe = all('iframe[name=stripe_checkout_app]').last
    Capybara.within_frame stripe_iframe do
      page.execute_script(%Q{ $('input#email').val('test@email.com'); })
      page.execute_script(%Q{ $('input#card_number').val('4242424242424242'); })
      page.execute_script(%Q{ $('input#cc-exp').val('08/44'); })
      page.execute_script(%Q{ $('input#cc-csc').val('118'); })
      page.execute_script(%Q{ $('#submitButton').click(); })
    end
    sleep(5)
   end
end