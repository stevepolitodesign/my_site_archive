module ApplicationHelper
  include Pagy::Frontend

  def gravatar_path(email:)
    hash = Digest::MD5.hexdigest(email)
    "https://www.gravatar.com/avatar/#{hash}"
  end

  def is_blog_post?
    params[:controller] == "posts" && params[:action] == "show"
  end

end