require 'sinatra'

enable :sessions

class Task 
    TaskFile = "tasks.txt"
    attr_accessor :id, :contenido
    def initialize(contenido, id=nil) 
        @contenido = contenido
        unless id 
            if File.exists?(TaskFile)
                @id = File.open(TaskFile, 'r').count + 1
            else
                @id = 1
            end
        else
            @id = id
        end
    end 

    def self.all
        return [] unless File.exists?(TaskFile)
        ary = []
        File.open(TaskFile, 'r').readlines.each do |linea| 
            id = linea.split(",").first
            contenido = linea.split(",")[1..-1].join ","
            ary << Task.new(contenido, id)
        end
        ary
    end

    def self.create(content) 
        task = Task.new content
        File.open(TaskFile, 'a') do |file| 
            file.write "#{task.id},#{task.contenido}\n"
        end
    end
end

get '/' do 
    @tasks = Task.all
    erb :index
end

post '/tasks/new' do 
    Task.create params["task"]
    redirect '/'
end

post '/tasks/done/:id' do |id| 
    session[:done] ||= [] # session[:done]= session[:done] || []
    session[:done] << id
    redirect '/'
end

__END__

@@index
<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8" />
        <style>
            .hecha{
                text-decoration: line-through;
            }
        </style>
    </head>
    <body>
       <h2>Vil clon del vil clon de thingler</h2>
       <%=session[:done]%>
       <form method="post"  action="/tasks/new">
        <input type="text" name="task" placeholder="tu tarea aquí"/>
       </form>
       <ul>
        <% @tasks.each do |t| %>
                
                <%unless session[:done] && session[:done].include?(t.id)%>
                    <li><%= t.contenido  %>
                    <form method="post" action="/tasks/done/<%=t.id%>">
                        <input type="submit" value="terminar">
                    </form>
                <%else%>
                    <li class="hecha"><%= t.contenido  %>
                <%end%>
            </li>
        </form>
        <%end%>
       </ul>
    </body>
</html>

