module Api
  class InteractionsController < BaseController
    before_action :set_interaction, only: [:show, :update, :destroy]

    def index
      @interactions = current_user.interactions.order(date: :desc)
      render_success(interactions: @interactions)
    end

    def show
      render_success(interaction: @interaction)
    end

    def create
      @interaction = current_user.interactions.build(interaction_params)
      
      if @interaction.save
        render_success(interaction: @interaction, status: :created)
      else
        render_error(@interaction.errors.full_messages)
      end
    end

    def update
      if @interaction.update(interaction_params)
        render_success(interaction: @interaction)
      else
        render_error(@interaction.errors.full_messages)
      end
    end

    def destroy
      @interaction.destroy
      render_success(message: 'Interaction was successfully deleted')
    end

    private

    def set_interaction
      @interaction = current_user.interactions.find(params[:id])
    end

    def interaction_params
      params.require(:interaction).permit(:date, :interaction_type, :notes)
    end
  end
end 