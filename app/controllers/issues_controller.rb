class IssuesController < ApplicationController
  # GET /issues
  # GET /issues.json

  def upvote
    issue = Issue.find(params[:id])
    # raise issue.inspect
    issue.add_upvote
    issue.save
    redirect_to :back    
  end

  def downvote
    issue = Issue.find(params[:id])
    issue.add_downvote
    issue.save
    redirect_to :back
  end

  def repo_issues
    @repo = Repo.find_by_owner_name_and_name(params[:owner], params[:repo])
    @issues = @repo.issues
    
    render 'repos/issues/index'

    # respond_to do |format|
    #   format.html # index.html.erb
    #   format.json { render json: @issues }
    # end
  end

  def index
    @issues = Issue.all


      # Get all issues
      # sorts all issues by issue.popularity
     # Issue.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @issues }
    end
  end

  # GET /issues/1
  # GET /issues/1.json
  def show
    repo = Repo.find_by_owner_name_and_name(params[:owner], params[:repo])

    @issue = Issue.find_by_repo_id_and_git_number(repo.id, params[:git_number])

    github_connection = GithubConnection.new(params[:owner], params[:repo], params[:git_number])
    if @issue.updated?(github_connection)
       RefreshWorker.perform_async(@issue, github_connection)
      flash[:notice] = "Updating issue from Github, please refresh"
    end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @issue }
    end
  end

  # GET /issues/new
  # GET /issues/new.json
  def new
    @issue = Issue.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @issue }
    end
  end

  # GET /issues/1/edit
  def edit
    @issue = Issue.find(params[:id])
  end

  # POST /issues
  # POST /issues.json
  def create
    @issue = Issue.new(params[:issue])

    respond_to do |format|
      if @issue.save
        format.html { redirect_to @issue, notice: 'Issue was successfully created.' }
        format.json { render json: @issue, status: :created, location: @issue }
      else
        format.html { render action: "new" }
        format.json { render json: @issue.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /issues/1
  # PUT /issues/1.json
  def update
    @issue = Issue.find(params[:id])

    respond_to do |format|
      if @issue.update_attributes(params[:issue])
        format.html { redirect_to @issue, notice: 'Issue was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @issue.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /issues/1
  # DELETE /issues/1.json
  def destroy
    @issue = Issue.find(params[:id])
    @issue.destroy

    respond_to do |format|
      format.html { redirect_to issues_url }
      format.json { head :no_content }
    end
  end
end
