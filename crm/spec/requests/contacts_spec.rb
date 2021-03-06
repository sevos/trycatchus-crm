require 'rails_helper'

RSpec.describe '/contacts' do
  include JsonApiHelper
  before { login_user }
  setup_endpoint 'contact', visible_attributes: %w(id name phone email website_url description)

  describe 'POST /contacts.json' do
    subject { post '/contacts', {object_name => attributes, format: 'json'}, @env }

    before { subject }

    context 'with valid attributes' do
      let(:attributes) { attributes_for(:contact).stringify_keys }

      it 'responds with created contact' do
        expected = attributes.merge('id' => Contact.last.id)
        expect(json_object).to eq(expected)
      end

      it 'creates a contact owned by current user' do
        expect(Contact.last.owner).to eq(current_user)
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
    subject { get '/contacts.json', {}, @env }

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


  describe 'PATCH /contacts/:id.json' do
    let!(:contact) { create(:contact, owner: current_user) }

    subject { patch "/contacts/#{contact.id}", {object_name => attributes, format: 'json'}, @env }

    context 'with valid attributes' do
      let(:attributes) { {'name' => 'TryCatch.us'} }

      it 'updates contact name' do
        expect { subject }.to change { contact.reload.name }.to 'TryCatch.us'
      end

      it 'responds with new record' do
        expected = contact.attributes.slice(*visible_attributes).
                   merge('name' => 'TryCatch.us')
        subject
        expect(json_object).to eq(expected)
      end

      include_examples 'respond with 404 when object does not exist'
    end

    context 'with invalid attributes' do
      let(:attributes) { { 'name' => '', 'description' => "won't work"} }

      it 'does not update contact' do
        expect { subject }.not_to change { contact.reload.attributes }
      end

      it 'responds with unprocessable entity and errors' do
        subject
        expect(response.status).to eq(422)
        expect(json_object).to eq({'name' => ["can't be blank"]})
      end

      include_examples 'respond with 404 when object does not exist'
    end
  end

  describe 'DELETE /contacts/:id.json' do
    let!(:contact) { create(:contact, owner: current_user) }
    subject { delete "/contacts/#{contact.id}", {format: 'json'}, @env }

    it 'destroys the contact' do
      expect { subject }.to change { Contact.count }.by(-1)
    end

    it 'responds with :no_content' do
      subject
      expect(response.status).to eq(204)
    end

    include_examples 'respond with 404 when object does not exist'

    context 'when resource belongs to another user' do
      let!(:contact) { create(:contact) }

      it 'returns forbidden' do
        subject
        expect(response.status).to eq(403)
      end

      context 'when logged in as an admin' do
        before do
          create(:admin, name: 'admin')
          login 'admin', 'qwerty'
        end

        it 'destroys the contact' do
          expect { subject }.to change { Contact.count }.by(-1)
        end

        it 'responds with :no_content' do
          subject
          expect(response.status).to eq(204)
        end
      end
    end
  end
end
