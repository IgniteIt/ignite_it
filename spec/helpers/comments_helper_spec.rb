require 'rails_helper'

module CommentsHelper
  def make_comment
    click_link 'Comment'
    fill_in 'Comment', with: 'I disagree!'
    click_button 'Submit'
  end
end