require 'sinatra'
require 'dm-core'
require 'dm-migrations'
enable :sessions

class Task 
#MIXINS
    include DataMapper::Resource
    property :id, Serial
    property :contenido, String

    belongs_to :user
end

class User 
    include DataMapper::Resource
    property :id, Serial
    property :name, String

    has n, :tasks
end

configure do 
    DataMapper.setup(:default, "sqlite:///#{Dir.pwd}/tasks.sqlite3")
    DataMapper.auto_upgrade!
end

get '/' do 
    @tasks = Task.all
    erb :index
end

post '/tasks/new' do 
    Task.create :contenido=>params["task"], :user => User.get(session[:user_id])
    #a= Task.new
    #a.contenido = params["task"]
    #a.save
    redirect '/'
end

post '/tasks/done/:id' do |id| 
    session[:done] ||= [] # session[:done]= session[:done] || []
    session[:done] << id.to_i
    redirect '/'
end

post '/users/new' do 
    u = User.first_or_create :name => params["username"]
    session[:user_id] = u.id
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
       <%if session[:user_id] %>
           <form method="post"  action="/tasks/new">
            <input type="text" name="task" placeholder="tu tarea aquí"/>
           </form>
       <%else%>
           <form method="post" action="/users/new">
               <input type="text" name="username" placeholder="¿quién sos?">
           </form>
       <%end%>
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
                 creada por <%=t.user.name%>
            </li>
        </form>
        <%end%>
       </ul>
    </body>
</html>

