#### DEPRECATED on 11/27/2012 by Kevin M and Josh R ####

class GithubComments

    attr_accessor :repo, :info, :issue_no, :client, :issues, :name, :comments

    def initialize(owner, repo, number, comment)


    end 

    def self.post_comment(token, comment)
      # client = Octokit::Client.new(:oauth_token => token)
      # client.add_comment(comment.repo, comment.issue.git_number, comment.body)
    end

end