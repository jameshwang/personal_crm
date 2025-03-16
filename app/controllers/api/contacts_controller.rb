module Api
  class ContactsController < BaseController
    before_action :set_contact, only: [:show, :update, :destroy]

    def index
      @contacts = current_user.contacts.order(created_at: :desc)
      render_success(contacts: @contacts)
    end

    def show
      render_success(contact: @contact)
    end

    def create
      @contact = current_user.contacts.build(contact_params)
      
      if @contact.save
        render_success(contact: @contact, status: :created)
      else
        render_error(@contact.errors.full_messages)
      end
    end

    def update
      if @contact.update(contact_params)
        render_success(contact: @contact)
      else
        render_error(@contact.errors.full_messages)
      end
    end

    def destroy
      @contact.destroy
      render_success(message: 'Contact was successfully deleted')
    end

    private

    def set_contact
      @contact = current_user.contacts.find(params[:id])
    end

    def contact_params
      params.require(:contact).permit(:first_name, :last_name, :email, :phone, 
                                    :company, :job_title, :notes)
    end
  end
end 