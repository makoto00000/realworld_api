# frozen_string_literal: true

class ArticleTag < ApplicationRecord # rubocop:disable Style/Documentation
  belongs_to :article
  belongs_to :tag
end
