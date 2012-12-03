class ReposDatatable
  delegate :params, :h, :link_to, :vote_issue_path, :owner_repo_gitnumber_path, to: :@view

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: Issue.count,
      iTotalDisplayRecords: issues.total_entries,
      aaData: data

    }
  end

  private

  def data
    issues.collect do |issue|
      [
        if current_user
          link_to(vote_issue_path(issue.id, :upvote)), #need to add downvote that direction works
        
        link_to(truncate(issue.title, length:60), owner_repo_gitnumber_path(issue.repo_owner, issue.repo_name, issue.git_number)),
        link_to(issue.repo_name, owner_repo_path(issue.repo_owner, issue.repo_name)) + "/" h(issue.git_number),
        h(issue.comment_count),
        h(issue.vote_count), #need to pass class="votes"
        if current_user
          if issue.bounty_total == 0
            link_to(new_issue_bounty_path(issue.repo_owner, issue.repo, issue.git_number)),
          else 
            link_to(owner_repo_gitnumber_path(issue.repo_owner, issue.repo_name, issue.git_number), h(number_to_currency(issue.bounty_total, :raise => true, :precision => 0))),
          end
        else
          if issue.bounty_total == 0
            link_to(new_issue_bounty_path(issue.repo_owner, issue.repo, issue.git_number)),
          else 
            link_to(owner_repo_gitnumber_path(issue.repo_owner, issue.repo_name, issue.git_number), h(number_to_currency(issue.bounty_total, :raise => true, :precision => 0))),
          end
        end


      ]
    end
  end

  def issues
    @issues ||= fetch_issues
  end

  def fetch_issues
    issues = Issue.order("#{sort_column} #{sort_direction}").page(page).per_page(per_page)
    if params[:sSearch].present?
      issues.where("name like :search or category like :search", search: "%#{params[:sSearch]}%")
    end
    
    return issues
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