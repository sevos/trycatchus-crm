class NotesController < ApplicationController
  def create
    @note = notes.build(note_params)
    unless @note.save
      render_validation_errors(@note)
    end
  end

  private

  def notes
    contact.notes
  end

  def contact
    contacts.find(params[:contact_id])
  end

  def contacts
    Contact.all
  end

  def note_params
    params.require(:note).permit(:title, :description)
  end
end
