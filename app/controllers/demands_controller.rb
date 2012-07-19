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
    @demand = Demand.new(params[:demand])
    respond_to do |format|
      title = params[:title]
      host = params[:host]
      demand_param_type = params[:demand_param_type]
      demand_param = params[:demand_param]
      children_host = params[:children_param]
      result = params[:demand_result]
    
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

  private
    #初始化页面提交的数据，依次为：title host param_type param children_host
    def init_param *args
      #init interface
      interface = Interface.new 
      interface.host = args[1]
      interface.params = args[3].join("-")
      interface.results = args[3]


    end
    
    #init demand
    def init_demand title, host
      demand = Demand.new
      demand.title = args[0]
      demand.host = args[1]
      demand
    end
    
    #init interface
    def init_interface host, type, param, children_host, result
      interfaces = [] #base interface
      interface = Interface.new
      interface.host = host
      interface.param = param.join("-")
      interface.results = result
      interfaces << interface
      if !children_host.nil?
        type.each_with_index do |t,i|
          next if t == 0

        end
      end
      interfaces
    end

end
