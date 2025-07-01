class QuestionsController < ApplicationController
  def index
    @questions = current_user.questions
    @question = Question.new # for form
  end

<<<<<<< HEAD
def create
  @questions = current_user.questions
  @question = Question.new(question_params)
  @question.user = current_user

  if @question.save
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.append(:questions, partial: "questions/question",
          locals: { question: @question })
=======
  def create
    @questions = current_user.questions # needed in case of validation error
    @question = Question.new(question_params)
    @question.user = current_user
    if @question.save
      ChatbotJob.perform_later(@question)
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.append(:questions, partial: "questions/question",
            locals: { question: @question })
        end
        format.html { redirect_to questions_path }
>>>>>>> 5a0482bbf15983458931958b4145469522c6c5f6
      end
      format.html { redirect_to questions_path }
    end
  else
    render :index, status: :unprocessable_entity
  end
end



  private

  def question_params
    params.require(:question).permit(:user_question)
  end
end
