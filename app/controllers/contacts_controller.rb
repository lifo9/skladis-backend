class ContactsController < ApplicationController
  before_action :authorize_access_request!
  before_action :set_contact, only: %i[ show update destroy ]

  # GET /contacts
  def index
    if params[:search]
      @contacts = Contact.search_all_fields(params[:search])
    else
      @contacts = paginate Contact.all
    end
    @contacts = @contacts.api_order_by(params[:order_by], params[:order]) if params[:order_by] || params[:order]

    render json: ContactSerializer.new(@contacts)
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
