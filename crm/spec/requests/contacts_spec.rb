require 'rails_helper'

RSpec.describe '/contacts' do
  let(:json_response) { JSON.parse(response.body) }
  let(:object_name) { 'contact' }
  let(:json_object) { json_response.fetch(object_name) }
  let(:json_collection) { json_response.fetch(object_name.pluralize) }
  let(:visible_attributes) { %w(id name phone email website_url description) }

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

  describe 'GET /contacts.json' do
    subject { get '/contacts.json' }

    it 'returns empty list' do
      subject
      expect(json_collection).to be_empty
    end

    context 'when a contact exists' do
      let!(:contact) { create(:contact) }

      it 'returns that contact in a list' do
        subject
        expected = contact.attributes.slice(*visible_attributes)
        expect(json_collection[0]).to eq(expected)
      end
    end
  end
end
