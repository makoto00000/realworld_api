class Article < ApplicationRecord
  before_save :generate_slug

  belongs_to :user
  has_many :article_tags, dependent: :destroy
  has_many :tags, through: :article_tags

  def sync_tags(tag_list)
    tag_list.each do |tag_name|
      tag = Tag.find_or_create_by(name: tag_name)
      tags << tag
    end
  end

  def generate_slug
    self.slug = title.parameterize
  end
end
