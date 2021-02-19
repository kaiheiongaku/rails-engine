require 'rails_helper'

RSpec.describe Transaction do
  describe 'relationships' do
    it { should belong_to :invoice }
  end

  describe 'validations' do
    it { should validate_presence_of :invoice_id }
    it { should validate_presence_of :transaction }
  end
end
