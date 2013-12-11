class ResultsController < ApplicationController
  def index
    @games = Game.where('status = ?', 'Done').paginate(:page => params[:page]).order('updated_at DESC')
  end
end
