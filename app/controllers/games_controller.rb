class GamesController < ApplicationController

  before_filter :authenticate_user!, :only => [:accept_challenge, :new, :enter_results, :update, :validate_game, :unvalidate_game]

  def new    
    @challenger = User.find(params[:challenger_id])
    @game = current_user.games.build(:challenger_id => params[:challenger_id], :status => 'Waiting')
    
    @game.save
    

    @feednews = Feednews.new
    @feednews.content = '<strong>'+ current_user.nickname + '</strong> challenged <strong>' + @challenger.nickname + '</strong>.'   
    @feednews.save


    respond_to do |format|
      format.html { render :nothing => true }
      format.js { }
    end
  end

  def accept_challenge
    @user = User.find(params[:user_id])
    
    @game = Game.where(user_id: params[:user_id], challenger_id: current_user.id, status: 'Waiting').limit(1).first
    @game.update_attribute(:status, 'Enter Results')
    @game.save    

    @feednews = Feednews.new
    @feednews.content = '<strong>'+ current_user.nickname + '</strong> agreed to <strong>' + @user.nickname + '\'s</strong> challenge.'   
    @feednews.save


    respond_to do |format|
      format.html { render :nothing => true }
      format.js { }
    end
  end

  def enter_results
    @games = Game.where(user_id: current_user.id, status: 'Enter Results')
    @validate_games = Game.where(challenger_id: current_user.id, status: 'Validate')
  end

  def update
    @game = Game.find(params[:id])
    
    #@champ1 = params[:game][:user_1_champ]
    #@champ2 = params[:game][:user_2_champ]

    if params[:game][:user_1_score] >= params[:game][:user_2_score]
      @game.update_attribute(:winner_id, @game.user.id)
    else
      @game.update_attribute(:winner_id, @game.challenger.id)
    end

    #if Champion.where(:name => @champ1).count == 0
    #  @champ1 = Champion.new
    #  @champ1.name = params[:game][:user_1_champ]
    #  @champ1.save
    #end
    #if Champion.where(:name => @champ2).count == 0
    #  @champ2 = Champion.new
    #  @champ2.name = params[:game][:user_2_champ]
    #  @champ2.save
    #end

    @game.update_attribute('status', 'Validate')

    if @game.update_attributes(params[:game])
      flash[:notice] = 'Result Updated'

      redirect_to root_path
    else
      render 'enter_results'
    end
  end

  def validate_game
    @game = Game.find(params[:id])
    @game.update_attribute('status', 'Done')
    flash[:notice] = 'The game has been approved.'
    @feednews = Feednews.new
    @feednews.content = @game.user.nickname + ' <strong>' +
      @game.user_1_score.to_s + ' : ' + @game.user_2_score.to_s + '</strong> ' +
      @game.challenger.nickname     
    @feednews.save

    winner = User.find(@game.winner_id)

    if winner == @game.user
      loser = @game.challenger
    else
      loser = @game.user
    end

    diff = winner.points - loser.points
    diff = 10 - diff/10
    if diff < 0 
      diff = 0
    end
    
    if @game.user_1_score == 0 or @game.user_2_score == 0
      diff = diff + 2
    else
      diff = diff + 1
    end

    @game.update_attribute('points_diff', diff)

    winner.update_attribute('points', winner.points + diff)
    loser.update_attribute('points', loser.points - diff)
    

    #if !winner.rank.present?
     # user_last_rank = User.where("rank IS NOT NULL").order('rank DESC').limit(1).first
     # last_rank = user_last_rank.rank + 1
     # winner.update_attribute('rank', last_rank)
    #end

   # if !loser.rank.present?
      #user_last_rank = User.where("rank IS NOT NULL").order('rank DESC').limit(1).first
     # last_rank = user_last_rank.rank + 1
     # loser.update_attribute('rank', last_rank)
    #end

  #  if loser.rank.present? and winner.rank.present?
      #if winner.rank > loser.rank
       # tmp_winner_rank = winner.rank
        #winner.update_attribute('rank', loser.rank)
        #loser.update_attribute('rank', tmp_winner_rank)
      #end
    #end 

    

    redirect_to root_path
  end


  def unvalidate_game
    @game = Game.find(params[:id])
    @game.update_attribute('status', 'Enter Results')
    flash[:notice] = 'The game has been unapproved.'
    redirect_to root_path
  end

end
