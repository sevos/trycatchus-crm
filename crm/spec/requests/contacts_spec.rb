require 'rails_helper'

RSpec.describe '/contacts' do
  let(:json_response) { JSON.parse(response.body) }
  let(:object_name) { 'contact' }
  let(:json_object) { json_response[object_name] }

  describe 'POST /contacts.json' do
    subject { post '/contacts', {object_name => attributes, format: 'json'} }

    before { subject }

    context 'with valid attributes' do
      let(:attributes) { attributes_for(:contact).stringify_keys }

      it 'responds with created contact' do
        expected = attributes.merge('id' => Contact.last.id)
        expect(json_object).to eq(expected)
      end
    end

    context 'with missing name' do
      let(:attributes) { attributes_for(:contact).except(:name).stringify_keys }

      it 'responds with unprocessable entity and errors' do
        expect(response.status).to eq(422)
        expect(json_object).to eq({'name' => ["can't be blank"]})
      end
    end
  end
end
