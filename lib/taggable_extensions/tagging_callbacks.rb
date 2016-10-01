module TaggableExtensions::TaggingCallbacks

  def self.included(base)
    base.class_eval do
      counter_culture :tag, column_name: Proc.new {|model| "#{model.context}_count" }
    end
  end

end