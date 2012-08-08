#coding:utf-8
require File.expand_path("../../../lib/json/json_util",__FILE__)

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
       format.html{redirect_to d_save[0]}
     rescue
       flash[:notice] = "save fail,try again!" 
       format.html{render :new}
     end
    end
  end

  # PUT /demands/1
  # PUT /demands/1.json
  def update
    respond_to do |format|
     begin
      @result = get_result
      format.html { render :action => "edit", :id => params[:id] }
     rescue
      flash[:notice] = "select fail,try again!"
      format.html { redirect_to :action => "show", :id => params[:id] }
     end
    end
  end

  # DELETE /demands/1
  # DELETE /demands/1.json
  def destroy
    @demand = Demand.find(params[:id])
    @demand.destroy
    
    pas = Param.find_all_by_demand_id(params[:id])
    pas.each do |p|
      p.destroy
      i = Interface.find(p.interface_id)
      i.destroy unless i.nil?
    end

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
      interface.save! 
      #初始化demand对象并保存
      demand = Demand.new
      demand.interface_id = interface.id
      demand.title = params[:title]
      demand.host = interface.host
      demand.save!
      d, i = demand,interface
    end
    
    #根据参数信息创建对应的接口
    def init_by_param(did, iid, demand, param)
      inter_hash, child_hash = [], []
      if param
        #初始化接口并保存
        param.each do |p|
          interface = Interface.new
          interface.host = p[":host"].strip
          interface.param = p[":param"].strip
          interface.result = p[":result"].strip
          interface.save!
          inter_hash << interface.param.to_s
          inter_hash << interface.id.to_i
          child_hash << p[":parent"].to_s
          child_hash << interface.id
        end
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
        pa.save!
      end
      if param
        #初始化interface参数对象并保存
        param.each do |d|
          pa = Param.new
          pa.demand_id = did
          pa.interface_id = inter_hash["#{d[':param']}"]
          pa.name = d[":param"]
          pa.kind = d[":type"]
          pa.children_interface_id = child_hash["#{d[":param"]}"].to_i
          pa.save!
        end
      end
    end

    #根据录制的过程和输入参数返回结果
    def get_result
      return "demand id 缺失！" if params[:id].nil?
      demand = Demand.find(params[:id])
      return "demand不存在！" if demand.nil?
      trunk = Interface.find(demand.interface_id)
      return "接口(id:#{demand.interface_id})不存在！" if trunk.nil?
      get_interface_result(trunk.id, params[:id])
    end

    #根据已知接口返回最终结果
    def get_interface_result iid, did
      trunk = Interface.find(iid)
      url = trunk.host
      ps = trunk.param.split(/\s+/)
      ps.each do |p|
        url += "&" if url.include?("=")
        url += "#{p}="
        branch = Param.find_by_interface_id_and_name(trunk.id,p)
        branch = Param.find_by_demand_id_and_name(did,p) if branch.nil?
        if branch.nil?
          return "参数(did:#{did} name:#{p})不存在！"
        else
          if branch.kind == 0
            url += params[p.to_sym]
          else
            url += get_interface_result(branch.children_interface_id,did)   
          end
        end
      end
      keys = trunk.result.split(/\s+/)
      puts "url info :#{url}"
      results = JsonUtil.get_results(keys,url)
      results.join()
    end

end
