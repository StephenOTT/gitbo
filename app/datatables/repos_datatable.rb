class ReposDatatable
  delegate :params, :h, :link_to, :owner_repos_path, :owner_repo_path, to: :@view

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: Repo.count,
      iTotalDisplayRecords: repos.total_entries,
      aaData: data
    }
  end

  private

  def data
    repos.map do |repo|
      [
        link_to(repo.owner_name, owner_repos_path(repo.owner_name)) + " / " + link_to(repo.name, owner_repo_path(repo.owner_name, repo.name)),
        h(repo.popularity),
        h(repo.open_issues),
        h(repo.watchers),
        h(repo.issues_comment_count)
      ]
    end
  end

  def repos
    @repos ||= fetch_repos
  end

  def fetch_repos
    repos = Repo.order("#{sort_column} #{sort_direction}").page(page).per_page(per_page)
    if params[:sSearch].present?
      repos.where("name like :search or category like :search", search: "%#{params[:sSearch]}%")
    end
    
    return repos
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 25
    # check how to allow still to list by 10, 25, 50, all
  end

  def sort_column
    columns = %w[name popularity open_issues watchers issues_comment_count]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end
end