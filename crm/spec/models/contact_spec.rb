require 'rails_helper'

RSpec.describe Contact, type: :model do
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:email) }
end
