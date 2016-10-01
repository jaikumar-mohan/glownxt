module ApplicationHelper
  # Returns the full title on a per-page basis.         # Documentation comment 

  def full_title(page_title) # Method definition
    base_title = "Glowfori" # Variable assignment
    if page_title.empty? # Boolean test
      base_title # Implicit return
    else
      "#{base_title} | #{page_title}" # String interpolation
    end
  end

  CLOUD_OPTS = {
      base: 0.7,
      units: 'em',
      var: 3,
      precision: 3,
      hl: 'hl'
  }

  def cloud_box(tags, options = {})
    options = CLOUD_OPTS.merge(options)

    total = tags.reduce(0) { |x, y| x + y[1] }.to_f

    content_tag :div, class: 'tag-cloud' do
      tags.map do |(text, weight, hl)|
        r = (options[:base] + (options[:var].to_f * (weight / total))).round(options[:precision])
        link_to text, companies_path(by_offer_tags: text), style: "font-size: #{r}#{options[:units]}", class: (hl ? options[:hl] : '')
      end.join(' ').html_safe
    end
  end

  def steps(current, *steps)
    render partial: 'shared/progress', locals: {
        steps: steps.flatten,
        current: current
    }
  end

  SIGNUP_STEPS = ['Sign up', 'Authenticate', 'Create']

  def signup_steps(current)
    steps(current, SIGNUP_STEPS)
  end

  def has_class(x, klass)
    (x || '').to_s.match(/\b#{Regexp.escape(klass.to_s)}\b/)
  end

  def add_class(x, *classes)
    (x || '').to_s << ' ' << classes.map(&:to_s).reject { |k| has_class(x, k) }.join(' ')
  end

  def remove_class(x, *classes)
    (x || '').to_s.gsub(/\b(?:#{classes.flatten.map { |t| Regexp.escape(t.to_s) }.join('|')})\b/, '')
  end

  # TODO: Hell-code. Requires refactoring.
  def combined_field(f, name, type, options = {})
    classes = 'combined-field input-prepend'
    required = options[:required]
    classes << ' input-append' if required

    errors_on = [options[:errors_on] || name].flatten

    err = nil
    if f.object
      hidden_errors = errors_on.inject({}) do |o, field|
        if f.object.errors.has_key?(field)
          o[field] = f.object.errors.delete(field)
          err ||= o[field].first
        end
        o
      end

      has_errors = hidden_errors.try(:any?)
    else
      hidden_errors = nil
    end

    classes << ' combined-error' if has_errors

    label_opts = options[:label_options] || {}
    label_opts[:class] = add_class(label_opts[:class], 'add-on')

    field_opts = options[:field_options] || {}
    field_opts[:class] = add_class(field_opts[:class], 'no-left-border')
    field_opts[:class] = add_class(field_opts[:class], 'no-right-border') if required

    ret = content_tag :div, class: classes do
      [
          f.label(name, options.delete(:label_title), label_opts),
          f.__send__(type, name, field_opts),
          required && content_tag(:div, '*', class: 'add-on requiredmarker')
      ].select { |x| x }.join.html_safe
    end

    if has_errors
      ret = content_tag :div, class: 'combined-field-errors' do
        (ret + content_tag(:div, err, class: 'error-text')).html_safe
      end
    end

    hidden_errors.each { |k, v| f.object.errors[k] = v } if hidden_errors

    ret
  end

  def active_tab?(title)
    @active_tab == title ? 'current' : ''
  end

  def random_tag_cloud(tags, classes)
    return [] if tags.empty?

    tags.each do |tag|
      yield tag, classes[[0, 1, 2, 3, 4, 5, 6].sample]
    end
  end
end
