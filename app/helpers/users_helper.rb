module UsersHelper
  # Returns the Gravatar (http://gravatar.com/) for the given user.
  def gravatar_for(user, options = { size: 60 })
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    size = options[:size]
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: user.full_name, class: "gravatar")
  end

  def error_box(error_message)
    h content_tag(:div, error_message, class: "error-text")
  end

  def user_error_box(field_name)
    if current_user.errors[field_name].present?
      h content_tag(:span, current_user.errors[field_name].last, class: "error-text")
    end
  end  

  def sign_up_1_error_box(field_name)
    if @user.errors[field_name].present?
      h content_tag(:span, @user.errors[field_name].last, class: "error-text")
    end
  end

  def sign_up_3_error_box(field_name)
    if @company.errors[field_name].present?
      h content_tag(:span, @company.errors[field_name].last, class: "error-text")
    end
  end

  def universal_error_box(field_name)
    if @errors.present? && @errors[field_name].present?
      h content_tag(:span, @errors[field_name], class: "error-text")
    end
  end  

  def login_previous_email_value
    if params[:session].present? && params[:session][:email].present?
      params[:session][:email]
    end
  end

  def user_field_previous_value(field_name)
    if params[:user].present? && params[:user][field_name].present?
      params[:user][field_name]
    end
  end

  def login_field_with_focus
    if @errors.present?
      @errors['email'].present? ? 'email' : 'password'
    else
      'email'
    end
  end

  def custom_label_text(field_name)
    field_name.split('_').
      map { |i| i.capitalize }.
      join(' ')
  end
end