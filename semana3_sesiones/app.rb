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
    

    #Ahora viene un poco de metaprogramación: crearemos un attr_reader que devuelva valores por defecto
    def self.metaclass
        class << self
            self
        end
    end

    #definiremos un método que recibe un hash y devuelve ya sea la variable de instancia o el valor por
    #defecto
    def self.default_attr_reader(hsh)
        hsh.each do |var, default| 
            metaclass.instance_eval do 
                define_method(var) do 
                    instance_variable_get(var) || default
                end        
            end
        end
    end

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