class VotesController < ApplicationController

def create
  @user = current_user
  @vote = Vote.new(vote_params)
  @vote.user_id = @user.id
  if voted?(@vote) && @vote.save
    if @vote.votable_type == "Answer"
      redirect_to question_path(@vote.votable.question_id)
    elsif @vote.votable_type == "Question"
      redirect_to question_path(@vote.votable.id)
    elsif @vote.votable_type == "Comment"
      if @vote.votable.commentable_type == "Answer"
        redirect_to question_path(@vote.votable.commentable.question_id)
      elsif @vote.votable.commentable_type == "Question"
        redirect_to question_path(@vote.votable.commentable.id)
      end
    end
  else
    #TODO: add JS/Jquery to have a popup alert without refreshing page or refreshing.
    flash[:notice] = "You already voted"
    redirect_to questions_path
  end
end

private
  def vote_params
    params.require(:vote).permit(:value, :votable_type, :votable_id)
  end
end