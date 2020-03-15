class User < ApplicationRecord
  before_save { self.email.downcase! }
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  has_many :microposts

  has_many :relationships
  has_many :followings, through: :relationships, source: :follow
  has_many :reverses_of_relationship, class_name: 'Relationship', foreign_key: 'follow_id'
  has_many :followers, through: :reverses_of_relationship, source: :user

  def follow(other_user)
    unless self == other_user
      self.relationships.find_or_create_by(follow_id: other_user.id)
    end
  end

  def unfollow(other_user)
    relationship = self.relationships.find_by(follow_id: other_user.id)
    relationship.destroy if relationship
  end

  def following?(other_user)
    self.followings.include?(other_user)
  end

  def feed_microposts
    Micropost.where(user_id: self.following_ids + [self.id])
  end

  has_many :favorites
#  has_many :favorites, class_name: 'Favorite', foreign_key: 'user'
  has_many :favo_posts, through: :favorites, source: :micropost
  has_many :reverses_of_favorites, class_name: 'Favorite', foreign_key: 'micropost'
  has_many :rev_favo_posts, through: :reverses_of_favorites, source: :user

  def set_favorite(micropost)
    self.favorites.find_or_create_by(micropost_id: micropost.id)
  end

  def unset_favorite(micropost)
    r = self.favorites.find_by(micropost_id: micropost.id)
    r.destroy if r
  end

  def favorite?(micropost)
    self.favo_posts.include?(micropost)
  end

end
