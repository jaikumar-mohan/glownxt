class UsersDatatable
  delegate :params, :h, :link_to, to: :@view

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
        sEcho: params[:sEcho].to_i,
        iTotalRecords: User.count,
        iTotalDisplayRecords: users.total_entries,
        aaData: data
    }
  end

  private

  #def data
  #  users.map do |user|
  #    [
  #        gravatar_for user, size: 40,
  #        h(user.name),
  #        link_to(user.handle, user),
  #        if user.company_relationship.present?
  #        user.company.company_name
  #        end
  #        if user.microposts.present?
  #        user.microposts.count
  #        end
  #        if current_user.admin? && !current_user?(user)
  #        link_to "delete", user, method: :delete, data: {confirm: "You sure?"}
  #        end
  #    ]

  def users
    @users ||= fetch_users
  end

  def fetch_users
    users = User.order("#{sort_column} #{sort_direction}")
    users = users.page(page).per_page(per_page)
    if params[:sSearch].present?
      users = users.where("name like :search or nick like :search", search: "%#{params[:sSearch]}%")
    end
    users
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column
    columns = %w[name nick]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end
end