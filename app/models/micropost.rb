# == Schema Information
#
# Table name: microposts
#
#  id         :integer          not null, primary key
#  content    :string(255)
#  user_id    :integer
#  to_id      :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Micropost < ActiveRecord::Base
  #attr_accessible :content
  belongs_to :user
  belongs_to :to, class_name: "User"
  belongs_to :parent,
    class_name: 'Micropost'

  has_many :replies, foreign_key: "to_id", class_name: "Micropost"
  has_many :children,
    class_name: 'Micropost',
    foreign_key: :parent_id,
    dependent: :destroy

  validates :content, presence: true, length: {maximum: 140}
  validates :user_id, presence: true

  default_scope { users_active.order('created_at DESC') }

  before_save :extract_in_reply_to

  # same, including replies.
  scope :private, -> { where(:private => true) }
  scope :not_private, -> { where(:private => false) }
  scope :glows, -> { where("parent_id IS NULL") }
  scope :comments, -> { where("parent_id IS NOT NULL") }
  scope :from_users_followed_by_including_replies, lambda { |user| followed_by_including_replies(user) }
  scope :followed, -> (user) {
    followed_user_ids = "SELECT followed_id FROM relationships WHERE follower_id = :user_id"
    where("(user_id IN (#{followed_user_ids}) AND private = false) OR user_id = :user_id OR to_id = :user_id", user_id: user.id)
  }

  scope :followers_posts, -> (user) {
    follower_user_ids = "SELECT follower_id FROM relationships WHERE followed_id = :user_id"
    where("(user_id IN (#{follower_user_ids}) AND private = false) OR user_id = :user_id OR to_id = :user_id", user_id: user.id)
  }

  scope :follows, -> (user, checkbox1, checkbox2) {
    if(checkbox1 == 'checked' && checkbox2 == 'checked')
      follower_user_ids = "SELECT follower_id FROM relationships WHERE followed_id = :user_id"
      followed_user_ids = "SELECT followed_id FROM relationships WHERE follower_id = :user_id"
    elsif(checkbox1 == 'checked' && checkbox2 == 'unchecked')
      follower_user_ids = '0'
      followed_user_ids = "SELECT followed_id FROM relationships WHERE follower_id = :user_id"
    elsif(checkbox1 == 'unchecked' && checkbox2 == 'checked')
      follower_user_ids = "SELECT follower_id FROM relationships WHERE followed_id = :user_id"
      followed_user_ids = '0'
    else
      follower_user_ids = "0"
      followed_user_ids = '0'
    end
      where("((user_id IN (#{followed_user_ids}) OR user_id IN (#{follower_user_ids})) AND private = false) OR user_id = :user_id OR to_id = :user_id", user_id: user.id)
  }

  scope :users_active, -> {
    user_ids = "SELECT id FROM users WHERE account_active = true"
    where("user_id IN (#{user_ids})")
  }

  @@reply_to_regexp = /\A@@([^\s]*)/

  def extract_in_reply_to
    if match = @@reply_to_regexp.match(content)

      #user = User.find_by_nick(match[1].downcase)
      user = User.find_by_email(match[1])
      self.to=user if user
    end
  end

  def self.followed_by_including_replies(user)
    followed_user_ids = "SELECT followed_id FROM relationships
                         WHERE follower_id = :user_id"

    where("(user_id IN (#{followed_user_ids}) AND private = false) AND to_id is null OR user_id = :user_id OR to_id = :user_id ", user_id: user.id)
  end

# Returns microposts from the users being followed by the given user.
#      def self.from_users_followed_by(user)
#        followed_user_ids = " SELECT followed_id FROM relationships
#                         WHERE follower_id = :user_id"
#        where("user_id IN (#{followed_user_ids}) OR user_id = :user_id", user_id: user.id)
#      end


  end
