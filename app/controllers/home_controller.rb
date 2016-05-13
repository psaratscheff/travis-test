# The only controller
class HomeController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def index
  end

  def instagram_tag
    require 'httparty'

    tag = params[:tag]
    access_token = params[:access_token] ||= $access_token

    # TODO: ACTIVAR EL CHEQUEO DE ACCESS_TOKEN!!
    if tag.nil? # || access_token.nil?
      render json: { error: "Please enter the parameters 'tag' and 'access_token'" }, status: 400
      return
    end

    begin
      count = insta_count(tag, access_token)
      result = insta_recent_media(tag, access_token)
      posts = insta_process_posts(result)
      render json: { metadata: { total: count }, posts: posts, version: $version }
    rescue => ex
      logger.error ex.message
      puts 'error 1001'
      render json: { error: ex.message }, status: 503
    end
  end

  private

  def insta_process_posts(result)
    array = []
    foreach result['data'] do |post|
      transformed_post = {
        tags: post['tags'],
        username: post['user']['username'],
        likes: post['likes']['count'],
        url: post['images']['standard_resolution']['url'],
        caption: ['caption']['text']
      }
      array << transformed_post
    end
  end

  def insta_count(tag, access_token)
    url = 'https://api.instagram.com/v1/tags/' + tag + '?access_token=' + access_token
    response = HTTParty.get(url)

    JSON.parse(response.body)['data']['media_count']
  end

  def insta_recent_media(tag, access_token)
    url = 'https://api.instagram.com/v1/tags/' + tag + '/media/recent?'
    url += 'access_token=' + access_token # + 'count=' + 10
    response = HTTParty.get(url)

    JSON.parse(response.body)
  end
end

# , headers:
# {
#   'Content-Type' => 'application/json',
# })
