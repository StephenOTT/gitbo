class GithubWorker
  include Sidekiq::Worker

  sidekiq_options retry: false

  def perform(owner, repo)
     Repo.create_from_github(owner, repo) 
  end

end 
