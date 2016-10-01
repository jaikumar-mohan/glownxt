class Entry < ActiveRecord::Base
  belongs_to :user
  #attr_accessible :brief, :body, :title, :tag_list

  default_scope { order('created_at desc') }

  validates_presence_of :user, :body, :title, :brief
  validates_length_of :title, maximum: 255

  def self.dates
    select(%q{to_char("entries"."created_at", 'YYYY-MM') as month}).
      reorder('month desc').
      group('month').
      map {|x| Time.new(*x.month.split('-'))}
  end

  def self.month(x)
    x = Time.at(x.to_i)
    where('created_at between ? and ?', x, x.end_of_month)
  rescue
    self
  end

  acts_as_taggable
end
