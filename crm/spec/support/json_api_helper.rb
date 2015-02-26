module JsonApiHelper
  extend ActiveSupport::Concern

  module ClassMethods
    def setup_endpoint(object_name, visible_attributes: )
      let(:json_response) { JSON.parse(response.body) }
      let(:object_name) { object_name }
      let(:json_object) { json_response.fetch(object_name) }
      let(:json_collection) { json_response.fetch(object_name.pluralize) }
      let(:visible_attributes) { visible_attributes }
    end
  end

  def login(user_name, password)
    @env ||= {}
    @env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(user_name, password)
    @env
  end

  def login_user
    @current_user = create(:user, name: 'user')
    login 'user', 'qwerty'
  end

  attr_reader :current_user

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
