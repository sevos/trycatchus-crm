require 'rails_helper'

RSpec.describe '/users' do
  extend JsonApiHelper
  setup_endpoint 'user', visible_attributes: %w(name level)
  describe 'GET /user' do
    subject { get '/user', format: 'json'}

    it 'returns guest info' do
      subject
      expect(json_object).to eq({
                                  'name' => nil,
                                  'type' => 'guest'
                                })
    end
  end
end
