require 'validations_on_views/common'

module ValidationsOnViews::EditUserParams
  
  include ValidationsOnViews::Common

  private

  def update_params_are_valid?(with_email_on_exist_check = nil)
    info = params[:user]
    check_email?(info, false)
    check_common_fields(info, checkable_fields - [ "company_name", "password", "password_confirmation", "company", "body" ])

    if info[:password].present?
      @errors['password'] = "Password too short" if info[:password].length < 6
      @errors['password_confirmation'] = "Password confirmation doesn't match Password" if info[:password] != info[:password_confirmation]
    end

    if with_email_on_exist_check
      unregistred_email
    end

    @errors.present?
  end  
end