class Users::PasswordsController < Devise::PasswordsController
  protected
    def after_resetting_password_path_for(resource)
      projects_path
    end
end