require "application_responder"

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html

  protect_from_forgery
  
  before_filter :set_locale
  before_filter :login_required
  before_filter :load_user
  before_filter :check_permission
    
  def set_locale
    # if params[:locale] is nil then I18n.default_locale will be used
    @localeParameter = Parameter.find_by_name('locale')
    if @localeParameter
      I18n.locale = @localeParameter.value
    end
  end
  
  def login_required
    if !session[:user]
      redirect_to(login_url)
    elsif !session[:role]
      redirect_to(profile_url)
    end
  end
  
  def load_user
    if session[:user]
      @user = Person.find(session[:user])
    end
  end
  
  def check_permission
    module_name = self.class.name.split('::')[0..-2].join('::')
    
    if module_name == 'Professor' && session[:role].id != Role::PROFESSOR
      redirect_to(root_url)
    elsif module_name == 'Student' && session[:role].id != Role::STUDENT
      redirect_to(root_url)
    elsif module_name == 'Admin' && session[:role].id != Role::ADMINISTRATOR
      redirect_to(root_url)
    end
  end
end
