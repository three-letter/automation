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
    @all_params = []
    all_params = Param.find_all_by_demand_id(params[:id])
    all_params.each do |p|
      @all_params << p.name if p.kind == 0
    end
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
    @demand = params[:demand]
    @interface = params[:interface]
    respond_to do |format|
     begin
       d_save = init_by_demand(@demand)
       i_save = init_by_param(d_save[0].id, d_save[1].id, @demand, @interface) 
       format.html{redirect_to @demand}
     rescue
        format.html{render :new}
     end
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
    #根据demand信息创建对应的接口
    def init_by_demand demand
      return if demand.nil? || demand.empty?
      #初始化demand接口并保存
      type, children = 0, 0
      interface = Interface.new
      demand.each do |d|
        if d[":host"]
          interface.host = d[":host"].strip
          interface.param = d[":param"].strip
          interface.result = d[":result"].strip
          type = d[":type"].to_i
          children = d[":parent"].to_i
        else
          interface.param += " #{d[':param'].strip}"
        end
      end
      interface.save 
      #初始化demand对象并保存
      demand = Demand.new
      demand.interface_id = interface.id
      demand.title = params[:title]
      demand.host = interface.host
      demand.save
      d, i = demand,interface
    end
    
    #根据参数信息创建对应的接口
    def init_by_param(did, iid, demand, param)
      inter_hash, child_hash = [], []
      #初始化接口并保存
      param.each do |p|
        interface = Interface.new
        interface.host = p[":host"].strip
        interface.param = p[":param"].strip
        interface.result = p[":result"].strip
        interface.save
        inter_hash << interface.param.to_s
        inter_hash << interface.id.to_i
        child_hash << p[":parent"].to_s
        child_hash << interface.id
      end
      inter_hash = Hash[*inter_hash]
      child_hash = Hash[*child_hash]
      #初始化demand参数对象并保存
      demand.each do |d|
        pa = Param.new
        pa.demand_id = did
        pa.interface_id = iid
        pa.name = d[":param"]
        pa.kind = d[":type"]
        pa.children_interface_id = child_hash["#{d[':param']}"].to_i
        pa.save
      end
      #初始化interface参数对象并保存
      param.each do |d|
        pa = Param.new
        pa.demand_id = did
        pa.interface_id = inter_hash["#{d[':param']}"]
        pa.name = d[":param"]
        pa.kind = d[":type"]
        pa.children_interface_id = child_hash["#{d[":param"]}"].to_i
        pa.save
      end

    end

end
