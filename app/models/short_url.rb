class ShortUrl < ApplicationRecord
  validates :original_url, presence: true
  validates :original_url, url: true
end
