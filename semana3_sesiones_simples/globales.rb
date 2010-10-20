require 'sinatra'

class Persistencia
    @@numeros = []
    def self.numeros 
        @@numeros
    end
end

get '/' do
    Persistencia.numeros << rand(4567)
    erb %{El servidor tiene esto #{Persistencia.numeros.inspect} <a href="/otro">Ir a otro lado</a>}
end

get '/otro' do 
    erb %{El servidor <strong>Sigue teniendo</strong> esto #{Persistencia.numeros.inspect} <a href="/">Agregarle mas cosas</a>}
end
