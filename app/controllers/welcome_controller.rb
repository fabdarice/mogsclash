class WelcomeController < ApplicationController
  def index
    @users = User.order('points DESC')
    @games = Game.where('status = ?', 'Done').order('updated_at DESC').limit(10)
  end
end
