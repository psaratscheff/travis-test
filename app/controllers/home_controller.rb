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
      unless count[1] # Render error, unless no error
        render json: count[0], status: count[0]['meta']['code']
        return
      end
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
    result['data'].each do |post|
      transformed_post = {
        tags: post['tags'],
        username: post['user']['username'].to_s,
        likes: post['likes']['count'].to_i,
        url: post['images']['standard_resolution']['url'].to_s,
        caption: post['caption']['text'].to_s
      }
      array << transformed_post
    end
    return array # Don't listen to rubocop, it is NOT REDUNDANT!!
  end

  def insta_count(tag, access_token)
    url = 'https://api.instagram.com/v1/tags/' + tag.to_s + '?access_token=' + access_token.to_s
    response = HTTParty.get(url)
    result = JSON.parse(response.body)
    # {"meta"=>{"error_type"=>"OAuthParameterException", "code"=>400, "error_message"=>
    # "Missing client_id or access_token URL parameter."}}
    return result, false if result['meta']['code'] != 200
    return result['data']['media_count'], true
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
