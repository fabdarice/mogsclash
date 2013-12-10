class WelcomeController < ApplicationController
  def index
    @users = User.order('rank ASC')
  end
end
