module JsonApiHelper
  def setup_endpoint(object_name, visible_attributes: )
    let(:json_response) { JSON.parse(response.body) }
    let(:object_name) { object_name }
    let(:json_object) { json_response.fetch(object_name) }
    let(:json_collection) { json_response.fetch(object_name.pluralize) }
    let(:visible_attributes) { visible_attributes }
  end
end

shared_examples "respond with 404 when object does not exist" do
  context "when object does not exist" do
    before { public_send(object_name).destroy }

    it 'responds with :not_found' do
      subject
      expect(response.status).to eq(404)
    end
  end
end
