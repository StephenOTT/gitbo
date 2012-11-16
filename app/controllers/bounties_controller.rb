class BountiesController < ApplicationController
  # GET /bounties
  # GET /bounties.json
  def index
    @bounties = Bounty.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @bounties }
    end
  end

  # GET /bounties/1
  # GET /bounties/1.json
  def show
    @bounty = Bounty.find(params[:id])


    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @bounty }
    end
  end

  # GET /bounties/new
  # GET /bounties/new.json
  def new
    @issue = Issue.find_by_git_number(params[:git_no])
    @bounty = Bounty.new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @bounty }
    end
  end

  # GET /bounties/1/edit
  def edit
    @bounty = Bounty.find(params[:id])
  end

  # POST /bounties
  # POST /bounties.json
  def create
    repo = Repo.find_by_owner_name_and_name(params[:owner], params[:repo])
    git_number = params[:git_no]
    issue = Issue.find_by_git_number_and_repo_id(git_number, repo.id)
    price = params[:price]

    @bounty = Bounty.new(
          :user_id => current_user.id,
          :issue_id => issue.id,
          :price => price)

    respond_to do |format|
      if @bounty.save
        format.html { redirect_to owner_repo_gitnumber_path(@bounty.issue.repo.owner_name, @bounty.issue.repo.name, @bounty.issue.git_number), notice: 'Bounty was successfully created.' }
        format.json { render json: @bounty, status: :created, location: @bounty }
      else
        format.html { render action: "new" }
        format.json { render json: @bounty.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /bounties/1
  # PUT /bounties/1.json
  def update
    @bounty = Bounty.find(params[:id])

    respond_to do |format|
      if @bounty.update_attributes(params[:bounty])
        format.html { redirect_to @bounty, notice: 'Bounty was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @bounty.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bounties/1
  # DELETE /bounties/1.json
  def destroy
    @bounty = Bounty.find(params[:id])
    @bounty.destroy

    respond_to do |format|
      format.html { redirect_to bounties_url }
      format.json { head :no_content }
    end
  end
end
