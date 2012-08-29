module RGallery
  class Page < PhotoConfig
    include Enumerable

    def initialize photo_ids = [], options = {}
      @photo_ids = photo_ids
      super options
    end

    # a source is a hash of the form:
    # 'banner' => [{src: 'banner-HD', sizing: '2x'}, {src: 'banner-phone', sizing: '100w'}]
    # see: add_photo_sources
    def self.from_source sources
      page = self.create sources.keys, options

      @photos ||= sources.map do |key, srclist| 
        photo_class.new key, options.merge(:sources => srclist)
      end
    end

    def << photo_ids
      @photo_ids ||= []
      @photo_ids += [photo_ids].flatten
    end

    def add_photo_sources sources_hash
      sources_hash.each do |source|
        add_photo_w_sources source
      end
    end

    def add_photo_w_sources source
      raise ArgumentError, "Must be a hash, was: #{source}" unless source.kind_of? Hash
      key = source.keys.first
      srclist = source.values.first
      raise ArgumentError, "Hash value must be an Array, was: #{srclist}" unless srclist.kind_of? Array

      self.send :<<, key
      @photos ||= []
      @photos << photo_class.new(key, options.merge(:sources => srclist))
    end

    def photo_ids
      @photo_ids ||= []
    end   

    def photos
      @photos ||= photo_ids.map {|id| photo_class.new id, options } 
    end   

    delegate :empty?, to: :photos 

    def each &block
      photos.each {|photo| yield photo }
    end    
  end
end