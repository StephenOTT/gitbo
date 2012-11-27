class ReposController < ApplicationController
  # GET /repos
  # GET /repos.json

  rescue_from Octokit::NotFound, :with => :repo_not_found

  def index
    @repos = Repo.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @repos }
    end
  end

  def show_owner
    @repos = Repo.find_all_by_owner_name(params[:owner])
  end

  # GET /repos/1
  # GET /repos/1.json
  def show

    @repo = Repo.find_by_owner_name_and_name(params[:owner], params[:repo])

    @issues = @repo.issues
    # github_connection = GithubConnection.new(params[:owner], @repo.name)
    # if @repo.updated?(github_connection)
    #   RefreshReposWorker.perform_async(@repo.id)
    #   flash[:notice] = "Updating repo from Github, please refresh"
    # end
      
      #maybe autorefresh non missing issues?

      #missing numbers should be imported || refreshed

        # updated_issues.each do |issue|
        #     issue.refresh || issue.create_from_github(@repo.owner_name, @repo.name, issue.git_number)
        # end 
    
    # we will want to refresh the page soon as this code executes
    #because new issues have been updated/added to the page.
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @repo }
    end

  end

  # GET /repos/new
  # GET /repos/new.json
  def new

    debugger

    @repo = Repo.new
    1.times { @repo.issues.build}

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @repo }
    end
  end

  # GET /repos/1/edit
  def edit
    @repo = Repo.find(params[:id])
  end

  # POST /repos
  # POST /repos.json
  def create

    #don't run this job if the repo already exists
    #if there is already a repo with this name in the db, we know
   
      # if !Repo.find_by_name(params[:repo][:name])
        owner = params[:repo][:owner_name]
        repo_name = params[:repo][:name]

        repo = Repo.new(:owner_name => owner, :name => repo_name)
        repo = octokit_client.fetch_repo(repo)
        @repo = octokit_client.fetch_issues(repo)
        @repo.save

        flash[:notice] = 'Your repository and corresponding issues are being processed, please check back shortly'
        redirect_to :root

      # else
      #   flash[:error] = "Repository already exists."
      #   redirect_to :root
      # end
    

    # respond_to do |format|
    #   if @repo.save
    #     format.html { redirect_to @repo, notice: 'Repo was successfully created.' }
    #     format.json { render json: @repo, status: :created, location: @repo }
    #   else
    #     format.html { render action: "new" }
    #     format.json { render json: @repo.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  # PUT /repos/1
  # PUT /repos/1.json
  def update
    @repo = Repo.find(params[:id])

    respond_to do |format|
      if @repo.update_attributes(params[:repo])
        format.html { redirect_to @repo, notice: 'Repo was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @repo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /repos/1
  # DELETE /repos/1.json
  def destroy
    @repo = Repo.find(params[:id])
    @repo.destroy

    respond_to do |format|
      format.html { redirect_to repos_url }
      format.json { head :no_content }
    end
  end

  private

  def repo_not_found
    flash[:error] = "Repository not found. Please try again."
    redirect_to :back
  end

end
