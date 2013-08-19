#obtain consumer key and secret frm dev.twitter.com
#check out https://github.com/arunagw/omniauth-twitter
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, "Q0yaXkG0lHsKSnJ2njGuNw", "H9b4iHJlkPHKcsXmNwTjfnZhRLjxh6zSpdN3GwPUUw"
  provider :facebook, '1376435482586536', '19ff6c3098b85cff28f86bf5d29add7f'
end