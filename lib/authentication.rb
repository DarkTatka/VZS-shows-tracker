# encoding: UTF-8
# This module is included in your application controller which makes
# several methods available to all controllers and views. Here's a
# common example you might add to your application layout file.
#
#   <% if logged_in? %>
#     Welcome <%=h current_user.username %>! Not you?
#     <%= link_to "Log out", logout_path %>
#   <% else %>
#     <%= link_to "Sign up", signup_path %> or
#     <%= link_to "log in", login_path %>.
#   <% end %>
#
# You can also restrict unregistered users from accessing a controller using
# a before filter. For example.
#
#   before_filter :login_required, :except => [:index, :show]
module Authentication
  def self.included(controller)
    controller.send :helper_method, :current_user, :logged_in?, :redirect_to_target_or_default
  end

  def current_user
    logger.debug session.inspect
    if session[:user_id] then
      begin
        @current_user ||= User.find(session[:user_id])
      rescue Exception => e
        logger.debug e.inspect
        session[:user_id] = nil
      end
      return @current_user
    else
      nil
    end
  end

  def logged_in?
    current_user
  end

  def login_required
    unless logged_in?
      logger.debug current_user.inspect
      flash[:error] = "Pro přístup k akcím se musíte nejdříve přihlásit."
      store_target_location
      redirect_to login_url
    end
  end

  def redirect_to_target_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end


  private

  def store_target_location
    session[:return_to] = request.url
  end
end

