module ValidationsOnViews::Common
  
  private

  def checkable_fields
    [ 'first_name', 'last_name', 'company_name', 'email', 'password', 'password_confirmation', 'company', 'body' ]
  end

  def check_common_fields(info, fields)
    fields.each do |field_name|
      if info[field_name.to_sym].blank?
        @errors[field_name] = conditional_message(field_name)
      end
    end
  end

  def has_email_format?(email)
    format = /^[_a-z0-9-]+(\.[_a-z0-9-]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*(\.[a-z]{2,4})$/
    format.match(email).present?
  end 

  def check_email?(info, with_existining_check = nil)
  	@errors = {}
    email = info[:email]

    if email.present?
      if has_email_format?(email) 
        unregistred_email if with_existining_check
      else
        @errors['email'] = "Email is invalid"
      end
    end
    @errors.present?
  end

  def check_email_registred_or_not(email)
    if email.present?
      @errors['email'] = has_email_format?(email) ? "Email is not yet registered" : "Email is invalid"
    else
      @errors['email'] = "Email is required"
    end
  end 

  def unregistred_email
    email_op = @user.errors.messages[:email]

    if email_op.present? && email_op[0] == "has already been taken"
      @errors['email'] = "Email has already been taken"
    end
  end

  def conditional_message(field_name)
    case field_name
      when 'tos'
        'must be accepted'
      when 'password_confirmation'
        'Verify Password is required'
      when 'body'
        'Comments is required'
      else
        "#{custom_message(field_name)} is required"
    end
  end

  def custom_message(field_name)
    field_name.split('_').
      map { |i| i == 'name' ? i : i.capitalize }.
      join(' ')
  end

  def check_focus_field(fields_array)
    @focus_field = fields_array.map { |field| [field, @errors[field]] if @errors[field].present? }.compact.first
  end 
end