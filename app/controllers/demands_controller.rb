class DemandsController < ApplicationController
  # GET /demands
  # GET /demands.json
  def index
    @demands = Demand.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @demands }
    end
  end

  # GET /demands/1
  # GET /demands/1.json
  def show
    @demand = Demand.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @demand }
    end
  end

  # GET /demands/new
  # GET /demands/new.json
  def new
    @demand = Demand.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @demand }
    end
  end

  # GET /demands/1/edit
  def edit
    @demand = Demand.find(params[:id])
  end

  # POST /demands
  # POST /demands.json
  def create
    @title = params[:title]
    @host = params[:host]
    @demand_param = ""
    params[:param].each do |p|
#param = Param.new(p)
      pa = Param.new(p)
      @demand_param << p.to_s
    end
    @demand_param_type = params[:demand_param_type]
    @demand_result = params[:demand_result]

    respond_to do |format|
      format.html{render :show}
    end
  end

  # PUT /demands/1
  # PUT /demands/1.json
  def update
    @demand = Demand.find(params[:id])

    respond_to do |format|
      if @demand.update_attributes(params[:demand])
        format.html { redirect_to @demand, notice: 'Demand was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @demand.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /demands/1
  # DELETE /demands/1.json
  def destroy
    @demand = Demand.find(params[:id])
    @demand.destroy

    respond_to do |format|
      format.html { redirect_to demands_url }
      format.json { head :no_content }
    end
  end
end
