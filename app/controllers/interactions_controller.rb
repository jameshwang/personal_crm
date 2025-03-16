class InteractionsController < ApplicationController
  before_action :set_contact
  before_action :set_interaction, only: [:destroy]

  def index
    @interactions = @contact.interactions.order(date: :desc)
    @interaction = @contact.interactions.build
  end

  def create
    @interaction = @contact.interactions.build(interaction_params)

    if @interaction.save
      redirect_to contact_path(@contact), notice: 'Interaction was successfully recorded.'
    else
      redirect_to contact_path(@contact), alert: 'Failed to record interaction.'
    end
  end

  def destroy
    @interaction.destroy
    redirect_to contact_path(@contact), notice: 'Interaction was successfully deleted.'
  end

  private

  def set_contact
    @contact = Contact.find(params[:contact_id])
  end

  def set_interaction
    @interaction = @contact.interactions.find(params[:id])
  end

  def interaction_params
    params.require(:interaction).permit(:date, :interaction_type, :notes)
  end
end
