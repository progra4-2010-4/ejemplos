require 'sinatra'

class MusicAlbum 
    #Esta es una variable de clase
    @@genres = ["Alternative metal", 
    "Black metal", 
    "Death metal", 
    "Doom metal", 
    "Extreme metal", 
    "Gothic metal", 
    "Industrial metal", 
    "Neo-classical metal", 
    "Power metal", 
    "Progressive metal", 
    "Speed metal", 
    "Symphonic metal", 
    "Technical Death Metal", 
    "Thrash metal", 
    "Traditional heavy metal", 
    "Viking metal",]
    #el meta-método `attr_accessor` crea un accesor y un mutador para cada
    #uno de sus parámetros.
    #p.e., si lo llamásemos con attr_accessor :nombre
    #sería equivalente  a tener:
    #def nombre=(nuevo_nombre)
    # @nombre= nuevo_nombre
    #end
    #y
    #def nombre
    # return @nombre
    #end
    @@max_rating = 10    
    def self.genres; @@genres; end
    def self.max_rating; @@max_rating; end
    #en realidad, sería mejor usar una variable de instancia @genres
    #y acceder con la metaclase: 
    #class << self ; attr_reader :genres; end

    attr_accessor :artist, :description, :genre, :rating, :released, :title 
    
    #este es el constructor de la clase
    def initialize(artist, description, genre, rating, released, title)
       #aquí se inicializan todas las variables de instancia
       @artist, @description, @genre, @rating, @released, @title = artist, description, genre, rating, released, title 
    end

    def validation_errors
        errors = []
        errors << "El artista no puede estar en blanco " if @artist.strip.empty?
        errors << "El título no puede estar en blanco " if @title.strip.empty?
        Date.new *@released.split('-').collect{|e| e.to_i} rescue errors << "Fecha inválida"
        return errors
    end
end


get '/' do 
    erb :index
end

post '/discos' do 
    #Esta línea de abajo equivale a
    #@disco = MusicAlbum.new(params[:artist], params[:description], params[:genre]... )
    #pero no tenía ganas de volver a escribir eso...
    @album = MusicAlbum.new *params.sort.collect{|e| e[1]}
    return erb :show if @album.validation_errors.empty?
    #vuelve a mostrar el form si hay errores
    @errors = @album.validation_errors
    erb :new
end

get '/discos/new' do 
    erb :new
end

