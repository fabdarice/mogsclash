class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :nickname, :password, :password_confirmation, :remember_me, :lastname, :firstname, :email, :rank

  validates_presence_of :nickname, :password, :password_confirmation, :lastname, :firstname, :message => 'Cannot be blank.'


  has_many :games
  has_many :challengers, :through => :games
  has_many :inverse_games, :class_name => "Game", :foreign_key => "challenger_id"
  has_many :inverse_challengers, :through => :inverse_games, :source => :user

  

  def nb_victory
    nb_victory = Game.where(:winner_id => self.id, :status => 'Done').count
  end

  def nb_defeat
    nb_defeat_user = Game.where('user_id = ? and winner_id != ? and status = ?', self.id, self.id, 'Done').count
    nb_defeat_challenger = Game.where('challenger_id = ? and winner_id != ? and status = ?', self.id, self.id, 'Done').count
    nb_total_defeat = nb_defeat_user + nb_defeat_challenger
  end
  
  def general_victory
    games = Game.where('user_id = ? and status = ?', self.id, 'Done')
    nb_general_victory = 0
    games.each do |game|
      nb_general_victory = nb_general_victory + game.user_1_score
    end

    games = Game.where('challenger_id = ? and status = ?', self.id, 'Done')
    games.each do |game|
      nb_general_victory = nb_general_victory + game.user_2_score
    end
     
     nb_general_victory
  end

  def general_defeat
    games = Game.where('user_id = ? and status = ?', self.id, 'Done')
    nb_general_defeat = 0
    games.each do |game|
      nb_general_defeat = nb_general_defeat + game.user_2_score
    end

    games = Game.where('challenger_id = ? and status = ?', self.id, 'Done')
    games.each do |game|
      nb_general_defeat = nb_general_defeat + game.user_1_score
    end

    nb_general_defeat
  end

end
