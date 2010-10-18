require 'sinatra'
require 'utils'

#El método helpers inyecta el código definido en el bloque en el ámbito del contexto de respuestas:
#los métodos y variables aquí definidos estarán disponibles tanto a controladores como a vistas.
helpers do 
    def my_ip 
        #devolvemos una llamada a 
        local_ip
    end
end



class User 
    attr_accessor :visits
    attr_writer :username
    #este método es nuestro: ver utils.rb
    default_attr_reader :username => "Anonymous"

    @@users = []

    def initialize(username=nil) 
        @username = username if username
        @visits = 1
    end

    def login 
        @visits += 1
        self.users << @username
    end

    def logout 
        self.users.delete @username
    end
end
