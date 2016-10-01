require 'validations_on_views/common'

module ValidationsOnViews::Contact

  include ValidationsOnViews::Common
  
  private

  def has_wrong_ops?
    ops = params[:contact]

    check_email?(ops, false)
    check_common_fields(ops, checkable_fields - [ "company_name", "password", "password_confirmation" ])

    contact_field_order = %w{first_name last_name email company}
    check_focus_field(contact_field_order)
    
    @errors.present?
  end
end