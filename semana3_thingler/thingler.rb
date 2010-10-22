require 'sinatra'

class Task 
    TaskFile = "tasks.txt"
    
    def self.all 
        File.open(TaskFile, 'r').readlines rescue []
    end

    def self.save(content) 
        File.open(TaskFile, 'a') do |f| 
            f.write content + "\n"
        end
    end
end

get '/' do 
    @tasks = Task.all
    erb :index
end

post '/tasks/new' do 
    Task.save params["task"]
    redirect '/'
end

__END__

@@index
<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8" />
    </head>
    <body>
       <h2>Vil clon del vil clon de thingler</h2>
       <form method="post"  action="/tasks/new">
        <input type="text" name="task" placeholder="tu tarea aquí"/>
       </form>
       <ul>
        <% @tasks.each do |t| %>
            <li><%= t  %></li>
        <%end%>
       </ul>
    </body>
</html>

