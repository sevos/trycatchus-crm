class ContactsController < ApplicationController
  def index
    @contacts = contacts.to_a
  end

  def create
    @contact = contacts.new(contact_params)
    unless @contact.save
      render_validation_errors(@contact)
    end
  end

  def update
    @contact = contacts.find(params[:id])
    unless @contact.update_attributes contact_params
      render_validation_errors(@contact)
    end
  end

  private

  def render_validation_errors(model)
    render json: {model.class.name.underscore => model.errors},
           status: :unprocessable_entity
  end

  def contacts
    Contact.all
  end

  def contact_params
    params.require(:contact).permit(:name, :phone, :description,
                                    :website_url, :email)
  end
end
