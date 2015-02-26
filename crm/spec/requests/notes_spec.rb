require 'rails_helper'

RSpec.describe '/contacts/:contact_id/notes' do
  include JsonApiHelper
  before { login_user }
  setup_endpoint 'note', visible_attributes: %w(id contact_id title description)
  let(:contact) { create(:contact) }

  describe 'POST /contacts/:id/notes' do
    subject {
      post "/contacts/#{contact.id}/notes",
           {object_name => attributes, format: 'json'}, @env
    }

    before { subject }

    context 'with valid attributes' do
      let(:attributes) { attributes_for(:note).stringify_keys }

      it 'responds with created note' do
        expected = attributes.merge('id' => Note.last.id,
                                    'contact_id' => contact.id)
        expect(json_object).to eq(expected)
      end

      it 'creates a note owned by current user' do
        expect(Note.last.owner).to eq(current_user)
      end
    end

    context 'with invalid attributes' do
      let(:attributes) { attributes_for(:note).except(:title).stringify_keys }

      it 'responds with unprocessable entity and errors' do
        expect(response.status).to eq(422)
        expect(json_object).to eq({'title' => ["can't be blank"]})
      end
    end
  end

  describe 'GET /contacts/:id/notes' do
    let!(:another_note) { create(:note) }
    subject { get "/contacts/#{contact.id}/notes", {format: 'json'}, @env }

    it 'returns empty list' do
      subject
      expect(json_collection).to be_empty
    end

    context 'when a note has been created on the contact' do
      let!(:note) { create(:note, contact: contact) }

      it 'returns the note' do
        expected = note.attributes.slice(*visible_attributes)
        subject
        expect(json_collection[0]).to eq(expected)
      end
    end
  end
end
