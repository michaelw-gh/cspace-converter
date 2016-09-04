require 'rails_helper'
require_relative '../support/import_form'

RSpec.feature 'Importing data' do
  let(:bad_import_form) { ImportForm.new }

  scenario "without uploading a file fails" do
    expect(bad_import_form.visit_page.submit).to have_content('There was an error processing the uploaded file.')
  end

end