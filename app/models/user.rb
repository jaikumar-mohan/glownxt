class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :lockable,
         :recoverable, :rememberable, :trackable, :validatable #:confirmable, 

  include ActiveModel::Validations

  CommonFormFields = [ 'first_name', 'last_name', 'company_name', 'email', 'password', 'password_confirmation' ]

  attr_accessor :company_name, :tos 

  validates_presence_of :tos, message: 'must be accepted', :if => :new_record?
  validates_with UserCompanyValidator, on: :create

  has_one  :company_relationship, dependent: :destroy
  has_one  :company, through: :company_relationship, source: :company, class_name: 'Company', dependent: :destroy

  has_many :microposts, dependent: :destroy
  has_many :entries, dependent: :destroy

  has_many :relationships, foreign_key: "follower_id", dependent: :destroy

  has_many :followed_users, through: :relationships, source: :followed

  has_many :reverse_relationships, foreign_key: "followed_id",
           class_name: "Relationship",
           dependent: :destroy

  has_many :followers, through: :reverse_relationships, source: :follower

  has_many :replies, foreign_key: "to_id", class_name: "Micropost"

  accepts_nested_attributes_for :company

  validates :first_name, presence: true, length: {maximum: 30}
  validates :last_name, presence: true, length: {maximum: 30}

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}

  before_save { |user| user.email = self.email.downcase }

  after_create :link_with_company!

  def company_attributes=(attributes)
    self.company.attributes = attributes
  end  

  def feed
    # This is preliminary. See "Following users" for the full implementation.
    Micropost.from_users_followed_by_including_replies(self)

    #Micropost.from_users_followed_by(self)
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def handle
    "@@#{email}" #"@#{nick}"
  end

  def following?(other_user)
    relationships.find_by_followed_id(other_user.id)
  end

  def can_follow?(other_user)
    !relationships.exists?(followed_id: other_user.id)
  end

  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
  end

  def unfollow!(other_user)
    relationships.find_by_followed_id(other_user.id).destroy
  end

  def active_for_authentication?
     super && account_active?
  end

  private

  def link_with_company!
    CompanyRelationship.create!(
      company_id: self.company.id,
      user_id: self.id
    )
  end
end
