class Game < ActiveRecord::Base
  attr_accessible :status, :challenger_id, :user_1_champ, :user_2_champ, :user_1_score, :user_2_score

  belongs_to :user
  belongs_to :challenger, :class_name => "User"

end
