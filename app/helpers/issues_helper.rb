module IssuesHelper

  def link_to_new_bounty_for(issue, opts = {})
    link_to "Issue Bounty", new_issue_bounty_path(issue.repo.owner_name, issue.repo.name, issue.git_number), :class => "btn btn-success btn-small", id: "new_link", remote: true
  end
end
