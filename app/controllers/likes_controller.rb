class LikesController < ApplicationController

before_action :set_suggestion

  def create
    @suggestion.likes.create!(user: current_user)
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace("likes-count-#{@suggestion.id}", partial: "suggestions/likes", locals: { suggestion: @suggestion })
      end
      format.html { redirect_to @suggestion }
    end
  end

 def destroy
  @suggestion = Suggestion.find(params[:suggestion_id])
  @suggestion.likes.find_by(user: current_user)&.destroy

  respond_to do |format|
    format.turbo_stream do
      render turbo_stream: turbo_stream.replace(
        "likes-count-#{@suggestion.id}",
        partial: "suggestions/likes",
        locals: { suggestion: @suggestion }
      )
    end
    format.html { redirect_to suggestions_path }
  end
end


  def current_user_like_for(suggestion)
  suggestion.likes.find_by(user_id: current_user.id)
end

  private

  def set_suggestion
    @suggestion = Suggestion.find(params[:suggestion_id])
  end

end
