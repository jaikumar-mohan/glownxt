module ContactsHelper
  def contact_field_previous_value(field_name)
    if params[:contact].present? && params[:contact][field_name].present?
      params[:contact][field_name]
    end
  end

  def contact_field_with_focus
    if @errors.present?
      ( @errors['first_name'].present? ||
        @errors['last_name'].present? ||
        @errors['company'].present? ||
        @errors['body'].present? ) ? 'first_name' : 'email'
    else
      'first_name'
    end
  end
end
