class Article < ApplicationRecord
  before_save :generate_slug
  before_update :generate_slug

  belongs_to :user
  has_many :article_tags, dependent: :destroy
  has_many :tags, through: :article_tags
  has_and_belongs_to_many :users

  validates :title, presence: true

  def sync_tags(tag_list)
    self.tags = []
    tag_list.each do |tag_name|
      tag = Tag.find_or_create_by(name: tag_name)
      tags << tag
    end
  end

  def favorite(user)
    users << user unless users.include? user
  end

  def unfavorite(user)
    users.delete user
  end

  def as_json(options = {})
    super(options.merge(include: :user))
  end

  private

  def generate_slug
    self.slug = "#{title.strip.downcase.gsub(" ", "-").gsub(".", "")}-#{rand(999999)}"
  end
end
