class TagsController < ApplicationController
  def index
    @tags = Tag.all.order(:name)
    @tag = Tag.new
    @tag_counts = ContactTag.group(:tag_id).count
  end

  def create
    @tag = Tag.new(tag_params)
    
    if @tag.save
      redirect_to tags_path, notice: 'Tag was successfully created.'
    else
      @tags = Tag.all.order(:name)
      @tag_counts = ContactTag.group(:tag_id).count
      render :index, status: :unprocessable_entity
    end
  end

  def destroy
    @tag = Tag.find(params[:id])
    @tag.destroy
    redirect_to tags_path, notice: 'Tag was successfully deleted.'
  end

  private

  def tag_params
    params.require(:tag).permit(:name)
  end
end
