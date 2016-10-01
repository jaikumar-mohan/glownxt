require 'validations_on_views/common'

module ValidationsOnViews::SignUp

  include ValidationsOnViews::Common
  
  private

  def check_user_information
    info = params[:user]
    check_email?(info, false)
    check_common_fields(info, checkable_fields - [ "password", "password_confirmation", "company", "body" ])
  end

  def check_sign_up_information
    info = params[:user]
    check_email?(info, true)
    check_common_fields(info, checkable_fields + [ 'tos' ])
    check_password_fields(info)

    sign_up_1_field_order = %w{first_name last_name company_name email password password_confirmation}
    check_focus_field(sign_up_1_field_order)
  end

  def check_password_fields(info)
    if info[:password].present? && info[:password].length < 6
      @errors['password'] = "Password too short"
    end
    
    if info[:password_confirmation].present? && info[:password] != info[:password_confirmation]
      @errors['password_confirmation'] = "Verify Password doesn't match Password"
    end
  end
end