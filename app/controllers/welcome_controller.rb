require 'amazon/ecs'

class WelcomeController < ApplicationController
  def index
  end
end
require 'amazon/ecs'




# default options:
#  options[:version] => "2013-08-01"
#  options[:service] => "AWSECommerceService"
Amazon::Ecs.configure do |options|
  options[:AWS_access_key_id] = 'AKIAI7BQN2XU7DRSFWOA'
  options[:AWS_secret_key] = 'LwmVpowUiv97NvAp8Yt7uHKIvvJYOLvldz9A9dRp'
  options[:associate_tag] = '[your associate tag]'
end

# to overwrite the whole options
# Amazon::Ecs.options = { ... }

# options will be merged with the default options
res = Amazon::Ecs.item_search('ruby', {:response_group => 'Medium', :sort => 'salesrank'})

# search amazon uk
res = Amazon::Ecs.item_search('ruby', :country => 'uk')

# search all items, default search index: Books
res = Amazon::Ecs.item_search('ruby', :search_index => 'All')

res.is_valid_request?
res.has_error?
res.error                                 # error message
res.total_pages
res.total_results
res.item_page                             # current page no if :item_page option is provided

# find elements matching 'Item' in response object
res.items.each do |item|
  # retrieve string value using XML path
  item.get('ASIN')
  item.get('ItemAttributes/Title')

  # return Amazon::Element instance
  item_attributes = item.get_element('ItemAttributes')
  item_attributes.get('Title')

  item_attributes.get_unescaped('Title') # unescape HTML entities
  item_attributes.get_array('Author')    # ['Author 1', 'Author 2', ...]
  item_attributes.get('Author')          # 'Author 1'

  # return a hash object with the element names as the keys
  item.get_hash('SmallImage') # {:url => ..., :width => ..., :height => ...}

  # return the first matching path
  item_height = item.get_element('ItemDimensions/Height')
  item_height.attributes['Units']        # 'hundredths-inches'

  # there are two ways to find elements:
  # 1) return an array of Amazon::Element
  reviews = item.get_elements('EditorialReview')
  reviews.each do |review|
    el.get('Content')
  end

  # 2) return Nokogiri::XML::NodeSet object or nil if not found
  reviews = item/'EditorialReview'
  reviews.each do |review|
    el = Amazon::Element.new(review)
    el.get('Content')
  end
end