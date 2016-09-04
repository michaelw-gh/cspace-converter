class ImportForm
  include Capybara::DSL

  def visit_page
    visit('/')
    click_on('Import data')
    self
  end

  def fill_in_with(params = {})
    fill_in('Batch', with: params.fetch(:batch, 'abcxyz123'))
    self
  end

  def submit
    click_on('Upload')
    self
  end

end