class ContactsController < ApplicationController
  before_action :authorize_access_request!
  before_action :set_contact, only: %i[ show update destroy destroy_avatar ]

  # GET /contacts
  def index
    @contacts = api_index(Contact, params)

    render json: ContactSerializer.new(@contacts)
  end

  # GET /contacts/select-options
  def select_options
    render json: api_select_options(Contact, [:first_name, :last_name], :id, params)
  end

  # GET /contacts/1
  def show
    render json: ContactSerializer.new(@contact)
  end

  # POST /contacts
  def create
    @contact = Contact.new(contact_params)
    serialized_contact = ContactSerializer.new(@contact)

    if @contact.save
      render json: serialized_contact, status: :created
    else
      render json: @contact.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /contacts/1
  def update
    if @contact.update(contact_params)
      render json: ContactSerializer.new(@contact)
    else
      render json: @contact.errors, status: :unprocessable_entity
    end
  end

  # DELETE /contacts/1
  def destroy
    @contact.destroy
  end

  # DELETE /contacts/1/avatar
  def destroy_avatar
    @contact.avatar.purge
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_contact
    @contact = Contact.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def contact_params
    params.fetch(:contact, {}).permit(Contact::PERMITTED_PARAMS)
  end
end
