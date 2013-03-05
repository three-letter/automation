#coding: utf-8
require 'net/ssh'

class AdController < ApplicationController
  def index
  end

  def shortcut
    begin
      ad = params
      ad = sym_hash ad 
      ad.delete(:utf8)
      ad.delete(:authenticity_token)
      ad.delete(:controller)
      ad.delete(:action)
      ad = ad.inject({}) do |m,(k,v)| 
        v = sym_hash v
        m[k] = v
        m
      end
      file = Time.now.to_i
      path = File.expand_path("../../../../../demo/http/ad",__FILE__)
      system "ruby #{path}/ad shortcut '#{ad}' '#{file}'"
      flash[:notice] = read_info file
      system "rm -f #{path}/lib/cli/#{file}.txt"
    rescue
      flash[:notice] = "程序异常"
    end
    respond_to do |format|
      format.js
    end
  end

  private
    def sym_hash hash
      hash.each_with_object({}) { |(k,v), h| h[k.to_sym] = v }
    end
    def read_info file
      info = []
      File.open("/home/linson/work/demo/http/ad/lib/cli/#{file}.txt","r") do |f|
        while line = f.gets
          info << line if line && !line.empty?
        end
      end
      info.join
    end
end
