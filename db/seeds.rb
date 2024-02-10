# frozen_string_literal: true

require 'faker'

%w[
  realworld
  implementations
  programming
  javascript
  emberjs
  angularjs
  react
  mean
  node
  rails
].each do |tag|
  Tag.create(name: tag)
end

10.times do
  User.new(
    username: Faker::Internet.unique.username(separators: []),
    email: Faker::Internet.email,
    bio: Faker::Lorem.sentence,
    password: 'password',
    image: Faker::LoremFlickr.image
  ) do |user|
    user.save!
    20.times do
      user.articles.build(
        title: Faker::Lorem.sentence,
        description: Faker::Lorem.sentence,
        body: Faker::Lorem.paragraph(sentence_count: 10)
      ) do |article|
        article.save!
        # article.tags << Tag.offset(rand(Tag.count)).first
        article.tags = Tag.all.sample(rand(1..3))
      end
    end
  end
end
