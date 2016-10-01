module Microposts
  def add_n_microposts(n, user, content = nil)
  	content = "Lorem ipsum" unless content
    n.times do
      FactoryGirl.create(:micropost, user: user, content: content)
    end
  end
end