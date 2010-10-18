require 'sinatra'
require 'utils'

#Para habilitar el soporte de sesiones

enable :sessions

#El método helpers inyecta el código definido en el bloque en el ámbito del contexto de respuestas:
#los métodos y variables aquí definidos estarán disponibles tanto a controladores como a vistas.
helpers do 
    def my_ip 
        #devolvemos una llamada al método `local_ip` que devuelve la ip de la computadora actual
        #está definido en utils.rb
        local_ip
    end

end

class User 
    attr_accessor :visits
    attr_writer :username
    #este método es nuestro: ver utils.rb
    default_attr_reader :username => "Anonymous", :authenticated=>false
    
    #Guarda en una variable de clase los usuarios
    @@users = []
    
    #Devuelve los usuarios de la clase
    def self.users 
        @@users
    end

    #Agrega la instancia presente a los usuarios de la clase
    def initialize(username=nil) 
        @username = username if username
        @authenticated = true if username
        @visits = 1 
        @@users << self
    end

    #Saca al presente usuario de la clase
    def logout 
        @@users.delete self
    end

    def new_visit 
        @visits += 1
    end
end

get '/' do 
    @user = session[:user] || User.new  
    @users = User.users
    session[:user].new_visit if session[:user]
    erb :index 
end

get '/login' do
    erb :login
end

post '/login' do 
    session[:user] = User.new(params[:username]) unless session[:user]
    redirect '/'
end

