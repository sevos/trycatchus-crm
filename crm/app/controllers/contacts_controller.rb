class ContactsController < ApplicationController
  load_and_authorize_resource

  def index
    @contacts = contacts.to_a
  end

  def create
    @contact = contacts.new(contact_params)
    unless contact.save
      render_validation_errors(contact)
    end
  end

  def update
    unless contact.update_attributes contact_params
      render_validation_errors(contact)
    end
  end

  def destroy
    contact.destroy
    render nothing: true, status: :no_content
  end

  private

  def contact
    @contact ||= contacts.find(params[:id])
  end

  def contacts
    Contact.all
  end

  def contact_params
    params.require(:contact).permit(:name, :phone, :description,
                                    :website_url, :email).
      merge(owner: current_user)
  end
end
