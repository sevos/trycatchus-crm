require 'rails_helper'

RSpec.describe '/users' do
  include JsonApiHelper

  setup_endpoint 'user', visible_attributes: %w(name level)

  describe 'GET /user' do
    subject { get '/user', {format: 'json'}, @env }

    it 'returns guest info' do
      subject
      expect(json_object).to eq({
                                  'name' => nil,
                                  'type' => 'Guest'
                                })
    end

    it 'returns unauthorized for invalid credentials' do
      login('bogus', 'invalid')
      subject
      expect(response.status).to eq(401)
    end

    context 'with valid credentials' do
      let!(:user) { create(:user, name: 'sevos',
                          password: 'qwerty', password_confirmation: 'qwerty')}

      before { login 'sevos', 'qwerty' }

      it 'returns user info' do
        subject
        expect(json_object).to eq({
                                    'name' => 'sevos',
                                    'type' => 'User'
                                  })
      end
    end

  end
end
