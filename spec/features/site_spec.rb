require 'rails_helper'

RSpec.feature 'Site home page' do

  scenario "statement of purpose" do
    visit('/')
    expect(page).to have_content('Migrate data to CollectionSpace from CSV.')
  end

end